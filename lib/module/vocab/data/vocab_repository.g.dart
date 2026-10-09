// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocab_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vocabApi)
final vocabApiProvider = VocabApiProvider._();

final class VocabApiProvider extends $FunctionalProvider<VocabApi, VocabApi, VocabApi>
    with $Provider<VocabApi> {
  VocabApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vocabApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vocabApiHash();

  @$internal
  @override
  $ProviderElement<VocabApi> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  VocabApi create(Ref ref) {
    return vocabApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VocabApi value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<VocabApi>(value));
  }
}

String _$vocabApiHash() => r'9b6b40bb987c8912230123cfba279c2420e48ec0';

@ProviderFor(vocabRepository)
final vocabRepositoryProvider = VocabRepositoryProvider._();

final class VocabRepositoryProvider
    extends $FunctionalProvider<VocabRepository, VocabRepository, VocabRepository>
    with $Provider<VocabRepository> {
  VocabRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vocabRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vocabRepositoryHash();

  @$internal
  @override
  $ProviderElement<VocabRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VocabRepository create(Ref ref) {
    return vocabRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VocabRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VocabRepository>(value),
    );
  }
}

String _$vocabRepositoryHash() => r'0d4a4350b0383516db56985d95a396e2d50d2f55';
