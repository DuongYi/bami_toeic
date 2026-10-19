import 'package:bami_toeic/module/goals/data/study_store.dart';
import 'package:bami_toeic/module/goals/presentation/controllers/study_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Thứ Tư 21/10/2026 → tuần bắt đầu thứ Hai 19/10.
  final now = DateTime(2026, 10, 21, 9);
  const goals = GoalSettings(dailyQuestions: 20, dailyWords: 10);

  test('chỉ tính các ngày trong tuần hiện tại, lấy số câu lớn hơn giữa log và lịch sử', () {
    final w = computeWeeklyChallenge(
      log: {
        '2026-10-18': const DayLog(questions: 500, words: 500), // Chủ nhật tuần trước
        '2026-10-19': const DayLog(questions: 30, words: 12),
        '2026-10-20': const DayLog(questions: 5, words: 8),
      },
      activeDays: {'2026-10-18', '2026-10-19', '2026-10-20'},
      questionsByDay: {'2026-10-20': 40},
      goals: goals,
      now: now,
    );
    expect(w.weekStart, DateTime(2026, 10, 19));
    expect(w.daysLeft, 5);
    final byKind = {for (final g in w.goals) g.kind: g};
    expect(byKind[ChallengeKind.days]!.done, 2);
    expect(byKind[ChallengeKind.questions]!.done, 70);
    expect(byKind[ChallengeKind.questions]!.target, 100);
    expect(byKind[ChallengeKind.words]!.done, 20);
    expect(byKind[ChallengeKind.words]!.target, 50);
    expect(w.isCompleted, isFalse);
  });

  test('Chủ nhật là ngày cuối, đủ chỉ tiêu thì hoàn thành', () {
    final sunday = DateTime(2026, 10, 25, 20);
    final days = [for (var d = 19; d <= 23; d++) '2026-10-$d'];
    final w = computeWeeklyChallenge(
      log: {for (final d in days) d: const DayLog(questions: 20, words: 10)},
      activeDays: days.toSet(),
      questionsByDay: const {},
      goals: goals,
      now: sunday,
    );
    expect(w.daysLeft, 1);
    expect(w.isCompleted, isTrue);
  });
}
