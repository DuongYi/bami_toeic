import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../core/network/postgrest.dart';
import 'models/vocab_models.dart';

part 'vocab_api.g.dart';

@RestApi()
abstract class VocabApi {
  factory VocabApi(Dio dio) = _VocabApi;

  /// Supabase trả tối đa 1000 dòng / request (Max Rows) → lấy theo trang bằng offset/limit.
  @GET('/rest/v1/vocab')
  Future<List<VocabItem>> getVocab({
    @Query('select') String select = '*,vocab_reviews(ease,interval_days,repetitions,due_at)',
    @Query('order') String order = 'word,id',
    @Query('offset') int offset = 0,
    @Query('limit') int limit = VocabApi.pageSize,
  });

  static const pageSize = 1000;

  @POST('/rest/v1/vocab')
  @Headers({'Prefer': Pg.returnMinimal})
  Future<void> createVocab(@Body() VocabInput body);

  /// Trả về các dòng đã sửa: rỗng nghĩa là RLS chặn (từ dùng chung, không phải admin).
  @PATCH('/rest/v1/vocab')
  @Headers({'Prefer': Pg.returnRepresentation})
  Future<List<VocabItem>> updateVocab(@Body() VocabInput body, {@Query('id') required String id});

  @DELETE('/rest/v1/vocab')
  @Headers({'Prefer': Pg.returnRepresentation})
  Future<List<VocabItem>> deleteVocab({@Query('id') required String id});

  @POST('/rest/v1/vocab_reviews')
  @Headers({'Prefer': Pg.upsert})
  Future<void> upsertReview(
    @Body() VocabReviewUpsert body, {
    @Query('on_conflict') String onConflict = 'user_id,vocab_id',
  });
}
