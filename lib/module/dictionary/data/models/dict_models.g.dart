// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dict_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$DictSuggestQueryToJson(DictSuggestQuery instance) =>
    <String, dynamic>{'p_query': instance.query, 'p_limit': instance.limit};

Map<String, dynamic> _$DictLookupQueryToJson(DictLookupQuery instance) =>
    <String, dynamic>{'p_words': instance.words};

_DictSense _$DictSenseFromJson(Map<String, dynamic> json) => _DictSense(
  pos: json['p'] as String?,
  meaning: json['m'] as String,
  example: json['e'] as String?,
);

Map<String, dynamic> _$DictSenseToJson(_DictSense instance) =>
    <String, dynamic>{
      'p': instance.pos,
      'm': instance.meaning,
      'e': instance.example,
    };

_DictEntry _$DictEntryFromJson(Map<String, dynamic> json) => _DictEntry(
  wordKey: json['word_key'] as String,
  word: json['word'] as String,
  ipa: json['ipa'] as String?,
  senses:
      (json['senses'] as List<dynamic>?)
          ?.map((e) => DictSense.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DictSense>[],
);

Map<String, dynamic> _$DictEntryToJson(_DictEntry instance) =>
    <String, dynamic>{
      'word_key': instance.wordKey,
      'word': instance.word,
      'ipa': instance.ipa,
      'senses': instance.senses.map((e) => e.toJson()).toList(),
    };

_DictSuggestion _$DictSuggestionFromJson(Map<String, dynamic> json) =>
    _DictSuggestion(
      word: json['word'] as String,
      ipa: json['ipa'] as String?,
      meaning: json['meaning'] as String?,
      fuzzy: json['fuzzy'] as bool? ?? false,
    );

Map<String, dynamic> _$DictSuggestionToJson(_DictSuggestion instance) =>
    <String, dynamic>{
      'word': instance.word,
      'ipa': instance.ipa,
      'meaning': instance.meaning,
      'fuzzy': instance.fuzzy,
    };

_EnEntry _$EnEntryFromJson(Map<String, dynamic> json) => _EnEntry(
  word: json['word'] as String,
  phonetic: json['phonetic'] as String?,
  phonetics:
      (json['phonetics'] as List<dynamic>?)
          ?.map((e) => EnPhonetic.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <EnPhonetic>[],
  meanings:
      (json['meanings'] as List<dynamic>?)
          ?.map((e) => EnMeaning.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <EnMeaning>[],
);

Map<String, dynamic> _$EnEntryToJson(_EnEntry instance) => <String, dynamic>{
  'word': instance.word,
  'phonetic': instance.phonetic,
  'phonetics': instance.phonetics.map((e) => e.toJson()).toList(),
  'meanings': instance.meanings.map((e) => e.toJson()).toList(),
};

_EnPhonetic _$EnPhoneticFromJson(Map<String, dynamic> json) =>
    _EnPhonetic(text: json['text'] as String?, audio: json['audio'] as String?);

Map<String, dynamic> _$EnPhoneticToJson(_EnPhonetic instance) =>
    <String, dynamic>{'text': instance.text, 'audio': instance.audio};

_EnMeaning _$EnMeaningFromJson(Map<String, dynamic> json) => _EnMeaning(
  partOfSpeech: json['partOfSpeech'] as String,
  definitions:
      (json['definitions'] as List<dynamic>?)
          ?.map((e) => EnDefinition.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <EnDefinition>[],
  synonyms:
      (json['synonyms'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  antonyms:
      (json['antonyms'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$EnMeaningToJson(_EnMeaning instance) =>
    <String, dynamic>{
      'partOfSpeech': instance.partOfSpeech,
      'definitions': instance.definitions.map((e) => e.toJson()).toList(),
      'synonyms': instance.synonyms,
      'antonyms': instance.antonyms,
    };

_EnDefinition _$EnDefinitionFromJson(Map<String, dynamic> json) =>
    _EnDefinition(
      definition: json['definition'] as String,
      example: json['example'] as String?,
      synonyms:
          (json['synonyms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$EnDefinitionToJson(_EnDefinition instance) =>
    <String, dynamic>{
      'definition': instance.definition,
      'example': instance.example,
      'synonyms': instance.synonyms,
    };
