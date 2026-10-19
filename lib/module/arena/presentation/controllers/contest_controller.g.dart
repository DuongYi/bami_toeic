// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contestOverview)
final contestOverviewProvider = ContestOverviewProvider._();

final class ContestOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<ContestOverview>,
          ContestOverview,
          FutureOr<ContestOverview>
        >
    with $FutureModifier<ContestOverview>, $FutureProvider<ContestOverview> {
  ContestOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contestOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contestOverviewHash();

  @$internal
  @override
  $FutureProviderElement<ContestOverview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ContestOverview> create(Ref ref) {
    return contestOverview(ref);
  }
}

String _$contestOverviewHash() => r'f2338db2d1e86f7102e94b21f4d4d7dee1d3f153';

@ProviderFor(contestBoard)
final contestBoardProvider = ContestBoardFamily._();

final class ContestBoardProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ContestRank>>,
          List<ContestRank>,
          FutureOr<List<ContestRank>>
        >
    with
        $FutureModifier<List<ContestRank>>,
        $FutureProvider<List<ContestRank>> {
  ContestBoardProvider._({
    required ContestBoardFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'contestBoardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contestBoardHash();

  @override
  String toString() {
    return r'contestBoardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ContestRank>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ContestRank>> create(Ref ref) {
    final argument = this.argument as String;
    return contestBoard(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ContestBoardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contestBoardHash() => r'33e45f5b32568ab7c5d7470271d4a2b01e0ad8e1';

final class ContestBoardFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ContestRank>>, String> {
  ContestBoardFamily._()
    : super(
        retry: null,
        name: r'contestBoardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ContestBoardProvider call(String contestId) =>
      ContestBoardProvider._(argument: contestId, from: this);

  @override
  String toString() => r'contestBoardProvider';
}

@ProviderFor(contestReview)
final contestReviewProvider = ContestReviewFamily._();

final class ContestReviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<ContestReview>,
          ContestReview,
          FutureOr<ContestReview>
        >
    with $FutureModifier<ContestReview>, $FutureProvider<ContestReview> {
  ContestReviewProvider._({
    required ContestReviewFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'contestReviewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contestReviewHash();

  @override
  String toString() {
    return r'contestReviewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ContestReview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ContestReview> create(Ref ref) {
    final argument = this.argument as String;
    return contestReview(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ContestReviewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contestReviewHash() => r'a793af0d62ffac4b29411ce1aab959c6737caf44';

final class ContestReviewFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ContestReview>, String> {
  ContestReviewFamily._()
    : super(
        retry: null,
        name: r'contestReviewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ContestReviewProvider call(String contestId) =>
      ContestReviewProvider._(argument: contestId, from: this);

  @override
  String toString() => r'contestReviewProvider';
}

/// Một lượt thi Chủ nhật: đề phát từ server (không đáp án), lưu nháp, tự nộp khi hết giờ.

@ProviderFor(ContestTaking)
final contestTakingProvider = ContestTakingFamily._();

/// Một lượt thi Chủ nhật: đề phát từ server (không đáp án), lưu nháp, tự nộp khi hết giờ.
final class ContestTakingProvider
    extends $AsyncNotifierProvider<ContestTaking, ContestSession> {
  /// Một lượt thi Chủ nhật: đề phát từ server (không đáp án), lưu nháp, tự nộp khi hết giờ.
  ContestTakingProvider._({
    required ContestTakingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'contestTakingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contestTakingHash();

  @override
  String toString() {
    return r'contestTakingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ContestTaking create() => ContestTaking();

  @override
  bool operator ==(Object other) {
    return other is ContestTakingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contestTakingHash() => r'8c86fd46f6a0f840e2b0b61fc7650f8d38611396';

/// Một lượt thi Chủ nhật: đề phát từ server (không đáp án), lưu nháp, tự nộp khi hết giờ.

final class ContestTakingFamily extends $Family
    with
        $ClassFamilyOverride<
          ContestTaking,
          AsyncValue<ContestSession>,
          ContestSession,
          FutureOr<ContestSession>,
          String
        > {
  ContestTakingFamily._()
    : super(
        retry: null,
        name: r'contestTakingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Một lượt thi Chủ nhật: đề phát từ server (không đáp án), lưu nháp, tự nộp khi hết giờ.

  ContestTakingProvider call(String contestId) =>
      ContestTakingProvider._(argument: contestId, from: this);

  @override
  String toString() => r'contestTakingProvider';
}

/// Một lượt thi Chủ nhật: đề phát từ server (không đáp án), lưu nháp, tự nộp khi hết giờ.

abstract class _$ContestTaking extends $AsyncNotifier<ContestSession> {
  late final _$args = ref.$arg as String;
  String get contestId => _$args;

  FutureOr<ContestSession> build(String contestId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ContestSession>, ContestSession>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ContestSession>, ContestSession>,
              AsyncValue<ContestSession>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
