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

/// Toàn bộ từ vựng + thao tác thêm/sửa/xoá.

@ProviderFor(VocabList)
final vocabListProvider = VocabListProvider._();

/// Toàn bộ từ vựng + thao tác thêm/sửa/xoá.
final class VocabListProvider
    extends $AsyncNotifierProvider<VocabList, List<VocabItem>> {
  /// Toàn bộ từ vựng + thao tác thêm/sửa/xoá.
  VocabListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vocabListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vocabListHash();

  @$internal
  @override
  VocabList create() => VocabList();
}

String _$vocabListHash() => r'fe84cdadc0058f0605568d0626a84a5f6752fe73';

/// Toàn bộ từ vựng + thao tác thêm/sửa/xoá.

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

@ProviderFor(VocabFilter)
final vocabFilterProvider = VocabFilterProvider._();

final class VocabFilterProvider
    extends $NotifierProvider<VocabFilter, VocabFilterState> {
  VocabFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vocabFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vocabFilterHash();

  @$internal
  @override
  VocabFilter create() => VocabFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VocabFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VocabFilterState>(value),
    );
  }
}

String _$vocabFilterHash() => r'cbcfdee1a952c56c62468e294baddb8f5b3198cf';

abstract class _$VocabFilter extends $Notifier<VocabFilterState> {
  VocabFilterState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<VocabFilterState, VocabFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VocabFilterState, VocabFilterState>,
              VocabFilterState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Dữ liệu dẫn xuất cho màn danh sách; tự tính lại khi list hoặc bộ lọc đổi.

@ProviderFor(vocabOverview)
final vocabOverviewProvider = VocabOverviewProvider._();

/// Dữ liệu dẫn xuất cho màn danh sách; tự tính lại khi list hoặc bộ lọc đổi.

final class VocabOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<VocabOverview>,
          AsyncValue<VocabOverview>,
          AsyncValue<VocabOverview>
        >
    with $Provider<AsyncValue<VocabOverview>> {
  /// Dữ liệu dẫn xuất cho màn danh sách; tự tính lại khi list hoặc bộ lọc đổi.
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
  $ProviderElement<AsyncValue<VocabOverview>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<VocabOverview> create(Ref ref) {
    return vocabOverview(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<VocabOverview> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<VocabOverview>>(value),
    );
  }
}

String _$vocabOverviewHash() => r'2d6e4310f42a2faf2babc0394ddac165d1df5fe9';
