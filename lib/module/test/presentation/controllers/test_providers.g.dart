// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(testList)
final testListProvider = TestListProvider._();

final class TestListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TestSummary>>,
          List<TestSummary>,
          FutureOr<List<TestSummary>>
        >
    with $FutureModifier<List<TestSummary>>, $FutureProvider<List<TestSummary>> {
  TestListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'testListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$testListHash();

  @$internal
  @override
  $FutureProviderElement<List<TestSummary>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<TestSummary>> create(Ref ref) {
    return testList(ref);
  }
}

String _$testListHash() => r'0fb64188cd5ce7abaa7fca05ec672a7e7b52e5e2';

@ProviderFor(testDetail)
final testDetailProvider = TestDetailFamily._();

final class TestDetailProvider
    extends $FunctionalProvider<AsyncValue<TestDetail>, TestDetail, FutureOr<TestDetail>>
    with $FutureModifier<TestDetail>, $FutureProvider<TestDetail> {
  TestDetailProvider._({required TestDetailFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'testDetailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$testDetailHash();

  @override
  String toString() {
    return r'testDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TestDetail> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TestDetail> create(Ref ref) {
    final argument = this.argument as String;
    return testDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TestDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$testDetailHash() => r'a6c2f9f1994700ce29236840701b00df13487b6f';

final class TestDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TestDetail>, String> {
  TestDetailFamily._()
    : super(
        retry: null,
        name: r'testDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TestDetailProvider call(String testId) => TestDetailProvider._(argument: testId, from: this);

  @override
  String toString() => r'testDetailProvider';
}

@ProviderFor(attemptResult)
final attemptResultProvider = AttemptResultFamily._();

final class AttemptResultProvider
    extends $FunctionalProvider<AsyncValue<AttemptResult>, AttemptResult, FutureOr<AttemptResult>>
    with $FutureModifier<AttemptResult>, $FutureProvider<AttemptResult> {
  AttemptResultProvider._({required AttemptResultFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'attemptResultProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attemptResultHash();

  @override
  String toString() {
    return r'attemptResultProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AttemptResult> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AttemptResult> create(Ref ref) {
    final argument = this.argument as String;
    return attemptResult(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AttemptResultProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$attemptResultHash() => r'014e3c96dbb33ed9a6aac7fbbdc86b9a8d2a88cd';

final class AttemptResultFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AttemptResult>, String> {
  AttemptResultFamily._()
    : super(
        retry: null,
        name: r'attemptResultProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AttemptResultProvider call(String attemptId) =>
      AttemptResultProvider._(argument: attemptId, from: this);

  @override
  String toString() => r'attemptResultProvider';
}

@ProviderFor(partStats)
final partStatsProvider = PartStatsProvider._();

final class PartStatsProvider
    extends
        $FunctionalProvider<AsyncValue<List<PartStat>>, List<PartStat>, FutureOr<List<PartStat>>>
    with $FutureModifier<List<PartStat>>, $FutureProvider<List<PartStat>> {
  PartStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partStatsHash();

  @$internal
  @override
  $FutureProviderElement<List<PartStat>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<PartStat>> create(Ref ref) {
    return partStats(ref);
  }
}

String _$partStatsHash() => r'8149b12759ce9a6dd910f8d0745e6dfd48774986';

/// Lịch sử làm bài.

@ProviderFor(Attempts)
final attemptsProvider = AttemptsProvider._();

/// Lịch sử làm bài.
final class AttemptsProvider extends $AsyncNotifierProvider<Attempts, List<Attempt>> {
  /// Lịch sử làm bài.
  AttemptsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attemptsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attemptsHash();

  @$internal
  @override
  Attempts create() => Attempts();
}

String _$attemptsHash() => r'81ec879cc118eff991fcca9c00ffe3548ff889bd';

/// Lịch sử làm bài.

abstract class _$Attempts extends $AsyncNotifier<List<Attempt>> {
  FutureOr<List<Attempt>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Attempt>>, List<Attempt>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Attempt>>, List<Attempt>>,
              AsyncValue<List<Attempt>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
