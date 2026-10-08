import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/test_models.dart';
import '../../data/test_repository.dart';
import 'test_providers.dart';

part 'test_taking_controller.freezed.dart';
part 'test_taking_controller.g.dart';

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
    @Default(0) int index,
    @Default(false) bool submitting,
    Attempt? submitted,
    Object? submitError,
  }) = _TakingState;

  bool get isExam => mode == 'exam';
  List<Question> get questions => [for (final g in groups) ...g.questions];
  int get totalQuestions => groups.fold(0, (s, g) => s + g.questions.length);
}

/// Trạng thái một lượt làm bài. [parts] dạng "1,2,5" để làm khoá family ổn định.
@riverpod
class TestTaking extends _$TestTaking {
  Timer? _timer;

  @override
  Future<TakingState> build(String testId, String mode, String parts) async {
    ref.onDispose(() => _timer?.cancel());

    final partList = parts.split(',').map(int.parse).toList();
    // Không watch testDetailProvider: làm mới danh sách đề không được reset bài đang làm.
    final detail = await ref.read(testRepositoryProvider).fetchTest(testId);
    final groups = detail.groups.where((g) => partList.contains(g.part)).toList();
    final count = groups.fold(0, (s, g) => s + g.questions.length);
    final isExam = mode == 'exam';

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    return TakingState(
      mode: mode,
      parts: partList,
      groups: groups,
      startedAt: DateTime.now(),
      // 120 phút / 200 câu, chia theo số câu đã chọn.
      clock: isExam
          ? Duration(seconds: (7200 * count / 200).round().clamp(300, 7200))
          : Duration.zero,
    );
  }

  void _update(TakingState Function(TakingState s) f) {
    final s = state.value;
    if (s != null) state = AsyncData(f(s));
  }

  void _tick() {
    final s = state.value;
    if (s == null || s.submitting || s.submitted != null) return;
    final clock = s.clock + Duration(seconds: s.isExam ? -1 : 1);
    _update((s) => s.copyWith(clock: clock));
    if (s.isExam && clock <= Duration.zero) {
      _timer?.cancel();
      submit();
    }
  }

  void select(Question q, String letter) {
    _update((s) {
      if (s.revealed.contains(q.id)) return s;
      return s.copyWith(
        answers: {...s.answers, q.id: letter},
        revealed: s.isExam ? s.revealed : {...s.revealed, q.id},
      );
    });
  }

  void setIndex(int index) => _update((s) => s.copyWith(index: index));

  Future<void> submit() async {
    final s = state.value;
    if (s == null || s.submitting || s.submitted != null) return;
    _update((s) => s.copyWith(submitting: true, submitError: null));
    try {
      final attempt = await ref
          .read(testRepositoryProvider)
          .submitAttempt(
            testId: testId,
            mode: s.mode,
            parts: s.parts,
            startedAt: s.startedAt,
            questions: s.questions,
            answers: s.answers,
          );
      _timer?.cancel();
      ref
        ..invalidate(attemptsProvider)
        ..invalidate(partStatsProvider);
      if (ref.mounted) _update((s) => s.copyWith(submitting: false, submitted: attempt));
    } catch (e) {
      if (ref.mounted) _update((s) => s.copyWith(submitting: false, submitError: e));
    }
  }
}
