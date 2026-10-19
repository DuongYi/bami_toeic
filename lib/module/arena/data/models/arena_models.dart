import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../test/data/models/test_models.dart';

part 'arena_models.freezed.dart';
part 'arena_models.g.dart';

// ===================== Thi trực tiếp Chủ nhật =====================

/// 1 kỳ thi Chủ nhật (hàm `contest_overview`).
@freezed
abstract class ContestInfo with _$ContestInfo {
  const ContestInfo._();

  const factory ContestInfo({
    required String id,
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required int questionCount,
    @Default(0) int participants,
    @Default(false) bool joined,
    @Default(false) bool submitted,
    int? correct,
  }) = _ContestInfo;

  factory ContestInfo.fromJson(Map<String, dynamic> json) => _$ContestInfoFromJson(json);

  ContestPhase phaseAt(DateTime now) => now.isBefore(startsAt)
      ? ContestPhase.upcoming
      : now.isBefore(endsAt)
      ? ContestPhase.live
      : ContestPhase.finished;
}

enum ContestPhase { upcoming, live, finished }

@freezed
abstract class ContestOverview with _$ContestOverview {
  const factory ContestOverview({
    required DateTime serverNow,
    ContestInfo? current,
    ContestInfo? previous,
  }) = _ContestOverview;

  factory ContestOverview.fromJson(Map<String, dynamic> json) => _$ContestOverviewFromJson(json);
}

/// Câu trong đề phát ra (không kèm đáp án), đánh số 1..N.
@freezed
abstract class PaperQuestion with _$PaperQuestion {
  const factory PaperQuestion({
    required int n,
    required int part,
    String? content,
    @Default(<String>[]) List<String> options,
  }) = _PaperQuestion;

  factory PaperQuestion.fromJson(Map<String, dynamic> json) => _$PaperQuestionFromJson(json);
}

@freezed
abstract class PaperGroup with _$PaperGroup {
  const factory PaperGroup({
    required int part,
    String? passage,
    String? audioUrl,
    String? imageUrl,
    String? transcript,
    @Default(<PaperQuestion>[]) List<PaperQuestion> questions,
  }) = _PaperGroup;

  factory PaperGroup.fromJson(Map<String, dynamic> json) => _$PaperGroupFromJson(json);
}

/// Đề thi Chủ nhật khi vào phòng (`contest_join`).
@freezed
abstract class ContestPaper with _$ContestPaper {
  const factory ContestPaper({
    required String id,
    required String title,
    required DateTime endsAt,
    required DateTime serverNow,
    required DateTime joinedAt,
    @Default(<String, String>{}) Map<String, String> answers,
    @Default(<PaperGroup>[]) List<PaperGroup> groups,
  }) = _ContestPaper;

  factory ContestPaper.fromJson(Map<String, dynamic> json) => _$ContestPaperFromJson(json);
}

@freezed
abstract class ContestResult with _$ContestResult {
  const factory ContestResult({
    required int correct,
    required int listeningCorrect,
    required int readingCorrect,
    required int questionCount,
  }) = _ContestResult;

  factory ContestResult.fromJson(Map<String, dynamic> json) => _$ContestResultFromJson(json);
}

/// 1 dòng bảng xếp hạng kỳ thi (`contest_board`).
@freezed
abstract class ContestRank with _$ContestRank {
  const factory ContestRank({
    required int rank,
    required String displayName,
    @Default(false) bool isMe,
    required int correct,
    required int durationMs,
    required int total,

    /// % người thi xếp sau mình (chỉ có khi mình đã nộp).
    int? percentile,
  }) = _ContestRank;

  factory ContestRank.fromJson(Map<String, dynamic> json) => _$ContestRankFromJson(json);
}

@freezed
abstract class ReviewKey with _$ReviewKey {
  const factory ReviewKey({required String a, String? e}) = _ReviewKey;

  factory ReviewKey.fromJson(Map<String, dynamic> json) => _$ReviewKeyFromJson(json);
}

/// Xem lại sau kỳ thi (PRO): đề + đáp án đúng + bài của mình.
@freezed
abstract class ContestReview with _$ContestReview {
  const factory ContestReview({
    required String id,
    required String title,
    @Default(<PaperGroup>[]) List<PaperGroup> groups,
    @Default(<String, String>{}) Map<String, String> answers,
    @Default(<String, ReviewKey>{}) Map<String, ReviewKey> key,
  }) = _ContestReview;

