import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/media/media_repository.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/postgrest.dart';
import '../../../helper/score.dart';
import 'models/test_models.dart';
import 'test_api.dart';

part 'test_repository.g.dart';

@Riverpod(keepAlive: true)
TestApi testApi(Ref ref) => TestApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
TestRepository testRepository(Ref ref) =>
    TestRepository(ref.watch(testApiProvider), ref.watch(mediaRepositoryProvider));

class TestRepository {
  TestRepository(this._api, this._media);

  final TestApi _api;
  final MediaRepository _media;

  /// Đổi URL audio/ảnh sang URL ký tạm (bucket media riêng tư).
  Future<List<QuestionGroup>> _withSignedMedia(List<QuestionGroup> groups) async {
    final signed = await _media.signAll([
      for (final g in groups) ...[?g.audioUrl, ?g.imageUrl],
    ]);
    return [
      for (final g in groups)
        g.copyWith(
          audioUrl: g.audioUrl == null ? null : signed[g.audioUrl],
          imageUrl: g.imageUrl == null ? null : signed[g.imageUrl],
        ),
    ];
  }

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
      groups: await _withSignedMedia([
        for (final g in groups)
          g.copyWith(questions: [...g.questions]..sort((a, b) => a.number.compareTo(b.number))),
      ]),
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
    String source = 'test',
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
        source: source,
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
    final answered = {for (final a in answers) a.questionId: a.chosen};
    var groups = detail.groups.where((g) => attempt.parts.contains(g.part)).toList();
    if (attempt.isMistakeReview) {
      // Lượt luyện sổ câu sai chỉ gồm vài câu lẻ → chỉ hiện đúng các câu đã luyện.
      groups = [
        for (final g in groups)
          if (g.questions.any((q) => answered.containsKey(q.id)))
            g.copyWith(questions: [...g.questions.where((q) => answered.containsKey(q.id))]),
      ];
    }
    return AttemptResult(attempt: attempt, groups: groups, answers: answered);
  }

  Future<void> deleteAttempt(String id) => _api.deleteAttempt(id: Pg.eq(id));

  Future<List<PartStat>> fetchPartStats() => _api.getPartStats();

  Future<List<TagStat>> fetchTagStats() => _api.getTagStats();

  /// Sổ câu sai: câu sai hoặc bỏ trống ở lần trả lời gần nhất.
  Future<List<LatestAnswer>> fetchMistakes() => _api.getLatestAnswers(isCorrect: Pg.eq(false));

  /// Nhóm câu chứa các câu sai, mỗi nhóm CHỈ giữ lại câu sai (đoạn văn/audio giữ nguyên).
  Future<List<QuestionGroup>> fetchMistakeGroups(List<LatestAnswer> mistakes) async {
    final wrongIds = {for (final m in mistakes) m.questionId};
    final groupIds = {for (final m in mistakes) m.groupId}.toList();
    final groups = <QuestionGroup>[];
    for (var i = 0; i < groupIds.length; i += 40) {
      // chia lô để URL `id=in.(…)` không quá dài
      final chunk = groupIds.sublist(i, (i + 40).clamp(0, groupIds.length));
      groups.addAll(await _api.getGroupsByIds(ids: 'in.(${chunk.join(',')})'));
    }
    final firstNumber = {for (final m in mistakes) m.groupId: m.number};
    return _withSignedMedia(
      [
        for (final g in groups)
          g.copyWith(
            questions: [...g.questions.where((q) => wrongIds.contains(q.id))]
              ..sort((a, b) => a.number.compareTo(b.number)),
          ),
      ]..sort((a, b) {
        final byPart = a.part.compareTo(b.part);
        return byPart != 0 ? byPart : (firstNumber[a.id] ?? 0).compareTo(firstNumber[b.id] ?? 0);
      }),
    );
  }

  /// Nộp bài luyện sổ câu sai: tách thành 1 lượt làm / đề (source = 'mistakes').
  /// Trả về (số câu đúng, tổng số câu).
  Future<(int, int)> submitMistakePractice({
    required String mode,
    required DateTime startedAt,
    required List<QuestionGroup> groups,
    required Map<String, String> answers,
  }) async {
    final byTest = <String, List<Question>>{};
    for (final g in groups) {
      byTest.putIfAbsent(g.testId ?? '', () => []).addAll(g.questions);
    }
    var correct = 0, total = 0;
    for (final MapEntry(key: testId, value: qs) in byTest.entries) {
      if (testId.isEmpty) continue;
      await submitAttempt(
        testId: testId,
        mode: mode,
        parts: ({for (final q in qs) q.part}.toList()..sort()),
        startedAt: startedAt,
        questions: qs,
        answers: answers,
        source: 'mistakes',
      );
      total += qs.length;
      correct += qs.where((q) => answers[q.id] == q.answer).length;
    }
    return (correct, total);
  }
}
