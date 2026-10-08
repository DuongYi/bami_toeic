import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/supabase.dart';
import '../../helper/score.dart';
import 'models.dart';

final testRepositoryProvider = Provider<TestRepository>(
  (ref) => TestRepository(ref.watch(supabaseProvider)),
);

final testListProvider = FutureProvider.autoDispose<List<TestSummary>>(
  (ref) => ref.watch(testRepositoryProvider).fetchTests(),
);

final testDetailProvider = FutureProvider.autoDispose.family<TestDetail, String>(
  (ref, id) => ref.watch(testRepositoryProvider).fetchTest(id),
);

final attemptsProvider = FutureProvider.autoDispose<List<Attempt>>(
  (ref) => ref.watch(testRepositoryProvider).fetchAttempts(),
);

final partStatsProvider = FutureProvider.autoDispose<List<PartStat>>(
  (ref) => ref.watch(testRepositoryProvider).fetchPartStats(),
);

class TestRepository {
  TestRepository(this._db);

  final SupabaseClient _db;

  Future<List<TestSummary>> fetchTests() async {
    final rows = await _db
        .from('tests')
        .select('id, title, source, description, questions(count)')
        .order('created_at', ascending: false);
    return rows.map(TestSummary.fromJson).toList();
  }

  Future<TestDetail> fetchTest(String id) async {
    final test = await _db
        .from('tests')
        .select('id, title, source, description, questions(count)')
        .eq('id', id)
        .single();
    final groups = await _db
        .from('question_groups')
        .select('*, questions(*)')
        .eq('test_id', id)
        .order('order_no');
    return TestDetail(
      summary: TestSummary.fromJson(test),
      groups: groups.map(QuestionGroup.fromJson).toList(),
    );
  }

  /// Lưu bài làm; trả về id của attempt.
  Future<String> submitAttempt({
    required String testId,
    required String mode,
    required List<int> parts,
    required DateTime startedAt,
    required List<Question> questions,
    required Map<String, String> answers,
  }) async {
    var listening = 0, reading = 0;
    for (final q in questions) {
      if (answers[q.id] == q.answer) {
        ToeicScore.isListening(q.part) ? listening++ : reading++;
      }
    }
    final attempt = await _db
        .from('attempts')
        .insert({
          'test_id': testId,
          'mode': mode,
          'parts': parts,
          'started_at': startedAt.toUtc().toIso8601String(),
          'total_questions': questions.length,
          'listening_correct': listening,
          'reading_correct': reading,
        })
        .select('id')
        .single();
    final attemptId = attempt['id'] as String;
    await _db.from('attempt_answers').insert([
      for (final q in questions)
        {
          'attempt_id': attemptId,
          'question_id': q.id,
          'chosen': answers[q.id],
          'is_correct': answers[q.id] == q.answer,
        },
    ]);
    return attemptId;
  }

  Future<List<Attempt>> fetchAttempts() async {
    final rows = await _db
        .from('attempts')
        .select('*, tests(title)')
        .order('finished_at', ascending: false)
        .limit(100);
    return rows.map(Attempt.fromJson).toList();
  }

  Future<Attempt> fetchAttempt(String id) async {
    final row = await _db.from('attempts').select('*, tests(title)').eq('id', id).single();
    return Attempt.fromJson(row);
  }

  /// question_id -> đáp án đã chọn (null = bỏ trống)
  Future<Map<String, String?>> fetchAttemptAnswers(String attemptId) async {
    final rows = await _db
        .from('attempt_answers')
        .select('question_id, chosen')
        .eq('attempt_id', attemptId);
    return {for (final r in rows) r['question_id'] as String: r['chosen'] as String?};
  }

  Future<void> deleteAttempt(String id) => _db.from('attempts').delete().eq('id', id);

  Future<List<PartStat>> fetchPartStats() async {
    final rows = await _db.from('part_stats').select().order('part');
    return rows.map(PartStat.fromJson).toList();
  }
}
