// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(credentialStorage)
final credentialStorageProvider = CredentialStorageProvider._();

final class CredentialStorageProvider
    extends
        $FunctionalProvider<
          CredentialStorage,
          CredentialStorage,
          CredentialStorage
        >
    with $Provider<CredentialStorage> {
  CredentialStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'credentialStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$credentialStorageHash();

  @$internal
  @override
  $ProviderElement<CredentialStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CredentialStorage create(Ref ref) {
    return credentialStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CredentialStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CredentialStorage>(value),
    );
  }
}

String _$credentialStorageHash() => r'1b4653166c2bb3bc35034568f5dd6afbe089007c';
