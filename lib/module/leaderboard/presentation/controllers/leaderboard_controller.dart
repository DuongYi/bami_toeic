import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/leaderboard_repository.dart';
import '../../data/models/leaderboard_models.dart';

part 'leaderboard_controller.g.dart';

@riverpod
Future<List<LeaderboardEntry>> leaderboard(Ref ref, LeaderboardBoard board) =>
    ref.watch(leaderboardRepositoryProvider).fetchBoard(board);

/// Tên hiển thị + tuỳ chọn ẩn khỏi bảng của user hiện tại. keepAlive: sheet hồ sơ đọc `.future`
/// từ nhiều nơi; tự tải lại khi đổi tài khoản.
@Riverpod(keepAlive: true)
class MyLeaderboardProfile extends _$MyLeaderboardProfile {
  @override
  Future<LeaderboardProfile> build() {
    ref.watch(currentUserIdProvider);
    return ref.watch(leaderboardRepositoryProvider).fetchProfile();
  }

  Future<void> save(LeaderboardProfile profile) async {
    await ref.read(leaderboardRepositoryProvider).saveProfile(profile);
    if (!ref.mounted) return;
    state = AsyncData(profile);
    ref.invalidate(leaderboardProvider);
  }
}
