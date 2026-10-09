import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../helper/srs.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../goals/data/study_store.dart';
import '../../data/practice.dart';
import '../../data/vocab_repository.dart';
import 'vocab_controller.dart';

part 'practice_controller.freezed.dart';
part 'practice_controller.g.dart';

@freezed
abstract class PracticeState with _$PracticeState {
  const PracticeState._();

  const factory PracticeState({
    required List<PracticeQuestion> questions,
    @Default(0) int index,

    /// Đáp án đã chọn của câu hiện tại (null = chưa trả lời). Dạng gõ từ: 0 đúng / -1 sai.
    int? picked,

    /// Chữ đã gõ (dạng gõ từ).
    String? typed,
    @Default(0) int correct,
    @Default(<PracticeQuestion>[]) List<PracticeQuestion> wrong,
  }) = _PracticeState;

  PracticeQuestion? get current => index < questions.length ? questions[index] : null;
  bool get answered => picked != null;
  bool get finished => current == null;

  bool get lastCorrect => switch (current) {
    final q? when q.mode.hasOptions => picked == q.answerIndex,
    _ => picked == 0,
  };
}

/// 1 lượt luyện [mode]. [retryIds]: luyện lại đúng các từ đã sai ở lượt trước.
@riverpod
class PracticeSession extends _$PracticeSession {
  @override
  Future<PracticeState> build(PracticeMode mode, String retryIds) async {
    final items = await ref.read(vocabListProvider.future);
    final deck = await ref.read(currentDeckProvider.future);
    final random = ref.read(sessionRandomProvider);
    final ids = retryIds.isEmpty ? null : retryIds.split(',').toSet();
    final pool = ids != null
        ? items.where((v) => ids.contains(v.id)).toList()
        : practicePool(
            items,
            filterWords(items, deck: deck),
            mode,
            DateTime.now(),
            random,
          );
    return PracticeState(
      questions: buildPractice(pool: pool, bank: items, mode: mode, random: random),
    );
  }

  void choose(int option) {
    final s = state.value;
    if (s == null || s.answered || s.finished) return;
    _settle(s.copyWith(picked: option));
  }

  void submitSpelling(String text) {
    final s = state.value;
    final q = s?.current;
    if (s == null || q == null || s.answered || text.trim().isEmpty) return;
    _settle(s.copyWith(picked: q.checkSpelling(text) ? 0 : -1, typed: text.trim()));
  }

  void next() {
    final s = state.value;
    if (s == null || !s.answered) return;
    state = AsyncData(s.copyWith(index: s.index + 1, picked: null, typed: null));
  }

  void _settle(PracticeState s) {
    final q = s.current!;
    final ok = s.lastCorrect;
    state = AsyncData(
      s.copyWith(correct: s.correct + (ok ? 1 : 0), wrong: ok ? s.wrong : [...s.wrong, q]),
    );
    ref.read(studyStoreProvider).record(StudyEvent.words);
    // Trả lời sai từ đã học → đưa về ôn sớm (như bấm "Quên" ở flashcard).
    if (!ok && !q.item.isNew && !q.item.isKnown) _scheduleAgain(q);
  }

  Future<void> _scheduleAgain(PracticeQuestion q) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    try {
      await ref
          .read(vocabRepositoryProvider)
          .saveReview(
            userId: userId,
            vocabId: q.item.id,
            state: (q.item.srs ?? const SrsState()).review(ReviewGrade.again),
          );
    } catch (_) {
      // Lưu lịch ôn là phụ; lượt luyện vẫn tiếp tục.
    }
  }
}
