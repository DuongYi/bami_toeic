import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/presentation/controllers/auth_controller.dart';
import 'test_repository.dart';

part 'in_progress_store.freezed.dart';
part 'in_progress_store.g.dart';

/// Ảnh chụp 1 bài đang làm dở – lưu cục bộ để thoát app vẫn tiếp tục được.
@freezed
abstract class TakingSnapshot with _$TakingSnapshot {
  const TakingSnapshot._();

  const factory TakingSnapshot({
    required String testId,
    required String mode,
    required List<int> parts,
    required DateTime startedAt,

    /// Thi thử: số giây còn lại. Luyện tập: số giây đã làm.
    required int clockSeconds,
    @Default(0) int index,
    @Default(<String, String>{}) Map<String, String> answers,
    @Default(<String>[]) List<String> revealed,
    @Default(<String>[]) List<String> flagged,
    required int totalQuestions,
    required DateTime savedAt,
  }) = _TakingSnapshot;

  factory TakingSnapshot.fromJson(Map<String, dynamic> json) => _$TakingSnapshotFromJson(json);

  /// Khoá family của controller làm bài ("1,2,5").
  String get partsKey => parts.join(',');
  bool get isExam => mode == 'exam';
}

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) => SharedPreferences.getInstance();

@Riverpod(keepAlive: true)
InProgressStore inProgressStore(Ref ref) => InProgressStore(ref);

/// Bài làm dở theo user: lưu trên máy (dùng được offline) + đồng bộ bảng `in_progress`
/// để làm tiếp trên máy khác. Hai bên lệch nhau → lấy bản lưu sau cùng.
class InProgressStore {
  InProgressStore(this._ref);

  final Ref _ref;
  static const _legacyPrefix = 'in_progress/';

  String get _uid => _ref.read(currentUserIdProvider) ?? 'anon';
  String get _prefix => 'in_progress@$_uid/';

  /// Đề đã bỏ bài làm dở nhưng chưa xoá được trên server (mất mạng).
  String get _tombKey => 'in_progress_deleted@$_uid';

  Future<SharedPreferences> get _prefs => _ref.read(sharedPreferencesProvider.future);
  TestRepository get _repo => _ref.read(testRepositoryProvider);

  TakingSnapshot? _decode(String? raw) {
    if (raw == null) return null;
    try {
      return TakingSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null; // dữ liệu hỏng/khác phiên bản → coi như không có
    }
  }

  /// Bản lưu trước khi tách theo user → thuộc user đang đăng nhập.
  Future<void> _adoptLegacy(SharedPreferences prefs) async {
    if (_uid == 'anon') return;
    for (final key in prefs.getKeys().where((k) => k.startsWith(_legacyPrefix)).toList()) {
      final raw = prefs.getString(key);
      if (raw != null) await prefs.setString('$_prefix${key.substring(_legacyPrefix.length)}', raw);
      await prefs.remove(key);
    }
  }

  Future<Map<String, TakingSnapshot>> _readLocal(SharedPreferences prefs) async {
    await _adoptLegacy(prefs);
    final out = <String, TakingSnapshot>{};
    for (final key in prefs.getKeys().where((k) => k.startsWith(_prefix))) {
      final snap = _decode(prefs.getString(key));
      if (snap != null) out[snap.testId] = snap;
    }
    return out;
  }

  Future<void> _writeLocal(SharedPreferences prefs, TakingSnapshot snap) =>
      prefs.setString('$_prefix${snap.testId}', jsonEncode(snap.toJson()));

  Future<void> _push(TakingSnapshot snap) =>
      _repo.saveInProgress(snap.testId, snap.toJson(), snap.savedAt);

  /// Xoá trên server những bài đã bỏ khi offline.
  Future<void> _flushDeletes(SharedPreferences prefs) async {
    final tombs = prefs.getStringList(_tombKey) ?? const <String>[];
    if (tombs.isEmpty) return;
    final left = <String>[];
    for (final id in tombs) {
      try {
        await _repo.deleteInProgress(id);
      } catch (_) {
        left.add(id);
      }
    }
    await prefs.setStringList(_tombKey, left);
  }

