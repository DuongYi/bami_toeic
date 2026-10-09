import 'dart:convert';

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/notifications/reminder_service.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../../test/data/in_progress_store.dart';
import 'goals_repository.dart';

part 'study_store.freezed.dart';
part 'study_store.g.dart';

/// Hoạt động học trong 1 ngày (đếm trên máy này).
@freezed
abstract class DayLog with _$DayLog {
  const DayLog._();

  const factory DayLog({
    /// Số câu đề đã làm (kể cả luyện sổ câu sai)
    @Default(0) int questions,

    /// Số câu sổ câu sai đã luyện lại
    @Default(0) int mistakes,

    /// Số lượt ôn flashcard
    @Default(0) int words,

    /// Số đoạn chép chính tả đã chấm
    @Default(0) int dictations,
  }) = _DayLog;

  factory DayLog.fromJson(Map<String, dynamic> json) => _$DayLogFromJson(json);

  bool get isActive => questions + words + dictations > 0;

  DayLog operator +(DayLog o) => DayLog(
    questions: questions + o.questions,
    mistakes: mistakes + o.mistakes,
    words: words + o.words,
    dictations: dictations + o.dictations,
  );
}

/// Mục tiêu cá nhân.
@freezed
abstract class GoalSettings with _$GoalSettings {
  const GoalSettings._();

  const factory GoalSettings({
    int? targetScore,
    DateTime? examDate,
    @Default(20) int dailyQuestions,
    @Default(15) int dailyWords,
    @Default(3) int dailyDictations,

    /// Giờ nhắc học, dạng phút trong ngày (null = tắt nhắc)
    int? reminderMinutes,
  }) = _GoalSettings;

  factory GoalSettings.fromJson(Map<String, dynamic> json) => _$GoalSettingsFromJson(json);

  TimeOfDay? get reminderTime => reminderMinutes == null
      ? null
      : TimeOfDay(hour: reminderMinutes! ~/ 60, minute: reminderMinutes! % 60);
}

enum StudyEvent { questions, mistakes, words, dictations }

String dayKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

@Riverpod(keepAlive: true)
StudyStore studyStore(Ref ref) => StudyStore(ref);

/// Nhật ký học + mục tiêu của user đang đăng nhập.
/// Ghi vào máy trước (dùng được khi offline), rồi đồng bộ lên Supabase:
/// - số liệu ngày: phần chưa gửi nằm trong `pending`, gửi bằng RPC cộng dồn;
/// - mục tiêu: upsert `user_goals`, lỗi mạng thì đánh dấu `dirty` để gửi lại.
class StudyStore {
  StudyStore(this._ref);

  final Ref _ref;

  /// Giữ tối đa ~1 năm để chuỗi ngày dài vẫn đếm đúng.
  static const _keepDays = 400;

  /// Ghi mỗi câu trả lời không nên gọi mạng mỗi lần: gửi dồn / đọc lại server có giãn cách.
  static const _flushEvery = Duration(seconds: 30);
  static const _fetchEvery = Duration(minutes: 2);
  DateTime? _lastFlush;
  DateTime? _lastFetch;
  String? _syncedUid;

  /// Giờ nhắc trên máy đã đặt theo mục tiêu của user nào (đổi tài khoản → đặt lại).
  String? _reminderUid;
  int? _reminderMinutes;

  Future<void> _applyReminder(GoalSettings g) async {
    if (_reminderUid == _uid && _reminderMinutes == g.reminderMinutes) return;
    _reminderUid = _uid;
    _reminderMinutes = g.reminderMinutes;
    try {
      await _ref.read(reminderServiceProvider).schedule(g.reminderTime);
    } catch (_) {}
  }

  /// Gọi khi đăng xuất: tắt nhắc học của tài khoản này trên máy.
  Future<void> onSignOut() async {
    _reminderUid = null;
    _syncedUid = null;
    try {
      await _ref.read(reminderServiceProvider).schedule(null);
    } catch (_) {}
  }

  // Khoá cũ (trước khi tách theo user) – chuyển sang user đầu tiên đăng nhập.
  static const _legacyLog = 'study/log';
  static const _legacyGoals = 'study/goals';

  String get _uid => _ref.read(currentUserIdProvider) ?? 'anon';
  String _key(String name) => 'study/$_uid/$name';

  GoalsRepository get _repo => _ref.read(goalsRepositoryProvider);
  Future<SharedPreferences> get _prefs => _ref.read(sharedPreferencesProvider.future);

  /// Ghi tuần tự: các lần ghi liên tiếp (không await) không đè lên nhau.
  Future<void> _queue = Future.value();
  Future<T> _serial<T>(Future<T> Function() job) {
    final result = _queue.then((_) => job());
    _queue = result.then((_) {}, onError: (_) {});
    return result;
  }

  Map<String, DayLog> _decode(String? raw) {
    if (raw == null) return {};
    try {
      return {
        for (final e in (jsonDecode(raw) as Map<String, dynamic>).entries)
          e.key: DayLog.fromJson(e.value as Map<String, dynamic>),
      };
    } catch (_) {
      return {};
    }
  }

  String _encode(Map<String, DayLog> m) {
    final keys = m.keys.toList()..sort();
    final keep = keys.skip((keys.length - _keepDays).clamp(0, keys.length));
    return jsonEncode({for (final k in keep) k: m[k]!.toJson()});
  }

