import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/test_models.dart';
import '../../data/test_repository.dart';

part 'test_providers.g.dart';

@riverpod
Future<List<TestSummary>> testList(Ref ref) => ref.watch(testRepositoryProvider).fetchTests();

@riverpod
Future<TestDetail> testDetail(Ref ref, String testId) =>
    ref.watch(testRepositoryProvider).fetchTest(testId);

@riverpod
Future<AttemptResult> attemptResult(Ref ref, String attemptId) =>
    ref.watch(testRepositoryProvider).fetchResult(attemptId);

@riverpod
Future<List<PartStat>> partStats(Ref ref) => ref.watch(testRepositoryProvider).fetchPartStats();

/// Lịch sử làm bài.
@riverpod
class Attempts extends _$Attempts {
  @override
  Future<List<Attempt>> build() => ref.watch(testRepositoryProvider).fetchAttempts();

  /// Xoá lạc quan: bỏ khỏi danh sách ngay, khôi phục nếu API lỗi.
  Future<void> delete(String id) async {
    final previous = state.value ?? const <Attempt>[];
    state = AsyncData([
      for (final a in previous)
        if (a.id != id) a,
    ]);
    try {
      await ref.read(testRepositoryProvider).deleteAttempt(id);
      ref.invalidate(partStatsProvider);
    } catch (_) {
      if (ref.mounted) state = AsyncData(previous);
      rethrow;
    }
  }
}

/// Sổ câu sai: câu từng sai, chưa thuộc, kèm hạn ôn (sớm nhất trước).
@riverpod
Future<List<QuestionReview>> mistakes(Ref ref) =>
    ref.watch(testRepositoryProvider).fetchMistakes();

/// Câu hỏi đã lưu. Lưu / bỏ lưu cập nhật ngay, lỗi mạng thì hoàn tác.
@riverpod
class SavedQuestions extends _$SavedQuestions {
  @override
  Future<List<SavedQuestion>> build() => ref.watch(testRepositoryProvider).fetchSaved();

  bool isSaved(String questionId) =>
      state.value?.any((s) => s.questionId == questionId) ?? false;

  /// [question] cần để hiện ngay trong danh sách trước khi tải lại từ server.
  Future<void> toggle(Question question, {required String groupId, String? testId}) async {
    final previous = state.value ?? const <SavedQuestion>[];
    final repo = ref.read(testRepositoryProvider);
    final saved = previous.any((s) => s.questionId == question.id);
    state = AsyncData(
      saved
          ? [
              for (final s in previous)
                if (s.questionId != question.id) s,
            ]
          : [
              SavedQuestion(
                questionId: question.id,
                groupId: groupId,
                testId: testId ?? '',
                part: question.part,
                number: question.number,
                tags: question.tags,
                createdAt: DateTime.now(),
              ),
              ...previous,
            ],
    );
    try {
      saved ? await repo.unsaveQuestion(question.id) : await repo.saveQuestion(question.id);
    } catch (_) {
      if (ref.mounted) state = AsyncData(previous);
      rethrow;
    }
  }
}

/// Bài luyện hằng ngày: câu sai đến hạn ôn + câu mới thuộc dạng yếu nhất.
class DailyPracticePlan {
  const DailyPracticePlan({required this.due, required this.weakTags});

  final List<QuestionReview> due;
  final List<String> weakTags;

  /// Số câu tối đa mỗi bài và số câu ôn tối đa trong đó (còn lại là câu mới).
  static const size = 15;
  static const maxReviews = 10;

  int get reviewCount => due.length.clamp(0, maxReviews);
  bool get isEmpty => due.isEmpty && weakTags.isEmpty;
}

/// Dạng câu yếu nhất (đủ [minTotal] câu để đáng tin), tỉ lệ đúng thấp nhất trước.
List<String> pickWeakTags(List<TagStat> stats, {int minTotal = 5, int count = 2}) {
  final eligible = stats.where((s) => s.total >= minTotal && s.accuracy < 0.85).toList()
    ..sort((a, b) {
      final byAcc = a.accuracy.compareTo(b.accuracy);
      return byAcc != 0 ? byAcc : b.total.compareTo(a.total);
    });
  return [for (final s in eligible.take(count)) s.tag];
}

@riverpod
Future<DailyPracticePlan> dailyPractice(Ref ref) async {
  final (reviews, stats) = await (
    ref.watch(mistakesProvider.future),
    ref.watch(tagStatsProvider.future).catchError((_) => const <TagStat>[]),
  ).wait;
  final now = DateTime.now();
  return DailyPracticePlan(
    due: [
      for (final r in reviews)
        if (r.isDue(now)) r,
    ],
    weakTags: pickWeakTags(stats),
  );
}

@riverpod
Future<List<TagStat>> tagStats(Ref ref) => ref.watch(testRepositoryProvider).fetchTagStats();
