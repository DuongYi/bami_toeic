import 'package:bami_toeic/module/test/data/models/test_models.dart';
import 'package:bami_toeic/module/test/data/test_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

TestSummary _t(String source, String title, int count, {int? limit}) => TestSummary(
  id: title,
  title: title,
  source: source,
  questionCount: count,
  timeLimitMinutes: limit,
);

void main() {
  // Đúng các đề đang có trên Supabase (source | title | số câu).
  final tests = [
    _t('Bami TOEIC', 'Sample Full Test 01 (đủ 7 Part)', 24),
    for (final n in [1, 2, 10, 9]) _t('ETS 2026', 'ETS 2026 – Test $n', 200),
    for (final n in [3, 1, 10]) _t('ETS 2024', 'ETS 2024 – Test $n', 200),
    _t('Bami TOEIC - Mini Test 25Q', 'Mini Test 25Q - Đề 02', 25),
    _t('Bami TOEIC Extreme Series', 'ETS Extreme Hard Test 01 (Target 990)', 200),
    _t('Bami TOEIC - Quick 15m', 'Quick Test 15m - Đề 01', 15, limit: 15),
    _t('Bami TOEIC', 'Luyện Part 5 · Band 850+', 30),
    _t('Bami TOEIC', 'Luyện Part 5 · Band 450–600', 30),
    _t('Bami TOEIC', 'Luyện Part 6 · Đề 01', 16),
    _t('Bami TOEIC', 'Luyện Part 7 · Đề 01', 22),
    _t('Bami TOEIC', 'Luyện nghe Part 2–4 · Đề 01', 42),
  ];

  test('gom đề theo bộ, đúng nhóm và thứ tự', () {
    final groups = groupTests(tests);
    expect([for (final g in groups) g.collection.id], [
      'ets-2026', 'ets-2024', 'extreme', // thi thử: năm mới trước
      'quick-15', 'mini', // rút gọn
      'listening', 'part-5', 'part-6', 'part-7', // luyện Part theo thứ tự đề thi
    ]);
    expect(groups.first.collection.shelf, TestShelf.full);
    expect(groups.firstWhere((g) => g.collection.id == 'mini').tests, hasLength(2));
  });

  test('đề trong bộ sắp theo số tự nhiên', () {
    final groups = {for (final g in groupTests(tests)) g.collection.id: g.tests};
    expect([for (final t in groups['ets-2026']!) t.title.split(' ').last], ['1', '2', '9', '10']);
    expect(groups['part-5']!.first.title, contains('450'));
  });

  test('nguồn lạ: đề full vào "Đề thi khác", đề ngắn vào "Đề luyện khác"', () {
    expect(collectionOf(_t('Nguồn X', 'Đề A', 200)).id, 'other-full');
    expect(collectionOf(_t('Nguồn X', 'Đề B', 20)).shelf, TestShelf.short);
    expect(collectionOf(_t('ETS 2025', 'ETS 2025 – Test 1', 200)).id, 'ets-2025');
  });

  test('cột collection gán sẵn được ưu tiên', () {
    TestSummary withCol(String col, {String title = 'Đề X', String source = 'Bami TOEIC'}) =>
        TestSummary(id: col, title: title, source: source, questionCount: 30, collection: col);
    expect(collectionOf(withCol('part-6', title: 'Luyện Part 5 · Đề 09')).id, 'part-6');
    expect(collectionOf(withCol('ets-2025')).title, 'ETS 2025');
    expect(collectionOf(withCol('quick-15')).kind, CollectionKind.quick);
    final custom = collectionOf(withCol('toeic-speaking'));
    expect(custom.id, 'toeic-speaking');
    expect(custom.kind, CollectionKind.other);
  });

  test('tiến độ: đề làm dở được ưu tiên, rồi đề chưa làm đầu tiên', () {
    final set = groupTests(tests).first.tests; // ETS 2026: Test 1, 2, 9, 10
    Attempt done(String id, int l, int r) => Attempt(
      id: 'a$id',
      testId: id,
      mode: 'exam',
      parts: const [1, 2, 3, 4, 5, 6, 7],
      totalQuestions: 200,
      listeningCorrect: l,
      readingCorrect: r,
      startedAt: DateTime(2026),
      finishedAt: DateTime(2026),
    );
    final attempts = [done(set[0].id, 80, 80)];
    var p = CollectionProgress.of(set, attempts, const {});
    expect(p.done, 1);
    expect(p.next, set[1]);
    expect(p.averageScore, isNotNull);
    p = CollectionProgress.of(set, attempts, {set[2].id});
    expect(p.next, set[2]);
    expect(p.inProgress, 1);
  });
}
