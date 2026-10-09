import 'package:dio/dio.dart' hide Headers;
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/network/postgrest.dart';
import 'models/leaderboard_models.dart';

part 'leaderboard_api.g.dart';

/// Thương Khung Bảng. Số liệu người khác chỉ đọc qua hàm SQL `leaderboard` (security definer);
/// bảng `profiles` thì RLS chỉ cho đọc/ghi dòng của chính mình.
@RestApi()
abstract class LeaderboardApi {
  factory LeaderboardApi(Dio dio) = _LeaderboardApi;

  @POST('/rest/v1/rpc/leaderboard')
  Future<List<LeaderboardEntry>> getLeaderboard(@Body() LeaderboardQuery body);

  @GET('/rest/v1/profiles')
  Future<List<LeaderboardProfile>> getProfile({
    @Query('select') String select = 'display_name,show_on_leaderboard',
  });

  /// Upsert theo khoá chính user_id (mặc định auth.uid()).
  @POST('/rest/v1/profiles')
  @Headers({'Prefer': Pg.upsert})
  Future<void> upsertProfile(@Body() ProfileUpsert body);
}

@JsonSerializable(createFactory: false)
class LeaderboardQuery {
  LeaderboardQuery(LeaderboardBoard board, {this.limit = 100}) : board = board.key;

  @JsonKey(name: 'p_board')
  final String board;
  @JsonKey(name: 'p_limit')
  final int limit;

  Map<String, dynamic> toJson() => _$LeaderboardQueryToJson(this);
}

@JsonSerializable(createFactory: false)
class ProfileUpsert {
  ProfileUpsert(LeaderboardProfile p)
    : displayName = p.displayName,
      showOnLeaderboard = p.showOnLeaderboard,
      updatedAt = DateTime.now().toUtc();

  final String? displayName;
  final bool showOnLeaderboard;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$ProfileUpsertToJson(this);
}
