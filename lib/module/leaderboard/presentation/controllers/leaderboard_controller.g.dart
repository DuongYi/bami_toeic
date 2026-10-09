// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(leaderboard)
final leaderboardProvider = LeaderboardFamily._();

final class LeaderboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LeaderboardEntry>>,
          List<LeaderboardEntry>,
          FutureOr<List<LeaderboardEntry>>
        >
    with
        $FutureModifier<List<LeaderboardEntry>>,
        $FutureProvider<List<LeaderboardEntry>> {
  LeaderboardProvider._({
    required LeaderboardFamily super.from,
    required LeaderboardBoard super.argument,
  }) : super(
         retry: null,
         name: r'leaderboardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$leaderboardHash();

  @override
  String toString() {
    return r'leaderboardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<LeaderboardEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LeaderboardEntry>> create(Ref ref) {
    final argument = this.argument as LeaderboardBoard;
    return leaderboard(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LeaderboardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$leaderboardHash() => r'310f18103dc0f7d118475f38c319466dee287a98';

final class LeaderboardFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<LeaderboardEntry>>,
          LeaderboardBoard
        > {
  LeaderboardFamily._()
    : super(
        retry: null,
        name: r'leaderboardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LeaderboardProvider call(LeaderboardBoard board) =>
      LeaderboardProvider._(argument: board, from: this);

  @override
  String toString() => r'leaderboardProvider';
}

/// Tên hiển thị + tuỳ chọn ẩn khỏi bảng của user hiện tại.

@ProviderFor(MyLeaderboardProfile)
final myLeaderboardProfileProvider = MyLeaderboardProfileProvider._();

/// Tên hiển thị + tuỳ chọn ẩn khỏi bảng của user hiện tại.
final class MyLeaderboardProfileProvider
    extends $AsyncNotifierProvider<MyLeaderboardProfile, LeaderboardProfile> {
  /// Tên hiển thị + tuỳ chọn ẩn khỏi bảng của user hiện tại.
  MyLeaderboardProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myLeaderboardProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myLeaderboardProfileHash();

  @$internal
  @override
  MyLeaderboardProfile create() => MyLeaderboardProfile();
}

String _$myLeaderboardProfileHash() =>
    r'88f1d90029ebcc170269d93334edcc13190b902f';

/// Tên hiển thị + tuỳ chọn ẩn khỏi bảng của user hiện tại.

abstract class _$MyLeaderboardProfile
    extends $AsyncNotifier<LeaderboardProfile> {
  FutureOr<LeaderboardProfile> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<LeaderboardProfile>, LeaderboardProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LeaderboardProfile>, LeaderboardProfile>,
              AsyncValue<LeaderboardProfile>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
