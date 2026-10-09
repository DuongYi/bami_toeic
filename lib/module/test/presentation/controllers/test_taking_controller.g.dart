// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_taking_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Trạng thái một lượt làm bài. [parts] dạng "1,2,5" (hoặc bộ lọc sổ câu sai) để làm khoá family ổn định.

@ProviderFor(TestTaking)
final testTakingProvider = TestTakingFamily._();

/// Trạng thái một lượt làm bài. [parts] dạng "1,2,5" (hoặc bộ lọc sổ câu sai) để làm khoá family ổn định.
final class TestTakingProvider extends $AsyncNotifierProvider<TestTaking, TakingState> {
  /// Trạng thái một lượt làm bài. [parts] dạng "1,2,5" (hoặc bộ lọc sổ câu sai) để làm khoá family ổn định.
  TestTakingProvider._({
    required TestTakingFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'testTakingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$testTakingHash();

  @override
  String toString() {
    return r'testTakingProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TestTaking create() => TestTaking();

  @override
  bool operator ==(Object other) {
    return other is TestTakingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$testTakingHash() => r'126e013e86aafca877219c22b8316c347ae09f2b';

/// Trạng thái một lượt làm bài. [parts] dạng "1,2,5" (hoặc bộ lọc sổ câu sai) để làm khoá family ổn định.

final class TestTakingFamily extends $Family
    with
        $ClassFamilyOverride<
          TestTaking,
          AsyncValue<TakingState>,
          TakingState,
          FutureOr<TakingState>,
          (String, String, String)
        > {
  TestTakingFamily._()
    : super(
        retry: null,
        name: r'testTakingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Trạng thái một lượt làm bài. [parts] dạng "1,2,5" (hoặc bộ lọc sổ câu sai) để làm khoá family ổn định.

  TestTakingProvider call(String testId, String mode, String parts) =>
      TestTakingProvider._(argument: (testId, mode, parts), from: this);

  @override
  String toString() => r'testTakingProvider';
}

/// Trạng thái một lượt làm bài. [parts] dạng "1,2,5" (hoặc bộ lọc sổ câu sai) để làm khoá family ổn định.

abstract class _$TestTaking extends $AsyncNotifier<TakingState> {
  late final _$args = ref.$arg as (String, String, String);
  String get testId => _$args.$1;
  String get mode => _$args.$2;
  String get parts => _$args.$3;

  FutureOr<TakingState> build(String testId, String mode, String parts);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TakingState>, TakingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TakingState>, TakingState>,
              AsyncValue<TakingState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2, _$args.$3));
  }
}
