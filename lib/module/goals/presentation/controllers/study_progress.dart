import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../helper/score.dart';
import '../../../test/data/models/test_models.dart';
import '../../../test/presentation/controllers/test_providers.dart';
import '../../data/study_store.dart';

part 'study_progress.g.dart';

enum MissionKind { questions, words, mistakes, dictations }

class Mission {
  const Mission({
    required this.kind,
    required this.title,
    required this.done,
    required this.target,
  });

  final MissionKind kind;
  final String title;
  final int done;
  final int target;

  bool get isDone => done >= target;
}

enum ChallengeKind { days, questions, words }

/// Thử thách tuần (thứ Hai → Chủ nhật, giờ máy): học đủ ngày, đủ câu, đủ thẻ.
/// Chỉ tiêu = 5 ngày theo mục tiêu mỗi ngày → còn 2 ngày nghỉ mà vẫn hoàn thành.
class WeeklyChallenge {
  const WeeklyChallenge({required this.weekStart, required this.goals, required this.daysLeft});

  /// Thứ Hai đầu tuần (00:00 giờ máy).
  final DateTime weekStart;
  final List<ChallengeGoal> goals;

  /// Số ngày còn lại trong tuần, tính cả hôm nay (1 = Chủ nhật).
  final int daysLeft;

  static const activeDaysTarget = 5;

  int get goalsDone => goals.where((g) => g.isDone).length;
  bool get isCompleted => goals.isNotEmpty && goalsDone == goals.length;
}

class ChallengeGoal {
  const ChallengeGoal({
    required this.kind,
    required this.title,
    required this.done,
    required this.target,
  });

  final ChallengeKind kind;
  final String title;
  final int done;
  final int target;

  bool get isDone => done >= target;
  double get ratio => target == 0 ? 1 : (done / target).clamp(0.0, 1.0);
}

/// [questionsByDay]: số câu theo lịch sử bài làm (bù khi log trên máy thiếu, vd. đổi máy).
WeeklyChallenge computeWeeklyChallenge({
  required Map<String, DayLog> log,
  required Set<String> activeDays,
  required Map<String, int> questionsByDay,
  required GoalSettings goals,
  required DateTime now,
}) {
  final today = DateTime(now.year, now.month, now.day);
  final start = today.subtract(Duration(days: today.weekday - DateTime.monday));
  final days = [
    for (var i = 0; i < 7; i++) dayKey(DateTime(start.year, start.month, start.day + i)),
  ];
  var active = 0, questions = 0, words = 0;
  for (final d in days) {
    if (activeDays.contains(d)) active++;
    final l = log[d] ?? const DayLog();
    final q = questionsByDay[d] ?? 0;
    questions += l.questions > q ? l.questions : q;
    words += l.words;
  }
  const n = WeeklyChallenge.activeDaysTarget;
  return WeeklyChallenge(
    weekStart: start,
    daysLeft: DateTime.sunday - today.weekday + 1,
    goals: [
      ChallengeGoal(kind: ChallengeKind.days, title: 'Học $n/7 ngày', done: active, target: n),
      ChallengeGoal(
        kind: ChallengeKind.questions,
        title: 'Làm ${goals.dailyQuestions * n} câu',
        done: questions,
        target: goals.dailyQuestions * n,
      ),
      ChallengeGoal(
        kind: ChallengeKind.words,
        title: 'Ôn ${goals.dailyWords * n} thẻ từ',
        done: words,
        target: goals.dailyWords * n,
      ),
    ],
  );
}

/// Điểm dự đoán: trung bình ≤ 3 full test gần nhất, hoặc ước tính từ tỉ lệ đúng theo Part.
class ScorePrediction {
  const ScorePrediction({
    required this.total,
    required this.listening,
    required this.reading,
    required this.basis,
  });

  final int total;
  final int listening;
  final int reading;

  /// Mô tả nguồn: "3 full test gần nhất" / "ước tính từ 240 câu"
  final String basis;
}

class StudyProgress {
  const StudyProgress({
    required this.streak,
    required this.activeToday,
    required this.today,
    required this.goals,
    required this.missions,
    required this.prediction,
    required this.weekly,
  });

  final WeeklyChallenge weekly;

  final int streak;
  final bool activeToday;
  final DayLog today;
  final GoalSettings goals;
  final List<Mission> missions;
  final ScorePrediction? prediction;

  int get missionsDone => missions.where((m) => m.isDone).length;

