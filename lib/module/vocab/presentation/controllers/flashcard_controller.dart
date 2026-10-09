import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../helper/srs.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../goals/data/study_store.dart';
import '../../data/models/vocab_models.dart';
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

@riverpod
class FlashcardSession extends _$FlashcardSession {
  @override
  Future<FlashcardState> build(String? topic) async {
    // Lấy dữ liệu mới nhất 1 lần; không watch để phiên học không bị reset giữa chừng.
    final all = await ref.read(vocabRepositoryProvider).fetchAll();
    final items = topic == null ? all : all.where((v) => v.topic == topic).toList();
    return FlashcardState(
      queue: buildSession(items, DateTime.now(), ref.read(sessionRandomProvider)),
    );
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
