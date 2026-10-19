import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'models/arena_models.dart';

part 'arena_api.g.dart';

/// Thi Chủ nhật + Đấu 1 vs 1. Mọi thứ qua hàm SQL security definer (đề không kèm đáp án,
/// chấm trên server); các bảng không mở RLS đọc trực tiếp.
@RestApi()
abstract class ArenaApi {
  factory ArenaApi(Dio dio) = _ArenaApi;

  @POST('/rest/v1/rpc/contest_overview')
  Future<ContestOverview> contestOverview();

  @POST('/rest/v1/rpc/contest_join')
  Future<ContestPaper> contestJoin(@Body() Map<String, dynamic> body);

  @POST('/rest/v1/rpc/contest_save')
  Future<void> contestSave(@Body() Map<String, dynamic> body);

  @POST('/rest/v1/rpc/contest_submit')
  Future<ContestResult> contestSubmit(@Body() Map<String, dynamic> body);

  @POST('/rest/v1/rpc/contest_board')
  Future<List<ContestRank>> contestBoard(@Body() Map<String, dynamic> body);

  @POST('/rest/v1/rpc/contest_review')
  Future<ContestReview> contestReview(@Body() Map<String, dynamic> body);

  @POST('/rest/v1/rpc/duel_find')
  Future<DuelRef> duelFind();

  @POST('/rest/v1/rpc/duel_invite')
  Future<DuelRef> duelInvite();

  @POST('/rest/v1/rpc/duel_join')
  Future<DuelRef> duelJoin(@Body() Map<String, dynamic> body);

  @POST('/rest/v1/rpc/duel_vs_bot')
  Future<void> duelVsBot(@Body() Map<String, dynamic> body);

  @POST('/rest/v1/rpc/duel_cancel')
  Future<void> duelCancel(@Body() Map<String, dynamic> body);

  @POST('/rest/v1/rpc/duel_state')
  Future<DuelState> duelState(@Body() Map<String, dynamic> body);

  @POST('/rest/v1/rpc/duel_questions')
  Future<List<DuelQuestion>> duelQuestions(@Body() Map<String, dynamic> body);

  @POST('/rest/v1/rpc/duel_answer')
  Future<DuelAnswerResult> duelAnswer(@Body() Map<String, dynamic> body);

  @POST('/rest/v1/rpc/duel_stats')
  Future<DuelStats> duelStats();
}
