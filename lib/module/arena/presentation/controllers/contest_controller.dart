import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../test/data/models/test_models.dart';
import '../../data/arena_repository.dart';
import '../../data/models/arena_models.dart';

part 'contest_controller.freezed.dart';
part 'contest_controller.g.dart';

@riverpod
Future<ContestOverview> contestOverview(Ref ref) =>
    ref.watch(arenaRepositoryProvider).overview();

@riverpod
Future<List<ContestRank>> contestBoard(Ref ref, String contestId) =>
    ref.watch(arenaRepositoryProvider).board(contestId);

@riverpod
Future<ContestReview> contestReview(Ref ref, String contestId) =>
    ref.watch(arenaRepositoryProvider).review(contestId);

/// Lệch giờ máy so với server: giờ server ≈ DateTime.now() + offset.
Duration serverOffset(DateTime serverNow) => serverNow.difference(DateTime.now());

@freezed
abstract class ContestSession with _$ContestSession {
  const ContestSession._();

  const factory ContestSession({
    required String contestId,
    required String title,
    required List<QuestionGroup> groups,

    /// Giờ kết thúc theo đồng hồ máy (đã trừ lệch giờ server).
    required DateTime deadline,
    @Default(<String, String>{}) Map<String, String> answers,
    @Default(<String, Set<String>>{}) Map<String, Set<String>> eliminated,
    @Default(<String>{}) Set<String> flagged,
    @Default(0) int index,
    @Default(false) bool submitting,
    ContestResult? result,
    Object? submitError,
  }) = _ContestSession;

  int get totalQuestions => groups.fold(0, (s, g) => s + g.questions.length);
}

/// Một lượt thi Chủ nhật: đề phát từ server (không đáp án), lưu nháp, tự nộp khi hết giờ.
@riverpod
class ContestTaking extends _$ContestTaking {
  Timer? _deadlineTimer;
  Timer? _saveDebounce;

  static const _saveDelay = Duration(seconds: 3);

  @override
  Future<ContestSession> build(String contestId) async {
    ref.onDispose(() {
      _deadlineTimer?.cancel();
      _saveDebounce?.cancel();
    });
    final paper = await ref.read(arenaRepositoryProvider).join(contestId);
    final deadline = paper.endsAt.subtract(serverOffset(paper.serverNow));
    final remaining = deadline.difference(DateTime.now());
    _deadlineTimer = Timer(remaining.isNegative ? Duration.zero : remaining, submit);
    return ContestSession(
      contestId: contestId,
      title: paper.title,
      groups: paperToGroups(paper.id, paper.groups),
      deadline: deadline,
      answers: {for (final e in paper.answers.entries) paperQuestionId(int.parse(e.key)): e.value},
    );
  }

  void _update(ContestSession Function(ContestSession s) f) {
    final s = state.value;
    if (s == null || s.result != null) return;
    state = AsyncData(f(s));
  }

  Map<String, String> _serverAnswers(ContestSession s) => {
    for (final e in s.answers.entries) e.key.substring(1): e.value,
  };

  void select(Question q, String letter) {
    _update(
      (s) => s.copyWith(
        answers: {...s.answers, q.id: letter},
        eliminated: s.eliminated[q.id]?.contains(letter) ?? false
            ? {...s.eliminated, q.id: {...s.eliminated[q.id]!}..remove(letter)}
            : s.eliminated,
      ),
    );
    _saveDebounce?.cancel();
    _saveDebounce = Timer(_saveDelay, _saveDraft);
  }

  void toggleEliminated(Question q, String letter) => _update((s) {
    final crossed = {...?s.eliminated[q.id]};
    final adding = crossed.add(letter);
    if (!adding) crossed.remove(letter);
    return s.copyWith(
      eliminated: {...s.eliminated, q.id: crossed},
      answers: adding && s.answers[q.id] == letter ? ({...s.answers}..remove(q.id)) : s.answers,
    );
  });

  void toggleFlag(Question q) => _update(
    (s) => s.copyWith(
      flagged: s.flagged.contains(q.id) ? ({...s.flagged}..remove(q.id)) : {...s.flagged, q.id},
    ),
  );

  void setIndex(int i) => _update((s) => s.copyWith(index: i));

  /// Lưu nháp lỗi (mất mạng) thì bỏ qua – lúc nộp vẫn gửi đủ bài.
  Future<void> _saveDraft() async {
    final s = state.value;
    if (s == null || s.result != null || s.submitting) return;
    try {
      await ref.read(arenaRepositoryProvider).saveDraft(s.contestId, _serverAnswers(s));
    } catch (_) {}
  }

  Future<void> submit() async {
    final s = state.value;
    if (s == null || s.submitting || s.result != null) return;
    _saveDebounce?.cancel();
    _update((s) => s.copyWith(submitting: true, submitError: null));
    try {
      final result = await ref.read(arenaRepositoryProvider).submit(s.contestId, _serverAnswers(s));
      _deadlineTimer?.cancel();
      if (!ref.mounted) return;
      state = AsyncData(state.value!.copyWith(submitting: false, result: result));
      ref
        ..invalidate(contestOverviewProvider)
        ..invalidate(contestBoardProvider(s.contestId));
    } catch (e) {
      if (ref.mounted) _update((s) => s.copyWith(submitting: false, submitError: e));
    }
  }
}
