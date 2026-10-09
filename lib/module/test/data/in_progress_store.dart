import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class InProgressStore {
  InProgressStore(this._ref);

  final Ref _ref;
  static const _prefix = 'in_progress/';

  Future<SharedPreferences> get _prefs => _ref.read(sharedPreferencesProvider.future);

  Future<TakingSnapshot?> read(String testId) async {
    final raw = (await _prefs).getString('$_prefix$testId');
    if (raw == null) return null;
    try {
      return TakingSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null; // dữ liệu hỏng/khác phiên bản → coi như không có
    }
  }

  Future<Map<String, TakingSnapshot>> readAll() async {
    final prefs = await _prefs;
    final out = <String, TakingSnapshot>{};
    for (final key in prefs.getKeys().where((k) => k.startsWith(_prefix))) {
      final snap = await read(key.substring(_prefix.length));
      if (snap != null) out[snap.testId] = snap;
    }
    return out;
  }

  Future<void> save(TakingSnapshot snap) async =>
      (await _prefs).setString('$_prefix${snap.testId}', jsonEncode(snap.toJson()));

  Future<void> clear(String testId) async => (await _prefs).remove('$_prefix$testId');

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
Future<TakingSnapshot?> inProgress(Ref ref, String testId) =>
    ref.watch(inProgressStoreProvider).read(testId);

/// Tất cả bài làm dở (để gắn nhãn "Đang làm dở" ở danh sách đề).
@riverpod
Future<Map<String, TakingSnapshot>> inProgressAll(Ref ref) =>
    ref.watch(inProgressStoreProvider).readAll();