  factory ContestReview.fromJson(Map<String, dynamic> json) => _$ContestReviewFromJson(json);
}

/// Đề phát ra → model nhóm câu của màn làm bài. Id câu = `c` + số câu; [key] có thì gắn đáp án.
List<QuestionGroup> paperToGroups(
  String paperId,
  List<PaperGroup> groups, {
  Map<String, ReviewKey> key = const {},
}) => [
  for (final (i, g) in groups.indexed)
    QuestionGroup(
      id: '$paperId-g$i',
      part: g.part,
      orderNo: i + 1,
      passage: g.passage,
      audioUrl: g.audioUrl,
      imageUrl: g.imageUrl,
      transcript: g.transcript,
      questions: [
        for (final q in g.questions)
          Question(
            id: paperQuestionId(q.n),
            part: q.part,
            number: q.n,
            content: q.content,
            options: q.options,
            answer: key['${q.n}']?.a ?? '',
            explanation: key['${q.n}']?.e,
          ),
      ],
    ),
];

String paperQuestionId(int n) => 'c$n';

// ===================== Đấu 1 vs 1 =====================

enum DuelStatus { waiting, active, finished, cancelled }

@freezed
abstract class DuelRules with _$DuelRules {
  const factory DuelRules({
    @Default(10) int questions,
    @Default(20) int secondsPerQuestion,
    @Default(240) int maxSeconds,
    @Default(3) int freePerDay,
  }) = _DuelRules;

  factory DuelRules.fromJson(Map<String, dynamic> json) => _$DuelRulesFromJson(json);
}

@freezed
abstract class DuelSide with _$DuelSide {
  const factory DuelSide({
    required String name,
    @Default(false) bool isBot,
    @Default(0) int answered,
    @Default(0) int correct,
    @Default(0) int timeMs,
    @Default(false) bool finished,
  }) = _DuelSide;

  factory DuelSide.fromJson(Map<String, dynamic> json) => _$DuelSideFromJson(json);
}

/// Trạng thái trận (`duel_state`). [winner]: "me" | "opp" | "draw" khi trận xong.
@freezed
abstract class DuelState with _$DuelState {
  const DuelState._();

  const factory DuelState({
    required String id,
    @JsonKey(unknownEnumValue: DuelStatus.cancelled) required DuelStatus status,
    String? code,
    required DateTime serverNow,
    DateTime? startedAt,
    required int questionCount,
    @Default(DuelRules()) DuelRules rules,
    required DuelSide me,
    DuelSide? opponent,
    String? winner,
  }) = _DuelState;

  factory DuelState.fromJson(Map<String, dynamic> json) => _$DuelStateFromJson(json);
}

@freezed
abstract class DuelQuestion with _$DuelQuestion {
  const factory DuelQuestion({
    required int n,
    required String content,
    @Default(<String>[]) List<String> options,
  }) = _DuelQuestion;

  factory DuelQuestion.fromJson(Map<String, dynamic> json) => _$DuelQuestionFromJson(json);
}

@freezed
abstract class DuelAnswerResult with _$DuelAnswerResult {
  const factory DuelAnswerResult({
    required bool ok,
    required String answer,
    String? explanation,
  }) = _DuelAnswerResult;

  factory DuelAnswerResult.fromJson(Map<String, dynamic> json) =>
      _$DuelAnswerResultFromJson(json);
}

@freezed
abstract class DuelStats with _$DuelStats {
  const factory DuelStats({
    @Default(0) int wins,
    @Default(0) int losses,
    @Default(0) int draws,
    @Default(0) int playedToday,

    /// Lượt miễn phí còn lại hôm nay; null = PRO, không giới hạn.
    int? leftToday,
  }) = _DuelStats;

  factory DuelStats.fromJson(Map<String, dynamic> json) => _$DuelStatsFromJson(json);
}

@freezed
abstract class DuelRef with _$DuelRef {
  const factory DuelRef({required String id, String? code}) = _DuelRef;

  factory DuelRef.fromJson(Map<String, dynamic> json) => _$DuelRefFromJson(json);
}