  int? daysToExam(DateTime now) {
    final d = goals.examDate;
    if (d == null) return null;
    final today = DateTime(now.year, now.month, now.day);
    return DateTime(d.year, d.month, d.day).difference(today).inDays;
  }
}

/// Số ngày học liên tiếp tính tới hôm nay (hôm nay chưa học thì tính tới hôm qua).
int computeStreak(Set<String> activeDays, DateTime now) {
  var day = DateTime(now.year, now.month, now.day);
  if (!activeDays.contains(dayKey(day))) day = day.subtract(const Duration(days: 1));
  var n = 0;
  while (activeDays.contains(dayKey(day))) {
    n++;
    day = day.subtract(const Duration(days: 1));
  }
  return n;
}

ScorePrediction? predictScore(List<Attempt> attempts, List<PartStat> stats) {
  final full = attempts.where((a) => a.isFullTest).take(3).toList();
  if (full.isNotEmpty) {
    int avg(int Function(Attempt) f) =>
        (full.map(f).reduce((a, b) => a + b) / full.length / 5).round() * 5;
    final l = avg((a) => a.listeningScore), r = avg((a) => a.readingScore);
    return ScorePrediction(
      total: l + r,
      listening: l,
      reading: r,
      basis: full.length == 1
          ? 'Theo full test gần nhất'
          : 'Trung bình ${full.length} full test gần nhất',
    );
  }
  (int, int) sum(bool listening) => stats
      .where((s) => ToeicScore.isListening(s.part) == listening)
      .fold((0, 0), (acc, s) => (acc.$1 + s.correct, acc.$2 + s.total));
  final (lc, lt) = sum(true);
  final (rc, rt) = sum(false);
  // Cần đủ dữ liệu cả 2 kỹ năng mới dự đoán, tránh con số ảo.
  if (lt < 30 || rt < 30) return null;
  final l = ToeicScore.listening((lc / lt * 100).round());
  final r = ToeicScore.reading((rc / rt * 100).round());
  return ScorePrediction(
    total: l + r,
    listening: l,
    reading: r,
    basis: 'Ước tính từ ${lt + rt} câu đã làm',
  );
}

@riverpod
Future<StudyProgress> studyProgress(Ref ref) async {
  final (log, goals, attempts, stats) = await (
    ref.watch(studyLogProvider.future),
    ref.watch(goalSettingsProvider.future),
    ref.watch(attemptsProvider.future),
    ref.watch(partStatsProvider.future).catchError((_) => const <PartStat>[]),
  ).wait;
  final mistakes = ref.watch(mistakesProvider).value;
  final now = DateTime.now();
  final todayKey = dayKey(now);
  final today = log[todayKey] ?? const DayLog();
  final active = {
    for (final e in log.entries)
      if (e.value.isActive) e.key,
    for (final a in attempts) dayKey(a.finishedAt.toLocal()),
  };
  final questionsByDay = <String, int>{};
  for (final a in attempts) {
    final d = dayKey(a.finishedAt.toLocal());
    questionsByDay[d] = (questionsByDay[d] ?? 0) + a.totalQuestions;
  }
  final attemptsToday = questionsByDay[todayKey] ?? 0;

  return StudyProgress(
    streak: computeStreak(active, now),
    activeToday: active.contains(todayKey),
    today: today,
    goals: goals,
    prediction: predictScore(attempts, stats),
    weekly: computeWeeklyChallenge(
      log: log,
      activeDays: active,
      questionsByDay: questionsByDay,
      goals: goals,
      now: now,
    ),
    missions: [
      Mission(
        kind: MissionKind.questions,
        title: 'Làm ${goals.dailyQuestions} câu hỏi',
        // Log trên máy đếm cả bài chưa nộp xong; lịch sử server bù khi đổi máy.
        done: today.questions > attemptsToday ? today.questions : attemptsToday,
        target: goals.dailyQuestions,
      ),
      Mission(
        kind: MissionKind.words,
        title: 'Ôn ${goals.dailyWords} thẻ từ vựng',
        done: today.words,
        target: goals.dailyWords,
      ),
      if (mistakes == null || mistakes.isNotEmpty || today.mistakes > 0)
        Mission(
          kind: MissionKind.mistakes,
          title: 'Luyện lại 5 câu trong sổ câu sai',
          done: today.mistakes,
          target: 5,
        )
      else
        Mission(
          kind: MissionKind.dictations,
          title: 'Chép chính tả ${goals.dailyDictations} đoạn',
          done: today.dictations,
          target: goals.dailyDictations,
        ),
    ],
  );
}
