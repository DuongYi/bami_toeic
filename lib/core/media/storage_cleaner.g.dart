// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_cleaner.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storageUsage)
final storageUsageProvider = StorageUsageProvider._();

final class StorageUsageProvider
    extends
        $FunctionalProvider<
          AsyncValue<StorageUsage>,
          StorageUsage,
          FutureOr<StorageUsage>
        >
    with $FutureModifier<StorageUsage>, $FutureProvider<StorageUsage> {
  StorageUsageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageUsageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageUsageHash();

  @$internal
  @override
  $FutureProviderElement<StorageUsage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StorageUsage> create(Ref ref) {
    return storageUsage(ref);
  }
}

String _$storageUsageHash() => r'26f417b1305d789126fa89274c1c27527dad690d';

@ProviderFor(storageCleaner)
final storageCleanerProvider = StorageCleanerProvider._();

final class StorageCleanerProvider
    extends $FunctionalProvider<StorageCleaner, StorageCleaner, StorageCleaner>
    with $Provider<StorageCleaner> {
  StorageCleanerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageCleanerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageCleanerHash();

  @$internal
  @override
  $ProviderElement<StorageCleaner> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StorageCleaner create(Ref ref) {
    return storageCleaner(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StorageCleaner value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StorageCleaner>(value),
    );
  }
}

String _$storageCleanerHash() => r'90041c311dc9e454a6c6f910ee13f5de8ad58962';
