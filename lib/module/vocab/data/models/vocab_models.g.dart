// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocab_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$VocabInputToJson(VocabInput instance) => <String, dynamic>{
  'word': instance.word,
  'ipa': instance.ipa,
  'pos': instance.pos,
  'meaning': instance.meaning,
  'example': instance.example,
  'example_meaning': instance.exampleMeaning,
  'topic': instance.topic,
};

Map<String, dynamic> _$VocabReviewUpsertToJson(VocabReviewUpsert instance) => <String, dynamic>{
  'user_id': instance.userId,
  'vocab_id': instance.vocabId,
  'ease': instance.ease,
  'interval_days': instance.intervalDays,
  'repetitions': instance.repetitions,
  'due_at': instance.dueAt.toIso8601String(),
  'last_reviewed_at': instance.lastReviewedAt.toIso8601String(),
};

_VocabReview _$VocabReviewFromJson(Map<String, dynamic> json) => _VocabReview(
  ease: (json['ease'] as num).toDouble(),
  intervalDays: (json['interval_days'] as num).toInt(),
  repetitions: (json['repetitions'] as num).toInt(),
  dueAt: DateTime.parse(json['due_at'] as String),
);

Map<String, dynamic> _$VocabReviewToJson(_VocabReview instance) => <String, dynamic>{
  'ease': instance.ease,
  'interval_days': instance.intervalDays,
  'repetitions': instance.repetitions,
  'due_at': instance.dueAt.toIso8601String(),
};

_VocabItem _$VocabItemFromJson(Map<String, dynamic> json) => _VocabItem(
  id: json['id'] as String,
  word: json['word'] as String,
  ipa: json['ipa'] as String?,
  pos: json['pos'] as String?,
  meaning: json['meaning'] as String,
  example: json['example'] as String?,
  exampleMeaning: json['example_meaning'] as String?,
  topic: json['topic'] as String,
  audioUrl: json['audio_url'] as String?,
  userId: json['user_id'] as String?,
  reviews:
      (json['vocab_reviews'] as List<dynamic>?)
          ?.map((e) => VocabReview.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <VocabReview>[],
);

Map<String, dynamic> _$VocabItemToJson(_VocabItem instance) => <String, dynamic>{
  'id': instance.id,
  'word': instance.word,
  'ipa': instance.ipa,
  'pos': instance.pos,
  'meaning': instance.meaning,
  'example': instance.example,
  'example_meaning': instance.exampleMeaning,
  'topic': instance.topic,
  'audio_url': instance.audioUrl,
  'user_id': instance.userId,
};
