// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(leaderboardApi)
final leaderboardApiProvider = LeaderboardApiProvider._();

final class LeaderboardApiProvider
    extends $FunctionalProvider<LeaderboardApi, LeaderboardApi, LeaderboardApi>
    with $Provider<LeaderboardApi> {
  LeaderboardApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaderboardApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaderboardApiHash();

  @$internal
  @override
  $ProviderElement<LeaderboardApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LeaderboardApi create(Ref ref) {
    return leaderboardApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeaderboardApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeaderboardApi>(value),
    );
  }
}

String _$leaderboardApiHash() => r'ba68520adaed628b87dd1ca532fcee0c75bd4b90';

@ProviderFor(leaderboardRepository)
final leaderboardRepositoryProvider = LeaderboardRepositoryProvider._();

final class LeaderboardRepositoryProvider
    extends $FunctionalProvider<LeaderboardRepository, LeaderboardRepository, LeaderboardRepository>
    with $Provider<LeaderboardRepository> {
  LeaderboardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaderboardRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaderboardRepositoryHash();

  @$internal
  @override
  $ProviderElement<LeaderboardRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LeaderboardRepository create(Ref ref) {
    return leaderboardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeaderboardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeaderboardRepository>(value),
    );
  }
}

String _$leaderboardRepositoryHash() => r'd6f5a07311bae5b38a8e5c03084100e9045d8591';
