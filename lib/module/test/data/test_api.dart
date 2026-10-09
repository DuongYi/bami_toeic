import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../core/network/postgrest.dart';
import 'models/test_models.dart';

part 'test_api.g.dart';

/// Endpoint PostgREST cho đề thi & bài làm. Bộ lọc dạng `eq.<value>` (xem [Pg]).
@RestApi()
abstract class TestApi {
  factory TestApi(Dio dio) = _TestApi;

  @GET('/rest/v1/tests')
  Future<List<TestSummary>> getTests({
    @Query('select') required String select,
    @Query('order') String? order,
  });

  @GET('/rest/v1/tests')
  @Headers({'Accept': Pg.single})
  Future<TestSummary> getTest({
    @Query('id') required String id,
    @Query('select') required String select,
  });

  @GET('/rest/v1/question_groups')
  Future<List<QuestionGroup>> getGroups({
    @Query('test_id') required String testId,
    @Query('select') required String select,
    @Query('order') String? order,
  });

  @POST('/rest/v1/attempts')
  @Headers({'Accept': Pg.single, 'Prefer': Pg.returnRepresentation})
  Future<Attempt> createAttempt(@Body() AttemptInsert body, {@Query('select') String? select});

  @POST('/rest/v1/attempt_answers')
  @Headers({'Prefer': Pg.returnMinimal})
  Future<void> createAttemptAnswers(@Body() List<AttemptAnswerInsert> body);

  @GET('/rest/v1/attempts')
  Future<List<Attempt>> getAttempts({
    @Query('select') required String select,
    @Query('order') String? order,
    @Query('limit') int? limit,
  });

  @GET('/rest/v1/attempts')
  @Headers({'Accept': Pg.single})
  Future<Attempt> getAttempt({
    @Query('id') required String id,
    @Query('select') required String select,
  });

  @GET('/rest/v1/attempt_answers')
  Future<List<AttemptAnswer>> getAttemptAnswers({
    @Query('attempt_id') required String attemptId,
    @Query('select') String select = 'question_id,chosen',
  });

  @DELETE('/rest/v1/attempts')
  Future<void> deleteAttempt({@Query('id') required String id});

  @GET('/rest/v1/part_stats')
  Future<List<PartStat>> getPartStats({@Query('order') String order = 'part'});

  /// Lần trả lời gần nhất của mỗi câu; lọc `is_correct=eq.false` để lấy sổ câu sai.
  @GET('/rest/v1/latest_answers')
  Future<List<LatestAnswer>> getLatestAnswers({
    @Query('is_correct') String? isCorrect,
    @Query('order') String order = 'finished_at.desc',
  });

  /// Nhóm câu theo danh sách id: `id=in.(a,b,c)`.
  @GET('/rest/v1/question_groups')
  Future<List<QuestionGroup>> getGroupsByIds({
    @Query('id') required String ids,
    @Query('select') String select = '*,questions(*)',
  });

  @GET('/rest/v1/tag_stats')
  Future<List<TagStat>> getTagStats();
}
