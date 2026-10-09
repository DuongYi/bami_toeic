// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 1 lượt luyện [mode]. [retryIds]: luyện lại đúng các từ đã sai ở lượt trước.

@ProviderFor(PracticeSession)
final practiceSessionProvider = PracticeSessionFamily._();

/// 1 lượt luyện [mode]. [retryIds]: luyện lại đúng các từ đã sai ở lượt trước.
final class PracticeSessionProvider
    extends $AsyncNotifierProvider<PracticeSession, PracticeState> {
  /// 1 lượt luyện [mode]. [retryIds]: luyện lại đúng các từ đã sai ở lượt trước.
  PracticeSessionProvider._({
    required PracticeSessionFamily super.from,
    required (PracticeMode, String) super.argument,
  }) : super(
         retry: null,
         name: r'practiceSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$practiceSessionHash();

  @override
  String toString() {
    return r'practiceSessionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PracticeSession create() => PracticeSession();

  @override
  bool operator ==(Object other) {
    return other is PracticeSessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$practiceSessionHash() => r'e644948913b2e4f992c3077f750ded1471cb5b8d';

/// 1 lượt luyện [mode]. [retryIds]: luyện lại đúng các từ đã sai ở lượt trước.

final class PracticeSessionFamily extends $Family
    with
        $ClassFamilyOverride<
          PracticeSession,
          AsyncValue<PracticeState>,
          PracticeState,
          FutureOr<PracticeState>,
          (PracticeMode, String)
        > {
  PracticeSessionFamily._()
    : super(
        retry: null,
        name: r'practiceSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 1 lượt luyện [mode]. [retryIds]: luyện lại đúng các từ đã sai ở lượt trước.

  PracticeSessionProvider call(PracticeMode mode, String retryIds) =>
      PracticeSessionProvider._(argument: (mode, retryIds), from: this);

  @override
  String toString() => r'practiceSessionProvider';
}

/// 1 lượt luyện [mode]. [retryIds]: luyện lại đúng các từ đã sai ở lượt trước.

abstract class _$PracticeSession extends $AsyncNotifier<PracticeState> {
  late final _$args = ref.$arg as (PracticeMode, String);
  PracticeMode get mode => _$args.$1;
  String get retryIds => _$args.$2;

  FutureOr<PracticeState> build(PracticeMode mode, String retryIds);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PracticeState>, PracticeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PracticeState>, PracticeState>,
              AsyncValue<PracticeState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
