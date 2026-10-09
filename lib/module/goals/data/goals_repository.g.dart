// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(goalsApi)
final goalsApiProvider = GoalsApiProvider._();

final class GoalsApiProvider
    extends $FunctionalProvider<GoalsApi, GoalsApi, GoalsApi>
    with $Provider<GoalsApi> {
  GoalsApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalsApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalsApiHash();

  @$internal
  @override
  $ProviderElement<GoalsApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoalsApi create(Ref ref) {
    return goalsApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoalsApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoalsApi>(value),
    );
  }
}

String _$goalsApiHash() => r'71af8b9cc86837641e4aec05a8cdf7c04c9e6059';

@ProviderFor(goalsRepository)
final goalsRepositoryProvider = GoalsRepositoryProvider._();

final class GoalsRepositoryProvider
    extends
        $FunctionalProvider<GoalsRepository, GoalsRepository, GoalsRepository>
    with $Provider<GoalsRepository> {
  GoalsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalsRepositoryHash();

  @$internal
  @override
  $ProviderElement<GoalsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoalsRepository create(Ref ref) {
    return goalsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoalsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoalsRepository>(value),
    );
  }
}

String _$goalsRepositoryHash() => r'3a71dbd1c677a1f546a64d0f4df75dbcb0d958ce';
