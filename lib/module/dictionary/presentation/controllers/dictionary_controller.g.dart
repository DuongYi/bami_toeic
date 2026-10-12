// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Gợi ý khi gõ (widget tự debounce trước khi đổi [query]).

@ProviderFor(dictSuggestions)
final dictSuggestionsProvider = DictSuggestionsFamily._();

/// Gợi ý khi gõ (widget tự debounce trước khi đổi [query]).

final class DictSuggestionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DictSuggestion>>,
          List<DictSuggestion>,
          FutureOr<List<DictSuggestion>>
        >
    with
        $FutureModifier<List<DictSuggestion>>,
        $FutureProvider<List<DictSuggestion>> {
  /// Gợi ý khi gõ (widget tự debounce trước khi đổi [query]).
  DictSuggestionsProvider._({
    required DictSuggestionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'dictSuggestionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dictSuggestionsHash();

  @override
  String toString() {
    return r'dictSuggestionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<DictSuggestion>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DictSuggestion>> create(Ref ref) {
    final argument = this.argument as String;
    return dictSuggestions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DictSuggestionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dictSuggestionsHash() => r'3a5e152de1434079964328ae1ad3525cb51ae6e5';

/// Gợi ý khi gõ (widget tự debounce trước khi đổi [query]).

final class DictSuggestionsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<DictSuggestion>>, String> {
  DictSuggestionsFamily._()
    : super(
        retry: null,
        name: r'dictSuggestionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Gợi ý khi gõ (widget tự debounce trước khi đổi [query]).

  DictSuggestionsProvider call(String query) =>
      DictSuggestionsProvider._(argument: query, from: this);

  @override
  String toString() => r'dictSuggestionsProvider';
}

/// Mục Anh–Việt của 1 từ.

@ProviderFor(dictLookup)
final dictLookupProvider = DictLookupFamily._();

/// Mục Anh–Việt của 1 từ.

final class DictLookupProvider
    extends
        $FunctionalProvider<
          AsyncValue<DictLookup>,
          DictLookup,
          FutureOr<DictLookup>
        >
    with $FutureModifier<DictLookup>, $FutureProvider<DictLookup> {
  /// Mục Anh–Việt của 1 từ.
  DictLookupProvider._({
    required DictLookupFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'dictLookupProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dictLookupHash();

  @override
  String toString() {
    return r'dictLookupProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<DictLookup> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<DictLookup> create(Ref ref) {
    final argument = this.argument as String;
    return dictLookup(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DictLookupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dictLookupHash() => r'9fda39b352110bd6fa3bfb31128a4345e895d6b6';

/// Mục Anh–Việt của 1 từ.

final class DictLookupFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<DictLookup>, String> {
  DictLookupFamily._()
    : super(
        retry: null,
        name: r'dictLookupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Mục Anh–Việt của 1 từ.

  DictLookupProvider call(String query) =>
      DictLookupProvider._(argument: query, from: this);

  @override
  String toString() => r'dictLookupProvider';
}

/// Định nghĩa Anh–Anh (API ngoài, có thể chậm/lỗi – chỉ là phần bổ sung).

@ProviderFor(enEntries)
final enEntriesProvider = EnEntriesFamily._();

/// Định nghĩa Anh–Anh (API ngoài, có thể chậm/lỗi – chỉ là phần bổ sung).

final class EnEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EnEntry>>,
          List<EnEntry>,
          FutureOr<List<EnEntry>>
        >
    with $FutureModifier<List<EnEntry>>, $FutureProvider<List<EnEntry>> {
  /// Định nghĩa Anh–Anh (API ngoài, có thể chậm/lỗi – chỉ là phần bổ sung).
  EnEntriesProvider._({
    required EnEntriesFamily super.from,
    required String super.argument,
  }) : super(
         retry: _noRetry,
         name: r'enEntriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$enEntriesHash();

  @override
  String toString() {
    return r'enEntriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<EnEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EnEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return enEntries(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EnEntriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$enEntriesHash() => r'cb19152b39ca633e752fb7077adb0e1492cddc50';

/// Định nghĩa Anh–Anh (API ngoài, có thể chậm/lỗi – chỉ là phần bổ sung).

final class EnEntriesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<EnEntry>>, String> {
  EnEntriesFamily._()
    : super(
        retry: _noRetry,
        name: r'enEntriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Định nghĩa Anh–Anh (API ngoài, có thể chậm/lỗi – chỉ là phần bổ sung).

  EnEntriesProvider call(String word) =>
      EnEntriesProvider._(argument: word, from: this);

  @override
  String toString() => r'enEntriesProvider';
}

/// Dịch câu / đoạn Anh → Việt (Google Dịch).

@ProviderFor(translation)
final translationProvider = TranslationFamily._();

/// Dịch câu / đoạn Anh → Việt (Google Dịch).

final class TranslationProvider
    extends
        $FunctionalProvider<
          AsyncValue<Translation>,
          Translation,
          FutureOr<Translation>
        >
    with $FutureModifier<Translation>, $FutureProvider<Translation> {
  /// Dịch câu / đoạn Anh → Việt (Google Dịch).
  TranslationProvider._({
    required TranslationFamily super.from,
    required String super.argument,
  }) : super(
         retry: _noRetry,
         name: r'translationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$translationHash();

  @override
  String toString() {
    return r'translationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Translation> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Translation> create(Ref ref) {
    final argument = this.argument as String;
    return translation(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TranslationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$translationHash() => r'b30d1761cf427f17b7313e4c68c720cedec416c7';

/// Dịch câu / đoạn Anh → Việt (Google Dịch).

final class TranslationFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Translation>, String> {
  TranslationFamily._()
    : super(
        retry: _noRetry,
        name: r'translationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Dịch câu / đoạn Anh → Việt (Google Dịch).

  TranslationProvider call(String text) =>
      TranslationProvider._(argument: text, from: this);

  @override
  String toString() => r'translationProvider';
}

/// Từ đã tra gần đây (lưu trên máy, theo user), mới nhất đứng đầu.

@ProviderFor(DictHistory)
final dictHistoryProvider = DictHistoryProvider._();

/// Từ đã tra gần đây (lưu trên máy, theo user), mới nhất đứng đầu.
final class DictHistoryProvider
    extends $AsyncNotifierProvider<DictHistory, List<String>> {
  /// Từ đã tra gần đây (lưu trên máy, theo user), mới nhất đứng đầu.
  DictHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dictHistoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dictHistoryHash();

  @$internal
  @override
  DictHistory create() => DictHistory();
}

String _$dictHistoryHash() => r'13493572664d8200c7a28eaab24a1d5228229e22';

/// Từ đã tra gần đây (lưu trên máy, theo user), mới nhất đứng đầu.

abstract class _$DictHistory extends $AsyncNotifier<List<String>> {
  FutureOr<List<String>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<String>>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<String>>, List<String>>,
              AsyncValue<List<String>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Sổ từ riêng của user (từ tự lưu), theo từ viết thường.

@ProviderFor(notebookWords)
final notebookWordsProvider = NotebookWordsProvider._();

/// Sổ từ riêng của user (từ tự lưu), theo từ viết thường.

final class NotebookWordsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, VocabItem>>,
          Map<String, VocabItem>,
          FutureOr<Map<String, VocabItem>>
        >
    with
        $FutureModifier<Map<String, VocabItem>>,
        $FutureProvider<Map<String, VocabItem>> {
  /// Sổ từ riêng của user (từ tự lưu), theo từ viết thường.
  NotebookWordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notebookWordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notebookWordsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, VocabItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, VocabItem>> create(Ref ref) {
    return notebookWords(ref);
  }
}

String _$notebookWordsHash() => r'a6ed8c36484714dfe99d257e2aca28d60897a3ec';

/// Từ trong kho chung (ETS) khớp với chữ tra – hiện kèm để biết từ này có trong đề.

@ProviderFor(bankMatches)
final bankMatchesProvider = BankMatchesFamily._();

/// Từ trong kho chung (ETS) khớp với chữ tra – hiện kèm để biết từ này có trong đề.

final class BankMatchesProvider
    extends
        $FunctionalProvider<List<VocabItem>, List<VocabItem>, List<VocabItem>>
    with $Provider<List<VocabItem>> {
  /// Từ trong kho chung (ETS) khớp với chữ tra – hiện kèm để biết từ này có trong đề.
  BankMatchesProvider._({
    required BankMatchesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bankMatchesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bankMatchesHash();

  @override
  String toString() {
    return r'bankMatchesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<VocabItem>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<VocabItem> create(Ref ref) {
    final argument = this.argument as String;
    return bankMatches(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<VocabItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<VocabItem>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BankMatchesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bankMatchesHash() => r'eee9487af140174d335d4e643fd79a9a2846fe5d';

/// Từ trong kho chung (ETS) khớp với chữ tra – hiện kèm để biết từ này có trong đề.

final class BankMatchesFamily extends $Family
    with $FunctionalFamilyOverride<List<VocabItem>, String> {
  BankMatchesFamily._()
    : super(
        retry: null,
        name: r'bankMatchesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Từ trong kho chung (ETS) khớp với chữ tra – hiện kèm để biết từ này có trong đề.

  BankMatchesProvider call(String query) =>
      BankMatchesProvider._(argument: query, from: this);

  @override
  String toString() => r'bankMatchesProvider';
}
