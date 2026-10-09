// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$AttemptInsertToJson(AttemptInsert instance) => <String, dynamic>{
  'test_id': instance.testId,
  'mode': instance.mode,
  'parts': instance.parts,
  'started_at': instance.startedAt.toIso8601String(),
  'total_questions': instance.totalQuestions,
  'listening_correct': instance.listeningCorrect,
  'reading_correct': instance.readingCorrect,
  'source': instance.source,
};

Map<String, dynamic> _$AttemptAnswerInsertToJson(AttemptAnswerInsert instance) => <String, dynamic>{
  'attempt_id': instance.attemptId,
  'question_id': instance.questionId,
  'chosen': instance.chosen,
  'is_correct': instance.isCorrect,
};

Map<String, dynamic> _$InProgressUpsertToJson(InProgressUpsert instance) => <String, dynamic>{
  'test_id': instance.testId,
  'snapshot': instance.snapshot,
  'saved_at': instance.savedAt.toIso8601String(),
};

_TestSummary _$TestSummaryFromJson(Map<String, dynamic> json) => _TestSummary(
  id: json['id'] as String,
  title: json['title'] as String,
  source: json['source'] as String?,
  description: json['description'] as String?,
  questionCount: json['questions'] == null ? 0 : _readCount(json['questions']),
);

Map<String, dynamic> _$TestSummaryToJson(_TestSummary instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'source': instance.source,
  'description': instance.description,
};

_Question _$QuestionFromJson(Map<String, dynamic> json) => _Question(
  id: json['id'] as String,
  part: (json['part'] as num).toInt(),
  number: (json['number'] as num).toInt(),
  content: json['content'] as String?,
  options:
      (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  answer: json['answer'] as String,
  explanation: json['explanation'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
);

Map<String, dynamic> _$QuestionToJson(_Question instance) => <String, dynamic>{
  'id': instance.id,
  'part': instance.part,
  'number': instance.number,
  'content': instance.content,
  'options': instance.options,
  'answer': instance.answer,
  'explanation': instance.explanation,
  'tags': instance.tags,
};

_QuestionGroup _$QuestionGroupFromJson(Map<String, dynamic> json) => _QuestionGroup(
  id: json['id'] as String,
  testId: json['test_id'] as String?,
  part: (json['part'] as num).toInt(),
  orderNo: (json['order_no'] as num).toInt(),
  passage: json['passage'] as String?,
  imageUrl: json['image_url'] as String?,
  audioUrl: json['audio_url'] as String?,
  transcript: json['transcript'] as String?,
  questions:
      (json['questions'] as List<dynamic>?)
          ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Question>[],
);

Map<String, dynamic> _$QuestionGroupToJson(_QuestionGroup instance) => <String, dynamic>{
  'id': instance.id,
  'test_id': instance.testId,
  'part': instance.part,
  'order_no': instance.orderNo,
  'passage': instance.passage,
  'image_url': instance.imageUrl,
  'audio_url': instance.audioUrl,
  'transcript': instance.transcript,
  'questions': instance.questions.map((e) => e.toJson()).toList(),
};

_Attempt _$AttemptFromJson(Map<String, dynamic> json) => _Attempt(
  id: json['id'] as String,
  testId: json['test_id'] as String,
  testTitle: json['tests'] == null ? '' : _readTitle(json['tests']),
  scoreTable: _readScoreTable(json['tests']),
  mode: json['mode'] as String,
  parts: (json['parts'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
  startedAt: DateTime.parse(json['started_at'] as String),
  finishedAt: DateTime.parse(json['finished_at'] as String),
  totalQuestions: (json['total_questions'] as num).toInt(),
  listeningCorrect: (json['listening_correct'] as num).toInt(),
  readingCorrect: (json['reading_correct'] as num).toInt(),
  source: json['source'] as String? ?? 'test',
);

Map<String, dynamic> _$AttemptToJson(_Attempt instance) => <String, dynamic>{
  'id': instance.id,
  'test_id': instance.testId,
  'mode': instance.mode,
  'parts': instance.parts,
  'started_at': instance.startedAt.toIso8601String(),
  'finished_at': instance.finishedAt.toIso8601String(),
  'total_questions': instance.totalQuestions,
  'listening_correct': instance.listeningCorrect,
  'reading_correct': instance.readingCorrect,
  'source': instance.source,
};

_AttemptAnswer _$AttemptAnswerFromJson(Map<String, dynamic> json) =>
    _AttemptAnswer(questionId: json['question_id'] as String, chosen: json['chosen'] as String?);

Map<String, dynamic> _$AttemptAnswerToJson(_AttemptAnswer instance) => <String, dynamic>{
  'question_id': instance.questionId,
  'chosen': instance.chosen,
};

_PartStat _$PartStatFromJson(Map<String, dynamic> json) => _PartStat(
  part: (json['part'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  correct: (json['correct'] as num).toInt(),
);

Map<String, dynamic> _$PartStatToJson(_PartStat instance) => <String, dynamic>{
  'part': instance.part,
  'total': instance.total,
  'correct': instance.correct,
};

_LatestAnswer _$LatestAnswerFromJson(Map<String, dynamic> json) => _LatestAnswer(
  questionId: json['question_id'] as String,
  groupId: json['group_id'] as String,
  testId: json['test_id'] as String,
  part: (json['part'] as num).toInt(),
  number: (json['number'] as num).toInt(),
  chosen: json['chosen'] as String?,
  isCorrect: json['is_correct'] as bool,
  finishedAt: DateTime.parse(json['finished_at'] as String),
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
);

Map<String, dynamic> _$LatestAnswerToJson(_LatestAnswer instance) => <String, dynamic>{
  'question_id': instance.questionId,
  'group_id': instance.groupId,
  'test_id': instance.testId,
  'part': instance.part,
  'number': instance.number,
  'chosen': instance.chosen,
  'is_correct': instance.isCorrect,
  'finished_at': instance.finishedAt.toIso8601String(),
  'tags': instance.tags,
};

_TagStat _$TagStatFromJson(Map<String, dynamic> json) => _TagStat(
  tag: json['tag'] as String,
  total: (json['total'] as num).toInt(),
  correct: (json['correct'] as num).toInt(),
);

Map<String, dynamic> _$TagStatToJson(_TagStat instance) => <String, dynamic>{
  'tag': instance.tag,
  'total': instance.total,
  'correct': instance.correct,
};

_InProgressRow _$InProgressRowFromJson(Map<String, dynamic> json) => _InProgressRow(
  testId: json['test_id'] as String,
  snapshot: json['snapshot'] as Map<String, dynamic>,
  savedAt: DateTime.parse(json['saved_at'] as String),
);

Map<String, dynamic> _$InProgressRowToJson(_InProgressRow instance) => <String, dynamic>{
  'test_id': instance.testId,
  'snapshot': instance.snapshot,
  'saved_at': instance.savedAt.toIso8601String(),
};
