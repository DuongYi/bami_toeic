// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arena_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(arenaApi)
final arenaApiProvider = ArenaApiProvider._();

final class ArenaApiProvider
    extends $FunctionalProvider<ArenaApi, ArenaApi, ArenaApi>
    with $Provider<ArenaApi> {
  ArenaApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'arenaApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$arenaApiHash();

  @$internal
  @override
  $ProviderElement<ArenaApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ArenaApi create(Ref ref) {
    return arenaApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ArenaApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ArenaApi>(value),
    );
  }
}

String _$arenaApiHash() => r'1adee3a0276e603c2cd4a8db9d856b635dc3e78c';

@ProviderFor(arenaRepository)
final arenaRepositoryProvider = ArenaRepositoryProvider._();

final class ArenaRepositoryProvider
    extends
        $FunctionalProvider<ArenaRepository, ArenaRepository, ArenaRepository>
    with $Provider<ArenaRepository> {
  ArenaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'arenaRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$arenaRepositoryHash();

  @$internal
  @override
  $ProviderElement<ArenaRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ArenaRepository create(Ref ref) {
    return arenaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ArenaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ArenaRepository>(value),
    );
  }
}

String _$arenaRepositoryHash() => r'ad2b68060b5a809078d878bd972e016a73ad38a2';
