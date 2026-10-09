// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Các đoạn audio có transcript của 1 Part (1–4) trong 1 đề, dùng để chép chính tả.

@ProviderFor(dictationClips)
final dictationClipsProvider = DictationClipsFamily._();

/// Các đoạn audio có transcript của 1 Part (1–4) trong 1 đề, dùng để chép chính tả.

final class DictationClipsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<QuestionGroup>>,
          List<QuestionGroup>,
          FutureOr<List<QuestionGroup>>
        >
    with $FutureModifier<List<QuestionGroup>>, $FutureProvider<List<QuestionGroup>> {
  /// Các đoạn audio có transcript của 1 Part (1–4) trong 1 đề, dùng để chép chính tả.
  DictationClipsProvider._({
    required DictationClipsFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'dictationClipsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dictationClipsHash();

  @override
  String toString() {
    return r'dictationClipsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<QuestionGroup>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<QuestionGroup>> create(Ref ref) {
    final argument = this.argument as (String, int);
    return dictationClips(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is DictationClipsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dictationClipsHash() => r'8b97ed820b462d46167ae2eae8fcdce42fdce9a1';

/// Các đoạn audio có transcript của 1 Part (1–4) trong 1 đề, dùng để chép chính tả.

final class DictationClipsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<QuestionGroup>>, (String, int)> {
  DictationClipsFamily._()
    : super(
        retry: null,
        name: r'dictationClipsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Các đoạn audio có transcript của 1 Part (1–4) trong 1 đề, dùng để chép chính tả.

  DictationClipsProvider call(String testId, int part) =>
      DictationClipsProvider._(argument: (testId, part), from: this);

  @override
  String toString() => r'dictationClipsProvider';
}
