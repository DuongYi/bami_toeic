import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../goals/data/study_store.dart';
import '../../../leaderboard/presentation/controllers/leaderboard_controller.dart';
import '../../data/in_progress_store.dart';
import '../../data/models/test_models.dart';
import '../../data/test_repository.dart';
import 'test_providers.dart';

part 'test_taking_controller.freezed.dart';
part 'test_taking_controller.g.dart';

/// testId đặc biệt cho phiên luyện lại; `parts` khi đó là bộ lọc:
/// "all" (cả sổ câu sai) | "due" (câu đến hạn ôn) | "part:5" | "tag:word-form"
/// | "saved" (câu đã lưu) | "daily" (bài luyện hằng ngày: câu đến hạn + câu mới dạng yếu).
const kMistakesSession = 'mistakes';

@freezed
abstract class TakingState with _$TakingState {
  const TakingState._();

  const factory TakingState({
    required String mode,
    required List<int> parts,
    required List<QuestionGroup> groups,
    required DateTime startedAt,

    /// Thi thử: thời gian còn lại. Luyện tập: thời gian đã làm.
    required Duration clock,
    @Default(<String, String>{}) Map<String, String> answers,

    /// Câu đã hiện đáp án (chế độ luyện tập)
    @Default(<String>{}) Set<String> revealed,

    /// Câu đánh dấu để xem lại trước khi nộp
    @Default(<String>{}) Set<String> flagged,

    /// Thời gian làm từng câu (ms): tính từ lúc vào nhóm câu / lần chọn trước tới lúc chọn.
    @Default(<String, int>{}) Map<String, int> timeSpentMs,
    @Default(0) int index,
    @Default(false) bool submitting,
    @Default(false) bool isMistakeSession,

    /// Khôi phục từ bài làm dở
    @Default(false) bool resumed,
    Attempt? submitted,

    /// Kết quả phiên sổ câu sai: (đúng, tổng)
    (int, int)? mistakeResult,
    Object? submitError,
  }) = _TakingState;

  bool get isExam => mode == 'exam';
  List<Question> get questions => [for (final g in groups) ...g.questions];
  int get totalQuestions => groups.fold(0, (s, g) => s + g.questions.length);
  bool get isDone => submitted != null || mistakeResult != null;
}

/// Trạng thái một lượt làm bài. [parts] dạng "1,2,5" (hoặc bộ lọc sổ câu sai) để làm khoá family ổn định.
/// Thời gian chế độ thi cho [count] câu đã chọn. Đề có [limitMinutes] riêng (vd. Quick Test 15 phút)
/// thì chia theo tỉ lệ số câu của cả đề ([testTotal]); không có thì 120 phút / 200 câu.
Duration examDuration(int count, {int? limitMinutes, int testTotal = 0}) {
  if (limitMinutes != null && testTotal > 0) {
    final limit = limitMinutes * 60;
    return Duration(seconds: (limit * count / testTotal).round().clamp(60, limit));
  }
  return Duration(seconds: (7200 * count / 200).round().clamp(300, 7200));
}

@riverpod
class TestTaking extends _$TestTaking {
  Timer? _timer;
  Timer? _saveDebounce;
  int _ticksSinceSave = 0;
  static const _saveDelay = Duration(
    milliseconds: 800,
  ); // ds-ignore: debounce lưu bài, không phải animation

  bool get _isMistakes => testId == kMistakesSession;

