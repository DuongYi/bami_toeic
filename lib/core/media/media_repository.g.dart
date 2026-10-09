// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mediaApi)
final mediaApiProvider = MediaApiProvider._();

final class MediaApiProvider extends $FunctionalProvider<MediaApi, MediaApi, MediaApi>
    with $Provider<MediaApi> {
  MediaApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaApiHash();

  @$internal
  @override
  $ProviderElement<MediaApi> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  MediaApi create(Ref ref) {
    return mediaApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaApi value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<MediaApi>(value));
  }
}

String _$mediaApiHash() => r'00361a7c6c2674f1b4e1a2e5022cd25ca87c51cf';

@ProviderFor(mediaRepository)
final mediaRepositoryProvider = MediaRepositoryProvider._();

final class MediaRepositoryProvider
    extends $FunctionalProvider<MediaRepository, MediaRepository, MediaRepository>
    with $Provider<MediaRepository> {
  MediaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaRepositoryHash();

  @$internal
  @override
  $ProviderElement<MediaRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaRepository create(Ref ref) {
    return mediaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaRepository>(value),
    );
  }
}

String _$mediaRepositoryHash() => r'9d67ad81e431ad057e18c2fb3a24e801b4f41f3b';