  /// Gộp bản trên máy với server: bản nào lưu sau thắng; bản máy mới hơn thì đẩy lên.
  Future<Map<String, TakingSnapshot>> _sync({String? testId}) async {
    final prefs = await _prefs;
    final local = await _readLocal(prefs);
    if (testId != null) local.removeWhere((k, _) => k != testId);
    try {
      await _flushDeletes(prefs);
      final tombs = (prefs.getStringList(_tombKey) ?? const <String>[]).toSet();
      final remote = <String, TakingSnapshot>{};
      for (final r in await _repo.fetchInProgress(testId: testId)) {
        final snap = tombs.contains(r.testId) ? null : _decode(jsonEncode(r.snapshot));
        if (snap != null) remote[r.testId] = snap;
      }
      final out = <String, TakingSnapshot>{};
      for (final id in {...local.keys, ...remote.keys}) {
        final l = local[id], r = remote[id];
        if (r != null && (l == null || r.savedAt.isAfter(l.savedAt))) {
          await _writeLocal(prefs, r);
          out[id] = r;
        } else if (l != null) {
          if (r == null || l.savedAt.isAfter(r.savedAt)) await _push(l);
          out[id] = l;
        }
      }
      return out;
    } catch (_) {
      return local; // offline
    }
  }

  Future<TakingSnapshot?> read(String testId) async => (await _sync(testId: testId))[testId];

  Future<Map<String, TakingSnapshot>> readAll() => _sync();

  /// Đẩy lên server tối đa mỗi 20 giây / đề (lưu trên máy thì luôn ngay).
  static const _pushEvery = Duration(seconds: 20);
  final _lastPush = <String, DateTime>{};

  /// Lưu trên máy ngay; server lỗi (mất mạng) thì lần đọc sau sẽ đẩy lên.
  /// [force]: đẩy lên ngay (khi thoát màn làm bài / app xuống nền).
  Future<void> save(TakingSnapshot snap, {bool force = false}) async {
    final prefs = await _prefs;
    await _writeLocal(prefs, snap);
    final tombs = prefs.getStringList(_tombKey) ?? const <String>[];
    if (tombs.contains(snap.testId)) {
      await prefs.setStringList(_tombKey, [...tombs.where((t) => t != snap.testId)]);
    }
    final last = _lastPush[snap.testId];
    if (!force && last != null && DateTime.now().difference(last) < _pushEvery) return;
    try {
      await _push(snap);
      _lastPush[snap.testId] = DateTime.now();
    } catch (_) {}
  }

  Future<void> clear(String testId) async {
    final prefs = await _prefs;
    await prefs.remove('$_prefix$testId');
    try {
      await _repo.deleteInProgress(testId);
    } catch (_) {
      final tombs = prefs.getStringList(_tombKey) ?? const <String>[];
      await prefs.setStringList(_tombKey, {...tombs, testId}.toList());
    }
  }

  /// Bỏ bài làm dở (nút "Làm lại từ đầu") và làm mới các provider đang hiển thị nó.
  Future<void> discard(String testId) async {
    await clear(testId);
    _ref
      ..invalidate(inProgressProvider(testId))
      ..invalidate(inProgressAllProvider);
  }
}

/// Bài làm dở của 1 đề (null nếu không có).
@riverpod
Future<TakingSnapshot?> inProgress(Ref ref, String testId) {
  ref.watch(currentUserIdProvider); // đổi tài khoản → đọc lại
  return ref.watch(inProgressStoreProvider).read(testId);
}

/// Tất cả bài làm dở (để gắn nhãn "Đang làm dở" ở danh sách đề).
@riverpod
Future<Map<String, TakingSnapshot>> inProgressAll(Ref ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(inProgressStoreProvider).readAll();
}
