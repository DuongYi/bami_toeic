// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(offlineStore)
final offlineStoreProvider = OfflineStoreProvider._();

final class OfflineStoreProvider
    extends $FunctionalProvider<OfflineStore, OfflineStore, OfflineStore>
    with $Provider<OfflineStore> {
  OfflineStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offlineStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineStoreHash();

  @$internal
  @override
  $ProviderElement<OfflineStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OfflineStore create(Ref ref) {
    return offlineStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OfflineStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OfflineStore>(value),
    );
  }
}

String _$offlineStoreHash() => r'c137619de541ff95b33f4f831db785314ccc0517';
