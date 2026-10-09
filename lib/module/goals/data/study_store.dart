import 'dart:convert';

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test/data/in_progress_store.dart';

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

/// Nhật ký học theo ngày + mục tiêu, lưu trong SharedPreferences.
class StudyStore {
  StudyStore(this._ref);

  final Ref _ref;
  static const _logKey = 'study/log';
  static const _goalKey = 'study/goals';

  /// Giữ tối đa ~1 năm để chuỗi ngày dài vẫn đếm đúng.
  static const _keepDays = 400;

  Future<Map<String, DayLog>> readLog() async {
    final raw = (await _ref.read(sharedPreferencesProvider.future)).getString(_logKey);
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

  /// Ghi tuần tự: các lần ghi liên tiếp (không await) không đè lên nhau.
  Future<void> _queue = Future.value();

  Future<void> record(StudyEvent event, [int count = 1]) {
    if (count <= 0) return Future.value();
    return _queue = _queue.then((_) => _record(event, count)).catchError((_) {});
  }

  Future<void> _record(StudyEvent event, int count) async {
    final prefs = await _ref.read(sharedPreferencesProvider.future);
    final log = await readLog();
    final key = dayKey(DateTime.now());
    final d = log[key] ?? const DayLog();
    log[key] = switch (event) {
      StudyEvent.questions => d.copyWith(questions: d.questions + count),
      StudyEvent.mistakes => d.copyWith(mistakes: d.mistakes + count),
      StudyEvent.words => d.copyWith(words: d.words + count),
      StudyEvent.dictations => d.copyWith(dictations: d.dictations + count),
    };
    final keys = log.keys.toList()..sort();
    for (final old in keys.take((keys.length - _keepDays).clamp(0, keys.length))) {
      log.remove(old);
    }
    await prefs.setString(
      _logKey,
      jsonEncode({for (final e in log.entries) e.key: e.value.toJson()}),
    );
    _ref.invalidate(studyLogProvider);
  }

  Future<GoalSettings> readGoals() async {
    final raw = (await _ref.read(sharedPreferencesProvider.future)).getString(_goalKey);
    if (raw == null) return const GoalSettings();
    try {
      return GoalSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const GoalSettings();
    }
  }

  Future<void> saveGoals(GoalSettings goals) async {
    await (await _ref.read(sharedPreferencesProvider.future))
        .setString(_goalKey, jsonEncode(goals.toJson()));
    _ref.invalidate(goalSettingsProvider);
  }
}

@riverpod
Future<Map<String, DayLog>> studyLog(Ref ref) => ref.watch(studyStoreProvider).readLog();

@riverpod
Future<GoalSettings> goalSettings(Ref ref) => ref.watch(studyStoreProvider).readGoals();
