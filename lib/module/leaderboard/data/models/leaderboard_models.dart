import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_models.freezed.dart';
part 'leaderboard_models.g.dart';

/// Loại bảng: điểm full test cao nhất / số câu tuần này (mùa giải, từ thứ Hai giờ VN) /
/// chuỗi ngày học hiện tại.
enum LeaderboardBoard {
  score('score'),
  week('week'),
  streak('streak');

  const LeaderboardBoard(this.key);

  /// Giá trị `p_board` của hàm SQL `leaderboard`.
  final String key;
}

/// 1 dòng của hàm SQL `leaderboard` (chỉ số liệu tổng hợp, không có email).
@freezed
abstract class LeaderboardEntry with _$LeaderboardEntry {
  const LeaderboardEntry._();

  const factory LeaderboardEntry({
    /// null = chưa đủ dữ liệu để xếp hạng (chỉ xảy ra với dòng của chính mình).
    int? rank,
    required String userId,
    required String displayName,
    @Default(false) bool isMe,
    int? bestScore,
    int? bestListening,
    int? bestReading,
    @Default(0) int fullTests,
    @Default(0) int weekQuestions,
    @Default(0) int weekCorrect,

    /// Số ngày học liên tiếp tính tới hôm nay / hôm qua.
    @Default(0) int streak,

    /// Hạng 1–3 của mùa tuần trước; null nếu ngoài top 3.
    int? lastWeekRank,
  }) = _LeaderboardEntry;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) => _$LeaderboardEntryFromJson(json);

  double get weekAccuracy => weekQuestions == 0 ? 0 : weekCorrect / weekQuestions;
}

/// Hồ sơ hiển thị trên bảng xếp hạng (bảng `profiles`).
@freezed
abstract class LeaderboardProfile with _$LeaderboardProfile {
  const factory LeaderboardProfile({String? displayName, @Default(true) bool showOnLeaderboard}) =
      _LeaderboardProfile;

  factory LeaderboardProfile.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardProfileFromJson(json);
}
