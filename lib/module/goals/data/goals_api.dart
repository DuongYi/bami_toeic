import 'package:dio/dio.dart' hide Headers;
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/network/postgrest.dart';
import 'study_store.dart';

part 'goals_api.g.dart';

/// Mục tiêu + nhật ký học theo ngày của user hiện tại (RLS lọc theo auth.uid()).
@RestApi()
abstract class GoalsApi {
  factory GoalsApi(Dio dio) = _GoalsApi;

  @GET('/rest/v1/user_goals')
  Future<List<GoalSettings>> getGoals();

  /// Upsert theo khoá chính user_id (mặc định auth.uid()).
  @POST('/rest/v1/user_goals')
  @Headers({'Prefer': Pg.upsert})
  Future<void> upsertGoals(@Body() GoalsUpsert body);

  @GET('/rest/v1/study_days')
  Future<List<StudyDayRow>> getStudyDays({
    @Query('day') required String since,
    @Query('select') String select = 'day,questions,mistakes,words,dictations',
  });

  /// Cộng dồn nguyên tử số liệu 1 ngày (hàm SQL bump_study_day).
  @POST('/rest/v1/rpc/bump_study_day')
  Future<void> bumpStudyDay(@Body() StudyDayBump body);
}

@JsonSerializable(createFactory: false)
class GoalsUpsert {
  GoalsUpsert(GoalSettings g)
    : targetScore = g.targetScore,
      examDate = g.examDate == null ? null : dayKey(g.examDate!),
      dailyQuestions = g.dailyQuestions,
      dailyWords = g.dailyWords,
      dailyDictations = g.dailyDictations,
      reminderMinutes = g.reminderMinutes,
      updatedAt = DateTime.now().toUtc();

  final int? targetScore;

  /// Cột `date`: gửi "yyyy-mm-dd" theo lịch của người dùng.
  final String? examDate;
  final int dailyQuestions;
  final int dailyWords;
  final int dailyDictations;
  final int? reminderMinutes;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$GoalsUpsertToJson(this);
}

@JsonSerializable(createFactory: false)
class StudyDayBump {
  StudyDayBump(this.day, DayLog d)
    : questions = d.questions,
      mistakes = d.mistakes,
      words = d.words,
      dictations = d.dictations;

  @JsonKey(name: 'p_day')
  final String day;
  @JsonKey(name: 'p_questions')
  final int questions;
  @JsonKey(name: 'p_mistakes')
  final int mistakes;
  @JsonKey(name: 'p_words')
  final int words;
  @JsonKey(name: 'p_dictations')
  final int dictations;

  Map<String, dynamic> toJson() => _$StudyDayBumpToJson(this);
}

@JsonSerializable(createToJson: false)
class StudyDayRow {
  const StudyDayRow({
    required this.day,
    this.questions = 0,
    this.mistakes = 0,
    this.words = 0,
    this.dictations = 0,
  });

  /// "yyyy-mm-dd"
  final String day;
  final int questions;
  final int mistakes;
  final int words;
  final int dictations;

  factory StudyDayRow.fromJson(Map<String, dynamic> json) => _$StudyDayRowFromJson(json);

  DayLog get log =>
      DayLog(questions: questions, mistakes: mistakes, words: words, dictations: dictations);
}
