import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import 'leaderboard_api.dart';
import 'models/leaderboard_models.dart';

part 'leaderboard_repository.g.dart';

@Riverpod(keepAlive: true)
LeaderboardApi leaderboardApi(Ref ref) => LeaderboardApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
LeaderboardRepository leaderboardRepository(Ref ref) =>
    LeaderboardRepository(ref.watch(leaderboardApiProvider));

class LeaderboardRepository {
  LeaderboardRepository(this._api);

  final LeaderboardApi _api;

  Future<List<LeaderboardEntry>> fetchBoard(LeaderboardBoard board) =>
      _api.getLeaderboard(LeaderboardQuery(board));

  /// Chưa từng lưu → hồ sơ mặc định (tên tự sinh, hiện trên bảng).
  Future<LeaderboardProfile> fetchProfile() async =>
      (await _api.getProfile()).firstOrNull ?? const LeaderboardProfile();

  Future<void> saveProfile(LeaderboardProfile p) => _api.upsertProfile(ProfileUpsert(p));
}
