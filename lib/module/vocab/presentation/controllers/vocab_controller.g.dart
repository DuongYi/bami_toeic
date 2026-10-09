// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocab_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Nguồn ngẫu nhiên để xáo thẻ (override bằng seed cố định trong test).

@ProviderFor(sessionRandom)
final sessionRandomProvider = SessionRandomProvider._();

/// Nguồn ngẫu nhiên để xáo thẻ (override bằng seed cố định trong test).

final class SessionRandomProvider
    extends $FunctionalProvider<Random, Random, Random>
    with $Provider<Random> {
  /// Nguồn ngẫu nhiên để xáo thẻ (override bằng seed cố định trong test).
  SessionRandomProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionRandomProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionRandomHash();

  @$internal
  @override
  $ProviderElement<Random> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Random create(Ref ref) {
    return sessionRandom(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Random value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Random>(value),
    );
  }
}

String _$sessionRandomHash() => r'eede9748a6ed1a185db870d83fcff9b3381d023b';

/// Toàn bộ kho từ + lịch ôn của user. Giữ trong bộ nhớ (hơn 1000 từ) – làm mới khi cần.

@ProviderFor(VocabList)
final vocabListProvider = VocabListProvider._();

/// Toàn bộ kho từ + lịch ôn của user. Giữ trong bộ nhớ (hơn 1000 từ) – làm mới khi cần.
final class VocabListProvider
    extends $AsyncNotifierProvider<VocabList, List<VocabItem>> {
  /// Toàn bộ kho từ + lịch ôn của user. Giữ trong bộ nhớ (hơn 1000 từ) – làm mới khi cần.
  VocabListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vocabListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vocabListHash();

  @$internal
  @override
  VocabList create() => VocabList();
}

String _$vocabListHash() => r'4f195d84853ef21e1eff540defdd4925656cb618';

/// Toàn bộ kho từ + lịch ôn của user. Giữ trong bộ nhớ (hơn 1000 từ) – làm mới khi cần.

abstract class _$VocabList extends $AsyncNotifier<List<VocabItem>> {
  FutureOr<List<VocabItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<VocabItem>>, List<VocabItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<VocabItem>>, List<VocabItem>>,
              AsyncValue<List<VocabItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Bộ từ đang học (lưu trên máy). null = học từ mọi bộ theo thứ tự đề.

@ProviderFor(CurrentDeck)
final currentDeckProvider = CurrentDeckProvider._();

/// Bộ từ đang học (lưu trên máy). null = học từ mọi bộ theo thứ tự đề.
final class CurrentDeckProvider
    extends $AsyncNotifierProvider<CurrentDeck, VocabDeck?> {
  /// Bộ từ đang học (lưu trên máy). null = học từ mọi bộ theo thứ tự đề.
  CurrentDeckProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentDeckProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentDeckHash();

  @$internal
  @override
  CurrentDeck create() => CurrentDeck();
}

String _$currentDeckHash() => r'1bff546dcba5135b26e8100cd4618dec6ce00c39';

/// Bộ từ đang học (lưu trên máy). null = học từ mọi bộ theo thứ tự đề.

abstract class _$CurrentDeck extends $AsyncNotifier<VocabDeck?> {
  FutureOr<VocabDeck?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<VocabDeck?>, VocabDeck?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<VocabDeck?>, VocabDeck?>,
              AsyncValue<VocabDeck?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(vocabOverview)
final vocabOverviewProvider = VocabOverviewProvider._();

final class VocabOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<VocabOverview>,
          VocabOverview,
          FutureOr<VocabOverview>
        >
    with $FutureModifier<VocabOverview>, $FutureProvider<VocabOverview> {
  VocabOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vocabOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vocabOverviewHash();

  @$internal
  @override
  $FutureProviderElement<VocabOverview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VocabOverview> create(Ref ref) {
    return vocabOverview(ref);
  }
}

String _$vocabOverviewHash() => r'820cda17276bfff110f1442a1eebb9e98a4712fc';
