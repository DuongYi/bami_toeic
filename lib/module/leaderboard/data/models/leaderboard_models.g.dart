// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaderboardEntry _$LeaderboardEntryFromJson(Map<String, dynamic> json) => _LeaderboardEntry(
  rank: (json['rank'] as num?)?.toInt(),
  userId: json['user_id'] as String,
  displayName: json['display_name'] as String,
  isMe: json['is_me'] as bool? ?? false,
  bestScore: (json['best_score'] as num?)?.toInt(),
  bestListening: (json['best_listening'] as num?)?.toInt(),
  bestReading: (json['best_reading'] as num?)?.toInt(),
  fullTests: (json['full_tests'] as num?)?.toInt() ?? 0,
  weekQuestions: (json['week_questions'] as num?)?.toInt() ?? 0,
  weekCorrect: (json['week_correct'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$LeaderboardEntryToJson(_LeaderboardEntry instance) => <String, dynamic>{
  'rank': instance.rank,
  'user_id': instance.userId,
  'display_name': instance.displayName,
  'is_me': instance.isMe,
  'best_score': instance.bestScore,
  'best_listening': instance.bestListening,
  'best_reading': instance.bestReading,
  'full_tests': instance.fullTests,
  'week_questions': instance.weekQuestions,
  'week_correct': instance.weekCorrect,
};

_LeaderboardProfile _$LeaderboardProfileFromJson(Map<String, dynamic> json) => _LeaderboardProfile(
  displayName: json['display_name'] as String?,
  showOnLeaderboard: json['show_on_leaderboard'] as bool? ?? true,
);

Map<String, dynamic> _$LeaderboardProfileToJson(_LeaderboardProfile instance) => <String, dynamic>{
  'display_name': instance.displayName,
  'show_on_leaderboard': instance.showOnLeaderboard,
};
