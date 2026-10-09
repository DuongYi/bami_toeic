// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// keepAlive: rời trang chi tiết đề vẫn giữ tiến độ tải.

@ProviderFor(OfflineTest)
final offlineTestProvider = OfflineTestFamily._();

/// keepAlive: rời trang chi tiết đề vẫn giữ tiến độ tải.
final class OfflineTestProvider extends $AsyncNotifierProvider<OfflineTest, OfflineState> {
  /// keepAlive: rời trang chi tiết đề vẫn giữ tiến độ tải.
  OfflineTestProvider._({required OfflineTestFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'offlineTestProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineTestHash();

  @override
  String toString() {
    return r'offlineTestProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OfflineTest create() => OfflineTest();

  @override
  bool operator ==(Object other) {
    return other is OfflineTestProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$offlineTestHash() => r'2fc311b9e15d10e7e13b8a447b15e22efc6e17e6';

/// keepAlive: rời trang chi tiết đề vẫn giữ tiến độ tải.

final class OfflineTestFamily extends $Family
    with
        $ClassFamilyOverride<
          OfflineTest,
          AsyncValue<OfflineState>,
          OfflineState,
          FutureOr<OfflineState>,
          String
        > {
  OfflineTestFamily._()
    : super(
        retry: null,
        name: r'offlineTestProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// keepAlive: rời trang chi tiết đề vẫn giữ tiến độ tải.

  OfflineTestProvider call(String testId) => OfflineTestProvider._(argument: testId, from: this);

  @override
  String toString() => r'offlineTestProvider';
}

/// keepAlive: rời trang chi tiết đề vẫn giữ tiến độ tải.

abstract class _$OfflineTest extends $AsyncNotifier<OfflineState> {
  late final _$args = ref.$arg as String;
  String get testId => _$args;

  FutureOr<OfflineState> build(String testId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<OfflineState>, OfflineState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<OfflineState>, OfflineState>,
              AsyncValue<OfflineState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
