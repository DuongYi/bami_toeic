// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(planApi)
final planApiProvider = PlanApiProvider._();

final class PlanApiProvider
    extends $FunctionalProvider<PlanApi, PlanApi, PlanApi>
    with $Provider<PlanApi> {
  PlanApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planApiHash();

  @$internal
  @override
  $ProviderElement<PlanApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlanApi create(Ref ref) {
    return planApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlanApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlanApi>(value),
    );
  }
}

String _$planApiHash() => r'2998c6a2c4505758c24fa482d2e9c726fbf5ff62';

@ProviderFor(planRepository)
final planRepositoryProvider = PlanRepositoryProvider._();

final class PlanRepositoryProvider
    extends $FunctionalProvider<PlanRepository, PlanRepository, PlanRepository>
    with $Provider<PlanRepository> {
  PlanRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlanRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlanRepository create(Ref ref) {
    return planRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlanRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlanRepository>(value),
    );
  }
}

String _$planRepositoryHash() => r'3e505dc2e98181f4efb42f9983f65b9bd2fc9e17';
