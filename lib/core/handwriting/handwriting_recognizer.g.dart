// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handwriting_recognizer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(handwritingRecognizer)
final handwritingRecognizerProvider = HandwritingRecognizerProvider._();

final class HandwritingRecognizerProvider
    extends
        $FunctionalProvider<
          HandwritingRecognizer,
          HandwritingRecognizer,
          HandwritingRecognizer
        >
    with $Provider<HandwritingRecognizer> {
  HandwritingRecognizerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'handwritingRecognizerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$handwritingRecognizerHash();

  @$internal
  @override
  $ProviderElement<HandwritingRecognizer> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HandwritingRecognizer create(Ref ref) {
    return handwritingRecognizer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HandwritingRecognizer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HandwritingRecognizer>(value),
    );
  }
}

String _$handwritingRecognizerHash() =>
    r'4c0d0ed30a41b4c35a37c70f39d2987b01b620bc';
