// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duel_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(duelStats)
final duelStatsProvider = DuelStatsProvider._();

final class DuelStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<DuelStats>,
          DuelStats,
          FutureOr<DuelStats>
        >
    with $FutureModifier<DuelStats>, $FutureProvider<DuelStats> {
  DuelStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'duelStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$duelStatsHash();

  @$internal
  @override
  $FutureProviderElement<DuelStats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<DuelStats> create(Ref ref) {
    return duelStats(ref);
  }
}

String _$duelStatsHash() => r'3a4ad6f236f5f271542d751b3b7edb6b55753f01';

/// 1 trận đấu: hỏi trạng thái 1,5 giây/lần (tiến độ đối thủ), làm từng câu có giới hạn giờ.

@ProviderFor(DuelMatch)
final duelMatchProvider = DuelMatchFamily._();

/// 1 trận đấu: hỏi trạng thái 1,5 giây/lần (tiến độ đối thủ), làm từng câu có giới hạn giờ.
final class DuelMatchProvider
    extends $AsyncNotifierProvider<DuelMatch, DuelPlay> {
  /// 1 trận đấu: hỏi trạng thái 1,5 giây/lần (tiến độ đối thủ), làm từng câu có giới hạn giờ.
  DuelMatchProvider._({
    required DuelMatchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'duelMatchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$duelMatchHash();

  @override
  String toString() {
    return r'duelMatchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DuelMatch create() => DuelMatch();

  @override
  bool operator ==(Object other) {
    return other is DuelMatchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$duelMatchHash() => r'af473444c38cb8b3ffe7eaedebc81a8eabcd5f50';

/// 1 trận đấu: hỏi trạng thái 1,5 giây/lần (tiến độ đối thủ), làm từng câu có giới hạn giờ.

final class DuelMatchFamily extends $Family
    with
        $ClassFamilyOverride<
          DuelMatch,
          AsyncValue<DuelPlay>,
          DuelPlay,
          FutureOr<DuelPlay>,
          String
        > {
  DuelMatchFamily._()
    : super(
        retry: null,
        name: r'duelMatchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 1 trận đấu: hỏi trạng thái 1,5 giây/lần (tiến độ đối thủ), làm từng câu có giới hạn giờ.

  DuelMatchProvider call(String duelId) =>
      DuelMatchProvider._(argument: duelId, from: this);

  @override
  String toString() => r'duelMatchProvider';
}

/// 1 trận đấu: hỏi trạng thái 1,5 giây/lần (tiến độ đối thủ), làm từng câu có giới hạn giờ.

abstract class _$DuelMatch extends $AsyncNotifier<DuelPlay> {
  late final _$args = ref.$arg as String;
  String get duelId => _$args;

  FutureOr<DuelPlay> build(String duelId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DuelPlay>, DuelPlay>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DuelPlay>, DuelPlay>,
              AsyncValue<DuelPlay>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
