import 'package:bami_toeic/module/test/data/models/test_models.dart';
import 'package:bami_toeic/module/vocab/data/models/vocab_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TestSummary đọc questions(count)', () {
    final t = TestSummary.fromJson({
      'id': 't1',
      'title': 'Test 1',
      'questions': [
        {'count': 200},
      ],
    });
    expect(t.questionCount, 200);
  });

  test('Attempt đọc tests(title) và ngày giờ', () {
    final a = Attempt.fromJson({
      'id': 'a1',
      'test_id': 't1',
      'tests': {'title': 'Test 1'},
      'mode': 'exam',
      'parts': [1, 2, 3, 4, 5, 6, 7],
      'started_at': '2026-10-08T01:00:00+00:00',
      'finished_at': '2026-10-08T03:00:00+00:00',
      'total_questions': 200,
      'listening_correct': 80,
      'reading_correct': 70,
    });
    expect(a.testTitle, 'Test 1');
    expect(a.isFullTest, isTrue);
    expect(a.duration, const Duration(hours: 2));
  });

  test('Question: Part 2 mặc định 3 lựa chọn', () {
    final q = Question.fromJson({'id': 'q', 'part': 2, 'number': 7, 'answer': 'C'});
    expect(q.letters, ['A', 'B', 'C']);
  });

  test('VocabItem: chưa có review là từ mới; ease kiểu int vẫn parse được', () {
    final fresh = VocabItem.fromJson({
      'id': 'v1',
      'word': 'invoice',
      'meaning': 'hoá đơn',
      'topic': 'Finance',
      'vocab_reviews': <dynamic>[],
    });
    expect(fresh.isNew, isTrue);

    final reviewed = VocabItem.fromJson({
      'id': 'v2',
      'word': 'budget',
      'meaning': 'ngân sách',
      'topic': 'Finance',
      'vocab_reviews': [
        {'ease': 3, 'interval_days': 6, 'repetitions': 2, 'due_at': '2020-01-01T00:00:00+00:00'},
      ],
    });
    expect(reviewed.isDue(DateTime.now()), isTrue);
    expect(reviewed.srs!.ease, 3.0);
  });

  test('VocabReviewUpsert ghi snake_case', () {
    final json = VocabReviewUpsert(
      userId: 'u',
      vocabId: 'v',
      ease: 2.5,
      intervalDays: 1,
      repetitions: 1,
      dueAt: DateTime.utc(2026),
      lastReviewedAt: DateTime.utc(2026),
    ).toJson();
    expect(json.keys, containsAll(['user_id', 'vocab_id', 'interval_days', 'due_at']));
    expect(json['due_at'], '2026-01-01T00:00:00.000Z');
  });
}
