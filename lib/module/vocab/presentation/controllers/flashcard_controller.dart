import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../helper/srs.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../goals/data/study_store.dart';
import '../../data/models/vocab_models.dart';
import '../../data/vocab_decks.dart';
import '../../data/vocab_repository.dart';
import 'vocab_controller.dart';

part 'flashcard_controller.freezed.dart';
part 'flashcard_controller.g.dart';

@freezed
abstract class FlashcardState with _$FlashcardState {
  const FlashcardState._();

  const factory FlashcardState({
    required List<VocabItem> queue,
    @Default(0) int done,
    @Default(false) bool flipped,

    /// Lỗi lưu tiến độ gần nhất (để UI báo snackbar)
    Object? saveError,
  }) = _FlashcardState;

  VocabItem? get current => queue.firstOrNull;
  int get total => done + queue.length;
}

/// Phiên flashcard. [deckKey]: bộ lấy từ mới (null = bộ đang học);
/// [extraNew] > 0: "Học thêm" đúng chừng ấy từ mới, bỏ qua chỉ tiêu ngày.
@riverpod
class FlashcardSession extends _$FlashcardSession {
  @override
  Future<FlashcardState> build(String? deckKey, int extraNew) async {
    // Đọc 1 lần, không watch: phiên học không bị dựng lại giữa chừng khi lưu tiến độ.
    final items = await ref.read(vocabListProvider.future);
    final deck = deckKey == null
        ? await ref.read(currentDeckProvider.future)
        : VocabDeck.parse(deckKey);
    final now = DateTime.now();
    // watch (không read): goalSettings là autoDispose – read `.future` thì provider bị huỷ
    // ngay và future không bao giờ xong. Màn Từ vựng thường đã tải sẵn nên không tốn thêm.
    final dailyNew = (await ref.watch(goalSettingsProvider.future)).dailyWords;
    final newLimit = extraNew > 0 ? extraNew : newQuotaLeft(items, now, dailyNew);
    final queue = buildSession(
      items,
      now,
      deck: deck,
      newLimit: newLimit,
      random: ref.read(sessionRandomProvider),
    );
    // Học thêm: chỉ từ mới, không lặp lại phần ôn đã làm.
    return FlashcardState(queue: extraNew > 0 ? queue.where((v) => v.isNew).toList() : queue);
  }

  void flip() {
    final s = state.value;
    if (s != null) state = AsyncData(s.copyWith(flipped: !s.flipped));
  }

  Future<void> grade(ReviewGrade grade) async {
    final s = state.value;
    final card = s?.current;
    if (s == null || card == null) return;

    final next = (card.srs ?? const SrsState()).review(grade);
    final rest = s.queue.sublist(1);
    state = AsyncData(
      s.copyWith(
        // Quên → học lại cuối phiên
        queue: grade == ReviewGrade.again ? [...rest, card] : rest,
        done: grade == ReviewGrade.again ? s.done : s.done + 1,
        flipped: false,
        saveError: null,
      ),
    );

    ref.read(studyStoreProvider).record(StudyEvent.words);
    try {
      final userId = ref.read(currentUserIdProvider);
      if (userId == null) return;
      await ref
          .read(vocabRepositoryProvider)
          .saveReview(userId: userId, vocabId: card.id, state: next);
    } catch (e) {
      final cur = state.value;
      if (ref.mounted && cur != null) state = AsyncData(cur.copyWith(saveError: e));
    }
  }
}
