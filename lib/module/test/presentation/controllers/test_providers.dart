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
