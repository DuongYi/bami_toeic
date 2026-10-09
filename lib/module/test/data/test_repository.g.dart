// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(testApi)
final testApiProvider = TestApiProvider._();

final class TestApiProvider
    extends $FunctionalProvider<TestApi, TestApi, TestApi>
    with $Provider<TestApi> {
  TestApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'testApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$testApiHash();

  @$internal
  @override
  $ProviderElement<TestApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TestApi create(Ref ref) {
    return testApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TestApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TestApi>(value),
    );
  }
}

String _$testApiHash() => r'5716c8589c47750074df72be52a512b6d7b5f9cc';

@ProviderFor(testRepository)
final testRepositoryProvider = TestRepositoryProvider._();

final class TestRepositoryProvider
    extends $FunctionalProvider<TestRepository, TestRepository, TestRepository>
    with $Provider<TestRepository> {
  TestRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'testRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$testRepositoryHash();

  @$internal
  @override
  $ProviderElement<TestRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TestRepository create(Ref ref) {
    return testRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TestRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TestRepository>(value),
    );
  }
}

String _$testRepositoryHash() => r'f8025326ac4db5e9eb59c69a86580383c8c1ec5f';
