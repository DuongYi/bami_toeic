import 'models/test_models.dart';

/// Nhóm lớn trên màn chủ, theo mục đích luyện.
enum TestShelf {
  full('Thi thử 200 câu', 'Đủ 7 Part, chấm điểm như đề thật'),
  short('Đề rút gọn', 'Khởi động nhanh, ít thời gian'),
  part('Luyện theo Part', 'Tập trung vào từng phần thi');

  const TestShelf(this.title, this.subtitle);

  final String title;
  final String subtitle;
}

/// Loại bộ đề – quyết định icon trên thẻ.
enum CollectionKind {
  ets,
  extreme,
  quick,
  mini,
  listening,
  part5,
  part6,
  part7,
  other,
}

/// Bộ đề: gom các đề cùng nguồn / cùng dạng luyện (ETS 2026, Quick 15 phút, Part 5…).
class TestCollection {
  const TestCollection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.shelf,
    required this.kind,
    required this.order,
  });

  /// Khoá trên URL (`/tests/set/<id>`), chỉ gồm chữ thường, số, gạch ngang.
  final String id;
  final String title;
  final String subtitle;
  final TestShelf shelf;
  final CollectionKind kind;

  /// Thứ tự trong cùng nhóm (nhỏ đứng trước).
  final int order;
}

/// Bộ đề của một đề, suy ra từ `source` + `title` (giữ cố định khi import thêm đề cùng loại).
/// Bộ ETS mới (vd. "ETS 2025") tự thành bộ riêng, năm mới đứng trước.
TestCollection collectionOf(TestSummary t) {
  final source = t.source ?? '';
  final title = t.title;
  final ets = RegExp(r'^ETS (\d{4})$').firstMatch(source);
  if (ets != null) {
    final year = int.parse(ets.group(1)!);
    return TestCollection(
      id: 'ets-$year',
      title: 'ETS $year',
      subtitle: 'Đề thi thật, giải thích từng câu',
      shelf: TestShelf.full,
      kind: CollectionKind.ets,
      order: 10000 - year,
    );
  }
  if (source.contains('Extreme')) {
    return const TestCollection(
      id: 'extreme',
      title: 'Extreme 990',
      subtitle: 'Siêu khó, cho mục tiêu 900+',
      shelf: TestShelf.full,
      kind: CollectionKind.extreme,
      order: 20000,
    );
  }
  if (source.contains('Quick') || t.timeLimitMinutes == 15) {
    return const TestCollection(
      id: 'quick-15',
      title: 'Quick 15 phút',
      subtitle: '15 câu trộn các Part',
      shelf: TestShelf.short,
      kind: CollectionKind.quick,
      order: 1,
    );
  }
  if (source.contains('Mini') || title.startsWith('Sample')) {
    return const TestCollection(
      id: 'mini',
      title: 'Mini Test',
      subtitle: '25 câu đủ 7 Part',
      shelf: TestShelf.short,
      kind: CollectionKind.mini,
      order: 2,
    );
  }
  if (title.startsWith('Luyện nghe')) {
    return const TestCollection(
      id: 'listening',
      title: 'Nghe Part 2–4',
      subtitle: 'Hỏi đáp, hội thoại, bài nói',
      shelf: TestShelf.part,
      kind: CollectionKind.listening,
      order: 1,
    );
  }
  for (final (part, kind, subtitle) in const [
    (5, CollectionKind.part5, 'Ngữ pháp & từ vựng theo band'),
    (6, CollectionKind.part6, 'Điền từ vào đoạn văn'),
    (7, CollectionKind.part7, 'Đọc hiểu đơn & đa đoạn'),
  ]) {
    if (title.startsWith('Luyện Part $part')) {
      return TestCollection(
        id: 'part-$part',
        title: 'Part $part',
        subtitle: subtitle,
        shelf: TestShelf.part,
        kind: kind,
        order: part,
      );
    }
  }
  final full = t.questionCount >= 100;
  return TestCollection(
    id: full ? 'other-full' : 'other',
    title: full ? 'Đề thi khác' : 'Đề luyện khác',
    subtitle: full ? 'Đề đầy đủ từ nguồn khác' : 'Đề ngắn từ nguồn khác',
    shelf: full ? TestShelf.full : TestShelf.short,
    kind: CollectionKind.other,
    order: 30000,
  );
}

