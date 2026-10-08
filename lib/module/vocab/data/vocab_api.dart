import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../core/network/postgrest.dart';
import 'models/vocab_models.dart';

part 'vocab_api.g.dart';

@RestApi()
abstract class VocabApi {
  factory VocabApi(Dio dio) = _VocabApi;

  @GET('/rest/v1/vocab')
  Future<List<VocabItem>> getVocab({
    @Query('select') String select = '*,vocab_reviews(ease,interval_days,repetitions,due_at)',
    @Query('order') String order = 'word',
  });

  @POST('/rest/v1/vocab')
  @Headers({'Prefer': Pg.returnMinimal})
  Future<void> createVocab(@Body() VocabInput body);

  @PATCH('/rest/v1/vocab')
  @Headers({'Prefer': Pg.returnMinimal})
  Future<void> updateVocab(@Body() VocabInput body, {@Query('id') required String id});

  @DELETE('/rest/v1/vocab')
  Future<void> deleteVocab({@Query('id') required String id});

  @POST('/rest/v1/vocab_reviews')
  @Headers({'Prefer': Pg.upsert})
  Future<void> upsertReview(
    @Body() VocabReviewUpsert body, {
    @Query('on_conflict') String onConflict = 'user_id,vocab_id',
  });
}
