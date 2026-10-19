// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tts_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Phát âm tiếng Anh bằng giọng đọc có sẵn của máy (không cần file audio).

@ProviderFor(ttsService)
final ttsServiceProvider = TtsServiceProvider._();

/// Phát âm tiếng Anh bằng giọng đọc có sẵn của máy (không cần file audio).

final class TtsServiceProvider
    extends $FunctionalProvider<TtsService, TtsService, TtsService>
    with $Provider<TtsService> {
  /// Phát âm tiếng Anh bằng giọng đọc có sẵn của máy (không cần file audio).
  TtsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ttsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ttsServiceHash();

  @$internal
  @override
  $ProviderElement<TtsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TtsService create(Ref ref) {
    return ttsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TtsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TtsService>(value),
    );
  }
}

String _$ttsServiceHash() => r'd668ad24d248c57f5a7223f24922f1535a772849';
