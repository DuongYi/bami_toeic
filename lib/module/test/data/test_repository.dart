import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/postgrest.dart';
import '../../../helper/score.dart';
import 'models/test_models.dart';
import 'test_api.dart';

part 'test_repository.g.dart';

@Riverpod(keepAlive: true)
TestApi testApi(Ref ref) => TestApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
TestRepository testRepository(Ref ref) => TestRepository(ref.watch(testApiProvider));

class TestRepository {
  TestRepository(this._api);

  final TestApi _api;

  static const _testSelect = 'id,title,source,description,questions(count)';
  static const _attemptSelect = '*,tests(title)';

  Future<List<TestSummary>> fetchTests() =>
      _api.getTests(select: _testSelect, order: 'created_at.desc');

  Future<TestDetail> fetchTest(String id) async {
    final (summary, groups) = await (
      _api.getTest(id: Pg.eq(id), select: _testSelect),
      _api.getGroups(testId: Pg.eq(id), select: '*,questions(*)', order: 'order_no'),
    ).wait;
    return TestDetail(
      summary: summary,
      groups: [
        for (final g in groups)
          g.copyWith(questions: [...g.questions]..sort((a, b) => a.number.compareTo(b.number))),
      ],
    );
  }

  /// Chấm và lưu bài làm; trả về attempt vừa tạo.
  Future<Attempt> submitAttempt({
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
    final attempt = await _api.createAttempt(
      AttemptInsert(
        testId: testId,
        mode: mode,
        parts: parts,
        startedAt: startedAt.toUtc(),
        totalQuestions: questions.length,
        listeningCorrect: listening,
        readingCorrect: reading,
      ),
      select: _attemptSelect,
    );
    await _api.createAttemptAnswers([
      for (final q in questions)
        AttemptAnswerInsert(
          attemptId: attempt.id,
          questionId: q.id,
          chosen: answers[q.id],
          isCorrect: answers[q.id] == q.answer,
        ),
    ]);
    return attempt;
  }

  Future<List<Attempt>> fetchAttempts() =>
      _api.getAttempts(select: _attemptSelect, order: 'finished_at.desc', limit: 100);

  Future<AttemptResult> fetchResult(String attemptId) async {
    final attempt = await _api.getAttempt(id: Pg.eq(attemptId), select: _attemptSelect);
    final (detail, answers) = await (
      fetchTest(attempt.testId),
      _api.getAttemptAnswers(attemptId: Pg.eq(attemptId)),
    ).wait;
    return AttemptResult(
      attempt: attempt,
      groups: detail.groups.where((g) => attempt.parts.contains(g.part)).toList(),
      answers: {for (final a in answers) a.questionId: a.chosen},
    );
  }

  Future<void> deleteAttempt(String id) => _api.deleteAttempt(id: Pg.eq(id));

  Future<List<PartStat>> fetchPartStats() => _api.getPartStats();
}