/// Một bộ đề kèm danh sách đề đã sắp theo số (Test 1, 2, … 10).
class CollectionEntry {
  const CollectionEntry(this.collection, this.tests);

  final TestCollection collection;
  final List<TestSummary> tests;
}

/// Gom đề theo bộ, sắp theo nhóm → thứ tự bộ → số đề.
List<CollectionEntry> groupTests(List<TestSummary> tests) {
  final byId = <String, (TestCollection, List<TestSummary>)>{};
  for (final t in tests) {
    final c = collectionOf(t);
    (byId[c.id] ??= (c, [])).$2.add(t);
  }
  final entries = [
    for (final (c, list) in byId.values)
      CollectionEntry(c, list..sort(compareTests)),
  ];
  entries.sort(
    (a, b) => a.collection.shelf.index != b.collection.shelf.index
        ? a.collection.shelf.index - b.collection.shelf.index
        : a.collection.order - b.collection.order,
  );
  return entries;
}

/// So sánh tự nhiên theo các số trong tiêu đề: "Test 2" < "Test 10", "Band 450–600" < "Band 850+".
int compareTests(TestSummary a, TestSummary b) {
  List<int> nums(String s) => [
    for (final m in RegExp(r'\d+').allMatches(s)) int.parse(m[0]!),
  ];
  final na = nums(a.title), nb = nums(b.title);
  for (var i = 0; i < na.length && i < nb.length; i++) {
    if (na[i] != nb[i]) return na[i] - nb[i];
  }
  if (na.length != nb.length) return na.length - nb.length;
  return a.title.compareTo(b.title);
}

/// Tiến độ của người học trong một bộ đề.
class CollectionProgress {
  const CollectionProgress({
    required this.total,
    required this.done,
    required this.inProgress,
    this.averageScore,
    this.averageRatio,
    this.next,
  });

  /// Tính từ lịch sử làm bài (mới nhất trước) và các đề đang làm dở.
  factory CollectionProgress.of(
    List<TestSummary> tests,
    List<Attempt> attempts,
    Set<String> inProgressIds,
  ) {
    final latest = <String, Attempt>{};
    for (final a in attempts) {
      if (!a.isMistakeReview) latest.putIfAbsent(a.testId, () => a);
    }
    final done = [for (final t in tests) ?latest[t.id]];
    final full = done.where((a) => a.isFullTest).toList();
    final partial = done
        .where((a) => !a.isFullTest && a.totalQuestions > 0)
        .toList();
    return CollectionProgress(
      total: tests.length,
      done: done.length,
      inProgress: tests.where((t) => inProgressIds.contains(t.id)).length,
      averageScore: full.isEmpty
          ? null
          : (full.fold<int>(0, (s, a) => s + a.totalScore) / full.length)
                .round(),
      averageRatio: partial.isEmpty
          ? null
          : partial.fold<double>(
                  0,
                  (s, a) => s + a.correct / a.totalQuestions,
                ) /
                partial.length,
      // Ưu tiên đề đang làm dở, rồi đến đề chưa làm đầu tiên.
      next:
          tests.where((t) => inProgressIds.contains(t.id)).firstOrNull ??
          tests.where((t) => !latest.containsKey(t.id)).firstOrNull,
    );
  }

  final int total;
  final int done;
  final int inProgress;

  /// Điểm TOEIC trung bình của các đề full đã làm.
  final int? averageScore;

  /// Tỉ lệ đúng trung bình của các đề ngắn đã làm.
  final double? averageRatio;

  /// Đề nên làm tiếp; null khi đã làm hết.
  final TestSummary? next;

  double get ratio => total == 0 ? 0 : done / total;
}
