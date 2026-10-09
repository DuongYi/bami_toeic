// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Phiên flashcard. [deckKey]: bộ lấy từ mới (null = bộ đang học);
/// [extraNew] > 0: "Học thêm" đúng chừng ấy từ mới, bỏ qua chỉ tiêu ngày.

@ProviderFor(FlashcardSession)
final flashcardSessionProvider = FlashcardSessionFamily._();

/// Phiên flashcard. [deckKey]: bộ lấy từ mới (null = bộ đang học);
/// [extraNew] > 0: "Học thêm" đúng chừng ấy từ mới, bỏ qua chỉ tiêu ngày.
final class FlashcardSessionProvider
    extends $AsyncNotifierProvider<FlashcardSession, FlashcardState> {
  /// Phiên flashcard. [deckKey]: bộ lấy từ mới (null = bộ đang học);
  /// [extraNew] > 0: "Học thêm" đúng chừng ấy từ mới, bỏ qua chỉ tiêu ngày.
  FlashcardSessionProvider._({
    required FlashcardSessionFamily super.from,
    required (String?, int) super.argument,
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
        '$argument';
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

String _$flashcardSessionHash() => r'b074120ded6c343b6c01f14238d65f4fcc11ade5';

/// Phiên flashcard. [deckKey]: bộ lấy từ mới (null = bộ đang học);
/// [extraNew] > 0: "Học thêm" đúng chừng ấy từ mới, bỏ qua chỉ tiêu ngày.

final class FlashcardSessionFamily extends $Family
    with
        $ClassFamilyOverride<
          FlashcardSession,
          AsyncValue<FlashcardState>,
          FlashcardState,
          FutureOr<FlashcardState>,
          (String?, int)
        > {
  FlashcardSessionFamily._()
    : super(
        retry: null,
        name: r'flashcardSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Phiên flashcard. [deckKey]: bộ lấy từ mới (null = bộ đang học);
  /// [extraNew] > 0: "Học thêm" đúng chừng ấy từ mới, bỏ qua chỉ tiêu ngày.

  FlashcardSessionProvider call(String? deckKey, int extraNew) =>
      FlashcardSessionProvider._(argument: (deckKey, extraNew), from: this);

  @override
  String toString() => r'flashcardSessionProvider';
}

/// Phiên flashcard. [deckKey]: bộ lấy từ mới (null = bộ đang học);
/// [extraNew] > 0: "Học thêm" đúng chừng ấy từ mới, bỏ qua chỉ tiêu ngày.

abstract class _$FlashcardSession extends $AsyncNotifier<FlashcardState> {
  late final _$args = ref.$arg as (String?, int);
  String? get deckKey => _$args.$1;
  int get extraNew => _$args.$2;

  FutureOr<FlashcardState> build(String? deckKey, int extraNew);
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
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
