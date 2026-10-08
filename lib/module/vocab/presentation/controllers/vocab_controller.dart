import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/vocab_models.dart';
import '../../data/vocab_repository.dart';

part 'vocab_controller.g.dart';

/// Số từ mới tối đa mỗi phiên flashcard.
const newPerSession = 20;

/// Phiên học = các từ đến hạn + tối đa [newPerSession] từ mới, xáo trộn.
List<VocabItem> buildSession(List<VocabItem> items, DateTime now) {
  final due = items.where((v) => v.isDue(now)).toList();
  final fresh = items.where((v) => v.isNew).take(newPerSession).toList();
  return [...due, ...fresh]..shuffle(Random());
}

/// Toàn bộ từ vựng + thao tác thêm/sửa/xoá.
@riverpod
class VocabList extends _$VocabList {
  @override
  Future<List<VocabItem>> build() => ref.watch(vocabRepositoryProvider).fetchAll();

  Future<void> save(VocabInput input, {String? id}) async {
    await ref.read(vocabRepositoryProvider).save(input, id: id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> delete(String id) async {
    await ref.read(vocabRepositoryProvider).delete(id);
    ref.invalidateSelf();
    await future;
  }
}

typedef VocabFilterState = ({String? topic, String query});

@riverpod
class VocabFilter extends _$VocabFilter {
  @override
  VocabFilterState build() => (topic: null, query: '');

  void setTopic(String? topic) => state = (topic: topic, query: state.query);
  void setQuery(String query) => state = (topic: state.topic, query: query.trim());
}

class VocabOverview {
  const VocabOverview({
    required this.total,
    required this.topics,
    required this.shown,
    required this.dueCount,
    required this.newCount,
    required this.sessionSize,
  });

  final int total;
  final List<String> topics;

  /// Đã lọc theo chủ đề + từ khoá
  final List<VocabItem> shown;
  final int dueCount;
  final int newCount;
  final int sessionSize;
}

/// Dữ liệu dẫn xuất cho màn danh sách; tự tính lại khi list hoặc bộ lọc đổi.
@riverpod
AsyncValue<VocabOverview> vocabOverview(Ref ref) {
  final filter = ref.watch(vocabFilterProvider);
  return ref.watch(vocabListProvider).whenData((all) {
    final now = DateTime.now();
    final inTopic = filter.topic == null ? all : all.where((v) => v.topic == filter.topic).toList();
    final q = filter.query.toLowerCase();
    return VocabOverview(
      total: all.length,
      topics: all.map((v) => v.topic).toSet().toList()..sort(),
      shown: q.isEmpty
          ? inTopic
          : inTopic
                .where(
                  (v) => v.word.toLowerCase().contains(q) || v.meaning.toLowerCase().contains(q),
                )
                .toList(),
      dueCount: inTopic.where((v) => v.isDue(now)).length,
      newCount: inTopic.where((v) => v.isNew).length,
      sessionSize: buildSession(inTopic, now).length,
    );
  });
}
