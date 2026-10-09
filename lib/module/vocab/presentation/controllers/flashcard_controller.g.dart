// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FlashcardSession)
final flashcardSessionProvider = FlashcardSessionFamily._();

final class FlashcardSessionProvider
    extends $AsyncNotifierProvider<FlashcardSession, FlashcardState> {
  FlashcardSessionProvider._({
    required FlashcardSessionFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'flashcardSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$flashcardSessionHash();

  @override
  String toString() {
    return r'flashcardSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FlashcardSession create() => FlashcardSession();

  @override
  bool operator ==(Object other) {
    return other is FlashcardSessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$flashcardSessionHash() => r'5d3145baa57c2f0ccd1383032bb0d21365a1d359';

final class FlashcardSessionFamily extends $Family
    with
        $ClassFamilyOverride<
          FlashcardSession,
          AsyncValue<FlashcardState>,
          FlashcardState,
          FutureOr<FlashcardState>,
          String?
        > {
  FlashcardSessionFamily._()
    : super(
        retry: null,
        name: r'flashcardSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FlashcardSessionProvider call(String? topic) =>
      FlashcardSessionProvider._(argument: topic, from: this);

  @override
  String toString() => r'flashcardSessionProvider';
}

abstract class _$FlashcardSession extends $AsyncNotifier<FlashcardState> {
  late final _$args = ref.$arg as String?;
  String? get topic => _$args;

  FutureOr<FlashcardState> build(String? topic);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<FlashcardState>, FlashcardState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FlashcardState>, FlashcardState>,
              AsyncValue<FlashcardState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