  @override
  Future<TakingState> build(String testId, String mode, String parts) async {
    ref.onDispose(() {
      _timer?.cancel();
      _saveDebounce?.cancel();
    });
    final repo = ref.read(testRepositoryProvider);
    final isExam = mode == 'exam';

    final List<QuestionGroup> groups;
    final List<int> partList;
    int? limitMinutes;
    var testTotal = 0;
    if (_isMistakes) {
      groups = await repo.fetchGroupsFor(await _reviewRefs(repo, parts));
      partList = ({for (final g in groups) g.part}.toList()..sort());
    } else {
      partList = parts.split(',').map(int.parse).toList();
      // Không watch testDetailProvider: làm mới danh sách đề không được reset bài đang làm.
      final detail = await repo.fetchTest(testId);
      groups = detail.groups.where((g) => partList.contains(g.part)).toList();
      limitMinutes = detail.summary.timeLimitMinutes;
      testTotal = detail.groups.fold(0, (s, g) => s + g.questions.length);
    }
    final count = groups.fold(0, (s, g) => s + g.questions.length);

    var initial = TakingState(
      mode: mode,
      parts: partList,
      groups: groups,
      startedAt: DateTime.now(),
      isMistakeSession: _isMistakes,
      clock: isExam
          ? examDuration(count, limitMinutes: limitMinutes, testTotal: testTotal)
          : Duration.zero,
    );

    // Khôi phục bài làm dở cùng chế độ + cùng Part
    if (!_isMistakes) {
      final snap = await ref.read(inProgressStoreProvider).read(testId);
      if (snap != null && snap.mode == mode && snap.partsKey == parts) {
        final ids = {for (final g in groups) ...g.questions.map((q) => q.id)};
        initial = initial.copyWith(
          startedAt: snap.startedAt,
          clock: Duration(seconds: snap.clockSeconds),
          index: snap.index.clamp(0, groups.isEmpty ? 0 : groups.length - 1),
          answers: {
            for (final e in snap.answers.entries)
              if (ids.contains(e.key)) e.key: e.value,
          },
          revealed: snap.revealed.where(ids.contains).toSet(),
          flagged: snap.flagged.where(ids.contains).toSet(),
          resumed: true,
        );
      }
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    _mark = DateTime.now();
    return initial;
  }

  /// Các câu của phiên luyện lại theo bộ lọc (xem [kMistakesSession]).
  Future<List<QuestionRef>> _reviewRefs(TestRepository repo, String filter) async {
    QuestionRef ref0(String id, String groupId, int part, int number) =>
        (questionId: id, groupId: groupId, part: part, number: number);
    if (filter == 'saved') {
      return [
        for (final s in await repo.fetchSaved()) ref0(s.questionId, s.groupId, s.part, s.number),
      ];
    }
    if (filter == 'daily') {
      final plan = await ref.read(dailyPracticeProvider.future);
      final reviews = plan.due.take(DailyPracticePlan.maxReviews).toList();
      final fresh = await repo.fetchNewQuestions(
        plan.weakTags,
        limit: DailyPracticePlan.size - reviews.length,
      );
      return [
        for (final r in reviews) ref0(r.questionId, r.groupId, r.part, r.number),
        for (final q in fresh) ref0(q.id, q.groupId, q.part, q.number),
      ];
    }
    final now = DateTime.now();
    final all = await repo.fetchMistakes();
    return [
      for (final m in all)
        if (switch (filter.split(':')) {
          ['part', final p] => m.part == int.parse(p),
          ['tag', final t] => m.tags.contains(t),
          ['due'] => m.isDue(now),
          _ => true,
        })
          ref0(m.questionId, m.groupId, m.part, m.number),
    ];
  }

  /// Mốc bắt đầu tính giờ cho câu tiếp theo (vào nhóm câu mới / vừa chọn đáp án).
  DateTime _mark = DateTime.now();

  /// Bỏ qua khoảng quá dài (để máy đó, ra ngoài) để không làm lệch báo cáo nhịp làm bài.
  static const _maxSpent = Duration(minutes: 10);

  void _update(TakingState Function(TakingState s) f, {bool persist = false}) {
    final s = state.value;
    if (s == null) return;
    state = AsyncData(f(s));
    if (persist) _scheduleSave();
  }

  void _tick() {
    final s = state.value;
    if (s == null || s.submitting || s.isDone) return;
    final clock = s.clock + Duration(seconds: s.isExam ? -1 : 1);
    _update((s) => s.copyWith(clock: clock));
    if (++_ticksSinceSave >= 10) _scheduleSave();
    if (s.isExam && clock <= Duration.zero) {
      _timer?.cancel();
      submit();
    }
  }

  // ---------- lưu bài làm dở ----------

  void _scheduleSave() {
    if (_isMistakes) return;
    _saveDebounce?.cancel();
    _saveDebounce = Timer(_saveDelay, saveProgress);
  }

  /// Ghi ảnh chụp hiện tại (gọi cả khi rời màn hình).
  /// [force]: đồng bộ lên server ngay (thoát màn / app xuống nền).
  Future<void> saveProgress({bool force = false}) async {
    final s = state.value;
    if (_isMistakes || s == null || s.isDone) return;
    _ticksSinceSave = 0;
    if (s.answers.isEmpty && s.flagged.isEmpty) return; // chưa làm gì thì không lưu
    await ref
        .read(inProgressStoreProvider)
        .save(
          TakingSnapshot(
            testId: testId,
            mode: s.mode,
            parts: s.parts,
            startedAt: s.startedAt,
            clockSeconds: s.clock.inSeconds,
            index: s.index,
            answers: s.answers,
            revealed: s.revealed.toList(),
            flagged: s.flagged.toList(),
            totalQuestions: s.totalQuestions,
            savedAt: DateTime.now().toUtc(),
          ),
          force: force,
        );
    if (ref.mounted) {
      ref
        ..invalidate(inProgressProvider(testId))
        ..invalidate(inProgressAllProvider);
    }
  }

  // ---------- thao tác ----------

  void select(Question q, String letter) {
    final before = state.value;
    if (before != null && !before.answers.containsKey(q.id) && !before.revealed.contains(q.id)) {
      final store = ref.read(studyStoreProvider)..record(StudyEvent.questions);
      if (_isMistakes) store.record(StudyEvent.mistakes);
    }
    final now = DateTime.now();
    final spent = now.difference(_mark);
    _mark = now;
    _update((s) {
      if (s.revealed.contains(q.id)) return s;
      final ms = spent > _maxSpent ? 0 : spent.inMilliseconds;
      return s.copyWith(
        answers: {...s.answers, q.id: letter},
        revealed: s.isExam ? s.revealed : {...s.revealed, q.id},
        timeSpentMs: {...s.timeSpentMs, q.id: (s.timeSpentMs[q.id] ?? 0) + ms},
      );
    }, persist: true);
  }

  void toggleFlag(Question q) => _update(
    (s) => s.copyWith(
      flagged: s.flagged.contains(q.id) ? ({...s.flagged}..remove(q.id)) : {...s.flagged, q.id},
    ),
    persist: true,
  );

  void setIndex(int index) {
    _mark = DateTime.now();
    _update((s) => s.copyWith(index: index), persist: true);
  }

  Future<void> submit() async {
    final s = state.value;
    if (s == null || s.submitting || s.isDone) return;
    _update((s) => s.copyWith(submitting: true, submitError: null));
    final repo = ref.read(testRepositoryProvider);
    try {
      if (_isMistakes) {
        final result = await repo.submitMistakePractice(
          mode: s.mode,
          startedAt: s.startedAt,
          groups: s.groups,
          answers: s.answers,
          timeSpentMs: s.timeSpentMs,
        );
        _afterSubmit();
        if (ref.mounted) _update((s) => s.copyWith(submitting: false, mistakeResult: result));
      } else {
        final attempt = await repo.submitAttempt(
          testId: testId,
          mode: s.mode,
          parts: s.parts,
          startedAt: s.startedAt,
          questions: s.questions,
          answers: s.answers,
          timeSpentMs: s.timeSpentMs,
        );
        await ref.read(inProgressStoreProvider).clear(testId);
        _afterSubmit();
        if (ref.mounted) _update((s) => s.copyWith(submitting: false, submitted: attempt));
      }
    } catch (e) {
      if (ref.mounted) _update((s) => s.copyWith(submitting: false, submitError: e));
    }
  }

  void _afterSubmit() {
    _timer?.cancel();
    _saveDebounce?.cancel();
    ref
      ..invalidate(attemptsProvider)
      ..invalidate(leaderboardProvider)
      ..invalidate(partStatsProvider)
      ..invalidate(tagStatsProvider)
      ..invalidate(mistakesProvider)
      ..invalidate(dailyPracticeProvider)
      ..invalidate(inProgressProvider(testId))
      ..invalidate(inProgressAllProvider);
  }
}
