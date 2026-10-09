// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dio dùng chung cho toàn app (Supabase REST, Auth).

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Dio dùng chung cho toàn app (Supabase REST, Auth).

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Dio dùng chung cho toàn app (Supabase REST, Auth).
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'bebcc3b6a18e9e3bf56d2fe96bc53c5f63390437';