  /// Dữ liệu cũ chưa gắn user → thuộc user hiện tại, và đưa vào hàng đợi gửi lên server.
  Future<void> _adoptLegacy(SharedPreferences prefs) async {
    if (_uid == 'anon') return;
    final oldLog = prefs.getString(_legacyLog);
    if (oldLog != null) {
      final log = _decode(oldLog);
      final pending = _decode(prefs.getString(_key('pending')));
      for (final e in log.entries) {
        pending[e.key] = (pending[e.key] ?? const DayLog()) + e.value;
      }
      await prefs.setString(_key('pending'), _encode(pending));
      await prefs.setString(_key('log'), oldLog);
      await prefs.remove(_legacyLog);
    }
    final oldGoals = prefs.getString(_legacyGoals);
    if (oldGoals != null) {
      await prefs.setString(_key('goals'), oldGoals);
      await prefs.setBool(_key('goals_dirty'), true);
      await prefs.remove(_legacyGoals);
    }
  }

  // ---------- Nhật ký ngày ----------

  Future<void> record(StudyEvent event, [int count = 1]) {
    if (count <= 0) return Future.value();
    final delta = switch (event) {
      StudyEvent.questions => DayLog(questions: count),
      StudyEvent.mistakes => DayLog(mistakes: count),
      StudyEvent.words => DayLog(words: count),
      StudyEvent.dictations => DayLog(dictations: count),
    };
    return _serial(() async {
      final prefs = await _prefs;
      final day = dayKey(DateTime.now());
      for (final name in ['log', 'pending']) {
        final m = _decode(prefs.getString(_key(name)));
        m[day] = (m[day] ?? const DayLog()) + delta;
        await prefs.setString(_key(name), _encode(m));
      }
      _ref.invalidate(studyLogProvider);
      await _flush(prefs);
    }).catchError((_) {});
  }

  /// Gửi phần chưa đồng bộ; ngày nào gửi được thì bỏ khỏi hàng đợi.
  Future<void> _flush(SharedPreferences prefs, {bool force = false}) async {
    final pending = _decode(prefs.getString(_key('pending')));
    if (pending.isEmpty || _uid == 'anon') return;
    final now = DateTime.now();
    if (!force && _lastFlush != null && now.difference(_lastFlush!) < _flushEvery) return;
    _lastFlush = now;
    for (final e in pending.entries.toList()) {
      try {
        await _repo.bump(e.key, e.value);
        pending.remove(e.key);
      } catch (_) {
        break; // mất mạng → thử lại lần sau
      }
    }
    await prefs.setString(_key('pending'), _encode(pending));
  }

  /// Nhật ký đầy đủ = server (mọi máy) + phần máy này chưa gửi. Mất mạng → bản trên máy.
  Future<Map<String, DayLog>> readLog() => _serial(() async {
    final prefs = await _prefs;
    await _adoptLegacy(prefs);
    final now = DateTime.now();
    final fresh =
        _syncedUid == _uid && _lastFetch != null && now.difference(_lastFetch!) < _fetchEvery;
    if (fresh) return _decode(prefs.getString(_key('log')));
    await _flush(prefs, force: true);
    try {
      final server = await _repo.fetchDays(
        DateTime.now().subtract(const Duration(days: _keepDays)),
      );
      final pending = _decode(prefs.getString(_key('pending')));
      final merged = {...server};
      for (final e in pending.entries) {
        merged[e.key] = (merged[e.key] ?? const DayLog()) + e.value;
      }
      await prefs.setString(_key('log'), _encode(merged));
      _lastFetch = now;
      _syncedUid = _uid;
      return merged;
    } catch (_) {
      return _decode(prefs.getString(_key('log')));
    }
  });

  // ---------- Mục tiêu ----------

  GoalSettings? _decodeGoals(String? raw) {
    if (raw == null) return null;
    try {
      return GoalSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<GoalSettings> readGoals() => _serial(() async {
    final prefs = await _prefs;
    await _adoptLegacy(prefs);
    final local = _decodeGoals(prefs.getString(_key('goals')));
    final dirty = prefs.getBool(_key('goals_dirty')) ?? false;
    try {
      if (dirty && local != null) {
        await _repo.saveGoals(local);
        await prefs.setBool(_key('goals_dirty'), false);
        await _applyReminder(local);
        return local;
      }
      final server = await _repo.fetchGoals();
      final goals = server ?? local ?? const GoalSettings();
      if (server != null) await prefs.setString(_key('goals'), jsonEncode(server.toJson()));
      // Mục tiêu có thể đổi từ máy khác / vừa đổi tài khoản → đặt lại giờ nhắc trên máy này
      await _applyReminder(goals);
      return goals;
    } catch (_) {
      final goals = local ?? const GoalSettings();
      await _applyReminder(goals);
      return goals;
    }
  });

  /// Lưu trên máy ngay; gửi server lỗi thì giữ cờ để gửi lại ở lần đọc sau.
  Future<void> saveGoals(GoalSettings goals) async {
    await _serial(() async {
      final prefs = await _prefs;
      await prefs.setString(_key('goals'), jsonEncode(goals.toJson()));
      _reminderUid = _uid;
      _reminderMinutes = goals.reminderMinutes; // goal sheet đã tự đặt lịch
      try {
        await _repo.saveGoals(goals);
        await prefs.setBool(_key('goals_dirty'), false);
      } catch (_) {
        await prefs.setBool(_key('goals_dirty'), true);
      }
    });
    _ref.invalidate(goalSettingsProvider);
  }
}

@riverpod
Future<Map<String, DayLog>> studyLog(Ref ref) {
  ref.watch(currentUserIdProvider); // đổi tài khoản → đọc lại
  return ref.watch(studyStoreProvider).readLog();
}

@riverpod
Future<GoalSettings> goalSettings(Ref ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(studyStoreProvider).readGoals();
}
