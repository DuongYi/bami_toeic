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
    @Query('select') String select = 'question_id,chosen,time_spent_ms',
  });

  @DELETE('/rest/v1/attempts')
  Future<void> deleteAttempt({@Query('id') required String id});

  @GET('/rest/v1/part_stats')
  Future<List<PartStat>> getPartStats({@Query('order') String order = 'part'});

  /// Nhóm câu theo danh sách id: `id=in.(a,b,c)`.
  @GET('/rest/v1/question_groups')
  Future<List<QuestionGroup>> getGroupsByIds({
    @Query('id') required String ids,
    @Query('select') String select = '*,questions(*)',
  });

  /// Câu từng sai còn trong sổ (chưa thuộc), hạn ôn sớm nhất trước.
  @GET('/rest/v1/question_reviews')
  Future<List<QuestionReview>> getQuestionReviews({
    @Query('mastered') String mastered = 'eq.false',
    @Query('order') String order = 'due_at.asc',
  });

  @GET('/rest/v1/saved_question_info')
  Future<List<SavedQuestion>> getSavedQuestions({
    @Query('order') String order = 'created_at.desc',
  });

  @POST('/rest/v1/saved_questions')
  @Headers({'Prefer': Pg.upsert})
  Future<void> saveQuestion(
    @Body() Map<String, dynamic> body, {
    @Query('on_conflict') String onConflict = 'user_id,question_id',
  });

  @DELETE('/rest/v1/saved_questions')
  Future<void> unsaveQuestion({@Query('question_id') required String questionId});

  /// Câu thuộc các dạng cho trước (`tags=ov.{a,b}`); RLS chỉ trả câu của đề người học mở được.
  @GET('/rest/v1/questions')
  Future<List<QuestionStub>> getQuestionsByTags({
    @Query('tags') required String tags,
    @Query('select') String select = 'id,group_id,part,number,tags',
    @Query('order') String order = 'test_id,number',
    @Query('limit') int limit = 400,
  });

  /// Câu nào trong danh sách đã từng làm: `question_id=in.(…)`.
  @GET('/rest/v1/latest_answers')
  Future<List<AnsweredStub>> getAnsweredAmong({
    @Query('question_id') required String ids,
    @Query('select') String select = 'question_id',
  });

  @GET('/rest/v1/tag_stats')
  Future<List<TagStat>> getTagStats();

  /// Bài làm dở của user (RLS); lọc 1 đề bằng `test_id=eq.<id>`.
  @GET('/rest/v1/in_progress')
  Future<List<InProgressRow>> getInProgress({
    @Query('test_id') String? testId,
    @Query('select') String select = 'test_id,snapshot,saved_at',
  });

  @POST('/rest/v1/in_progress')
  @Headers({'Prefer': Pg.upsert})
  Future<void> upsertInProgress(
    @Body() InProgressUpsert body, {
    @Query('on_conflict') String onConflict = 'user_id,test_id',
  });

  @DELETE('/rest/v1/in_progress')
  Future<void> deleteInProgress({@Query('test_id') required String testId});
}
