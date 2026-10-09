// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DayLog _$DayLogFromJson(Map<String, dynamic> json) => _DayLog(
  questions: (json['questions'] as num?)?.toInt() ?? 0,
  mistakes: (json['mistakes'] as num?)?.toInt() ?? 0,
  words: (json['words'] as num?)?.toInt() ?? 0,
  dictations: (json['dictations'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DayLogToJson(_DayLog instance) => <String, dynamic>{
  'questions': instance.questions,
  'mistakes': instance.mistakes,
  'words': instance.words,
  'dictations': instance.dictations,
};

_GoalSettings _$GoalSettingsFromJson(Map<String, dynamic> json) => _GoalSettings(
  targetScore: (json['target_score'] as num?)?.toInt(),
  examDate: json['exam_date'] == null ? null : DateTime.parse(json['exam_date'] as String),
  dailyQuestions: (json['daily_questions'] as num?)?.toInt() ?? 20,
  dailyWords: (json['daily_words'] as num?)?.toInt() ?? 15,
  dailyDictations: (json['daily_dictations'] as num?)?.toInt() ?? 3,
  reminderMinutes: (json['reminder_minutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$GoalSettingsToJson(_GoalSettings instance) => <String, dynamic>{
  'target_score': instance.targetScore,
  'exam_date': instance.examDate?.toIso8601String(),
  'daily_questions': instance.dailyQuestions,
  'daily_words': instance.dailyWords,
  'daily_dictations': instance.dailyDictations,
  'reminder_minutes': instance.reminderMinutes,
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(studyStore)
final studyStoreProvider = StudyStoreProvider._();

final class StudyStoreProvider extends $FunctionalProvider<StudyStore, StudyStore, StudyStore>
    with $Provider<StudyStore> {
  StudyStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studyStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studyStoreHash();

  @$internal
  @override
  $ProviderElement<StudyStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StudyStore create(Ref ref) {
    return studyStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StudyStore value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<StudyStore>(value));
  }
}

String _$studyStoreHash() => r'dd7e292305a5a39e9942499a5e02943c1d898b89';

@ProviderFor(studyLog)
final studyLogProvider = StudyLogProvider._();

final class StudyLogProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, DayLog>>,
          Map<String, DayLog>,
          FutureOr<Map<String, DayLog>>
        >
    with $FutureModifier<Map<String, DayLog>>, $FutureProvider<Map<String, DayLog>> {
  StudyLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studyLogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studyLogHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, DayLog>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, DayLog>> create(Ref ref) {
    return studyLog(ref);
  }
}

String _$studyLogHash() => r'8efb88ca70c5d0955a970b93725790260b0d66a9';

@ProviderFor(goalSettings)
final goalSettingsProvider = GoalSettingsProvider._();

final class GoalSettingsProvider
    extends $FunctionalProvider<AsyncValue<GoalSettings>, GoalSettings, FutureOr<GoalSettings>>
    with $FutureModifier<GoalSettings>, $FutureProvider<GoalSettings> {
  GoalSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalSettingsHash();

  @$internal
  @override
  $FutureProviderElement<GoalSettings> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<GoalSettings> create(Ref ref) {
    return goalSettings(ref);
  }
}

String _$goalSettingsHash() => r'5224cf7d58d68de53689e832c4a310cab312a94d';
