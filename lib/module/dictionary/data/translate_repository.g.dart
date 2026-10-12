// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(translateRepository)
final translateRepositoryProvider = TranslateRepositoryProvider._();

final class TranslateRepositoryProvider
    extends
        $FunctionalProvider<
          TranslateRepository,
          TranslateRepository,
          TranslateRepository
        >
    with $Provider<TranslateRepository> {
  TranslateRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'translateRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$translateRepositoryHash();

  @$internal
  @override
  $ProviderElement<TranslateRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TranslateRepository create(Ref ref) {
    return translateRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TranslateRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TranslateRepository>(value),
    );
  }
}

String _$translateRepositoryHash() =>
    r'3b0bdac8ceef587f648a5e4f3fd3b7f1f9b32675';
