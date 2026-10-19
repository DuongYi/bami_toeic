// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_progress.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(studyProgress)
final studyProgressProvider = StudyProgressProvider._();

final class StudyProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<StudyProgress>,
          StudyProgress,
          FutureOr<StudyProgress>
        >
    with $FutureModifier<StudyProgress>, $FutureProvider<StudyProgress> {
  StudyProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studyProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studyProgressHash();

  @$internal
  @override
  $FutureProviderElement<StudyProgress> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StudyProgress> create(Ref ref) {
    return studyProgress(ref);
  }
}

String _$studyProgressHash() => r'de12842879ec88a0677a5ea60e9b8932acad06c6';
