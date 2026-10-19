// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arena_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContestInfo _$ContestInfoFromJson(Map<String, dynamic> json) => _ContestInfo(
  id: json['id'] as String,
  title: json['title'] as String,
  startsAt: DateTime.parse(json['starts_at'] as String),
  endsAt: DateTime.parse(json['ends_at'] as String),
  questionCount: (json['question_count'] as num).toInt(),
  participants: (json['participants'] as num?)?.toInt() ?? 0,
  joined: json['joined'] as bool? ?? false,
  submitted: json['submitted'] as bool? ?? false,
  correct: (json['correct'] as num?)?.toInt(),
);

Map<String, dynamic> _$ContestInfoToJson(_ContestInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'starts_at': instance.startsAt.toIso8601String(),
      'ends_at': instance.endsAt.toIso8601String(),
      'question_count': instance.questionCount,
      'participants': instance.participants,
      'joined': instance.joined,
      'submitted': instance.submitted,
      'correct': instance.correct,
    };

_ContestOverview _$ContestOverviewFromJson(Map<String, dynamic> json) =>
    _ContestOverview(
      serverNow: DateTime.parse(json['server_now'] as String),
      current: json['current'] == null
          ? null
          : ContestInfo.fromJson(json['current'] as Map<String, dynamic>),
      previous: json['previous'] == null
          ? null
          : ContestInfo.fromJson(json['previous'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContestOverviewToJson(_ContestOverview instance) =>
    <String, dynamic>{
      'server_now': instance.serverNow.toIso8601String(),
      'current': instance.current?.toJson(),
      'previous': instance.previous?.toJson(),
    };

_PaperQuestion _$PaperQuestionFromJson(Map<String, dynamic> json) =>
    _PaperQuestion(
      n: (json['n'] as num).toInt(),
      part: (json['part'] as num).toInt(),
      content: json['content'] as String?,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$PaperQuestionToJson(_PaperQuestion instance) =>
    <String, dynamic>{
      'n': instance.n,
      'part': instance.part,
      'content': instance.content,
      'options': instance.options,
    };

_PaperGroup _$PaperGroupFromJson(Map<String, dynamic> json) => _PaperGroup(
  part: (json['part'] as num).toInt(),
  passage: json['passage'] as String?,
  audioUrl: json['audio_url'] as String?,
  imageUrl: json['image_url'] as String?,
  transcript: json['transcript'] as String?,
  questions:
      (json['questions'] as List<dynamic>?)
          ?.map((e) => PaperQuestion.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PaperQuestion>[],
);

Map<String, dynamic> _$PaperGroupToJson(_PaperGroup instance) =>
    <String, dynamic>{
      'part': instance.part,
      'passage': instance.passage,
      'audio_url': instance.audioUrl,
      'image_url': instance.imageUrl,
      'transcript': instance.transcript,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
    };

_ContestPaper _$ContestPaperFromJson(Map<String, dynamic> json) =>
    _ContestPaper(
      id: json['id'] as String,
      title: json['title'] as String,
      endsAt: DateTime.parse(json['ends_at'] as String),
      serverNow: DateTime.parse(json['server_now'] as String),
      joinedAt: DateTime.parse(json['joined_at'] as String),
      answers:
          (json['answers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      groups:
          (json['groups'] as List<dynamic>?)
              ?.map((e) => PaperGroup.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PaperGroup>[],
    );

Map<String, dynamic> _$ContestPaperToJson(_ContestPaper instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'ends_at': instance.endsAt.toIso8601String(),
      'server_now': instance.serverNow.toIso8601String(),
      'joined_at': instance.joinedAt.toIso8601String(),
      'answers': instance.answers,
      'groups': instance.groups.map((e) => e.toJson()).toList(),
    };

_ContestResult _$ContestResultFromJson(Map<String, dynamic> json) =>
    _ContestResult(
      correct: (json['correct'] as num).toInt(),
      listeningCorrect: (json['listening_correct'] as num).toInt(),
      readingCorrect: (json['reading_correct'] as num).toInt(),
      questionCount: (json['question_count'] as num).toInt(),
    );

Map<String, dynamic> _$ContestResultToJson(_ContestResult instance) =>
    <String, dynamic>{
      'correct': instance.correct,
      'listening_correct': instance.listeningCorrect,
      'reading_correct': instance.readingCorrect,
      'question_count': instance.questionCount,
    };

_ContestRank _$ContestRankFromJson(Map<String, dynamic> json) => _ContestRank(
  rank: (json['rank'] as num).toInt(),
  displayName: json['display_name'] as String,
  isMe: json['is_me'] as bool? ?? false,
  correct: (json['correct'] as num).toInt(),
  durationMs: (json['duration_ms'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  percentile: (json['percentile'] as num?)?.toInt(),
);

Map<String, dynamic> _$ContestRankToJson(_ContestRank instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'display_name': instance.displayName,
      'is_me': instance.isMe,
      'correct': instance.correct,
      'duration_ms': instance.durationMs,
      'total': instance.total,
      'percentile': instance.percentile,
    };

_ReviewKey _$ReviewKeyFromJson(Map<String, dynamic> json) =>
    _ReviewKey(a: json['a'] as String, e: json['e'] as String?);

Map<String, dynamic> _$ReviewKeyToJson(_ReviewKey instance) =>
    <String, dynamic>{'a': instance.a, 'e': instance.e};

_ContestReview _$ContestReviewFromJson(Map<String, dynamic> json) =>
    _ContestReview(
      id: json['id'] as String,
      title: json['title'] as String,
      groups:
          (json['groups'] as List<dynamic>?)
              ?.map((e) => PaperGroup.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PaperGroup>[],
      answers:
          (json['answers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      key:
          (json['key'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, ReviewKey.fromJson(e as Map<String, dynamic>)),
          ) ??
          const <String, ReviewKey>{},
    );

Map<String, dynamic> _$ContestReviewToJson(_ContestReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'groups': instance.groups.map((e) => e.toJson()).toList(),
      'answers': instance.answers,
      'key': instance.key.map((k, e) => MapEntry(k, e.toJson())),
    };

_DuelRules _$DuelRulesFromJson(Map<String, dynamic> json) => _DuelRules(
  questions: (json['questions'] as num?)?.toInt() ?? 10,
  secondsPerQuestion: (json['seconds_per_question'] as num?)?.toInt() ?? 20,
  maxSeconds: (json['max_seconds'] as num?)?.toInt() ?? 240,
  freePerDay: (json['free_per_day'] as num?)?.toInt() ?? 3,
);

Map<String, dynamic> _$DuelRulesToJson(_DuelRules instance) =>
    <String, dynamic>{
      'questions': instance.questions,
      'seconds_per_question': instance.secondsPerQuestion,
      'max_seconds': instance.maxSeconds,
      'free_per_day': instance.freePerDay,
    };

_DuelSide _$DuelSideFromJson(Map<String, dynamic> json) => _DuelSide(
  name: json['name'] as String,
  isBot: json['is_bot'] as bool? ?? false,
  answered: (json['answered'] as num?)?.toInt() ?? 0,
  correct: (json['correct'] as num?)?.toInt() ?? 0,
  timeMs: (json['time_ms'] as num?)?.toInt() ?? 0,
  finished: json['finished'] as bool? ?? false,
);

Map<String, dynamic> _$DuelSideToJson(_DuelSide instance) => <String, dynamic>{
  'name': instance.name,
  'is_bot': instance.isBot,
  'answered': instance.answered,
  'correct': instance.correct,
  'time_ms': instance.timeMs,
  'finished': instance.finished,
};

_DuelState _$DuelStateFromJson(Map<String, dynamic> json) => _DuelState(
  id: json['id'] as String,
  status: $enumDecode(
    _$DuelStatusEnumMap,
    json['status'],
    unknownValue: DuelStatus.cancelled,
  ),
  code: json['code'] as String?,
  serverNow: DateTime.parse(json['server_now'] as String),
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  questionCount: (json['question_count'] as num).toInt(),
  rules: json['rules'] == null
      ? const DuelRules()
      : DuelRules.fromJson(json['rules'] as Map<String, dynamic>),
  me: DuelSide.fromJson(json['me'] as Map<String, dynamic>),
  opponent: json['opponent'] == null
      ? null
      : DuelSide.fromJson(json['opponent'] as Map<String, dynamic>),
  winner: json['winner'] as String?,
);

Map<String, dynamic> _$DuelStateToJson(_DuelState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$DuelStatusEnumMap[instance.status]!,
      'code': instance.code,
      'server_now': instance.serverNow.toIso8601String(),
      'started_at': instance.startedAt?.toIso8601String(),
      'question_count': instance.questionCount,
      'rules': instance.rules.toJson(),
      'me': instance.me.toJson(),
      'opponent': instance.opponent?.toJson(),
      'winner': instance.winner,
    };

const _$DuelStatusEnumMap = {
  DuelStatus.waiting: 'waiting',
  DuelStatus.active: 'active',
  DuelStatus.finished: 'finished',
  DuelStatus.cancelled: 'cancelled',
};

_DuelQuestion _$DuelQuestionFromJson(Map<String, dynamic> json) =>
    _DuelQuestion(
      n: (json['n'] as num).toInt(),
      content: json['content'] as String,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$DuelQuestionToJson(_DuelQuestion instance) =>
    <String, dynamic>{
      'n': instance.n,
      'content': instance.content,
      'options': instance.options,
    };

_DuelAnswerResult _$DuelAnswerResultFromJson(Map<String, dynamic> json) =>
    _DuelAnswerResult(
      ok: json['ok'] as bool,
      answer: json['answer'] as String,
      explanation: json['explanation'] as String?,
    );

Map<String, dynamic> _$DuelAnswerResultToJson(_DuelAnswerResult instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'answer': instance.answer,
      'explanation': instance.explanation,
    };

_DuelStats _$DuelStatsFromJson(Map<String, dynamic> json) => _DuelStats(
  wins: (json['wins'] as num?)?.toInt() ?? 0,
  losses: (json['losses'] as num?)?.toInt() ?? 0,
  draws: (json['draws'] as num?)?.toInt() ?? 0,
  playedToday: (json['played_today'] as num?)?.toInt() ?? 0,
  leftToday: (json['left_today'] as num?)?.toInt(),
);

Map<String, dynamic> _$DuelStatsToJson(_DuelStats instance) =>
    <String, dynamic>{
      'wins': instance.wins,
      'losses': instance.losses,
      'draws': instance.draws,
      'played_today': instance.playedToday,
      'left_today': instance.leftToday,
    };

_DuelRef _$DuelRefFromJson(Map<String, dynamic> json) =>
    _DuelRef(id: json['id'] as String, code: json['code'] as String?);

Map<String, dynamic> _$DuelRefToJson(_DuelRef instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
};
