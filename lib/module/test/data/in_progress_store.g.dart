// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_progress_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TakingSnapshot _$TakingSnapshotFromJson(
  Map<String, dynamic> json,
) => _TakingSnapshot(
  testId: json['test_id'] as String,
  mode: json['mode'] as String,
  parts: (json['parts'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  startedAt: DateTime.parse(json['started_at'] as String),
  clockSeconds: (json['clock_seconds'] as num).toInt(),
  index: (json['index'] as num?)?.toInt() ?? 0,
  answers:
      (json['answers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  revealed:
      (json['revealed'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  flagged:
      (json['flagged'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  totalQuestions: (json['total_questions'] as num).toInt(),
  savedAt: DateTime.parse(json['saved_at'] as String),
);

Map<String, dynamic> _$TakingSnapshotToJson(_TakingSnapshot instance) =>
    <String, dynamic>{
      'test_id': instance.testId,
      'mode': instance.mode,
      'parts': instance.parts,
      'started_at': instance.startedAt.toIso8601String(),
      'clock_seconds': instance.clockSeconds,
      'index': instance.index,
      'answers': instance.answers,
      'revealed': instance.revealed,
      'flagged': instance.flagged,
      'total_questions': instance.totalQuestions,
      'saved_at': instance.savedAt.toIso8601String(),
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'ad13470fe866595ad0f58a3e26f11048d94ef22e';

@ProviderFor(inProgressStore)
final inProgressStoreProvider = InProgressStoreProvider._();

final class InProgressStoreProvider
    extends
        $FunctionalProvider<InProgressStore, InProgressStore, InProgressStore>
    with $Provider<InProgressStore> {
  InProgressStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inProgressStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inProgressStoreHash();

  @$internal
  @override
  $ProviderElement<InProgressStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  InProgressStore create(Ref ref) {
    return inProgressStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InProgressStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InProgressStore>(value),
    );
  }
}

String _$inProgressStoreHash() => r'bafa89cc6ab98dceab2335f6e91afcb9827cc880';

/// Bài làm dở của 1 đề (null nếu không có).

@ProviderFor(inProgress)
final inProgressProvider = InProgressFamily._();

/// Bài làm dở của 1 đề (null nếu không có).

final class InProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<TakingSnapshot?>,
          TakingSnapshot?,
          FutureOr<TakingSnapshot?>
        >
    with $FutureModifier<TakingSnapshot?>, $FutureProvider<TakingSnapshot?> {
  /// Bài làm dở của 1 đề (null nếu không có).
  InProgressProvider._({
    required InProgressFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'inProgressProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$inProgressHash();

  @override
  String toString() {
    return r'inProgressProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TakingSnapshot?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TakingSnapshot?> create(Ref ref) {
    final argument = this.argument as String;
    return inProgress(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InProgressProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$inProgressHash() => r'0c7d8cce90a07a7a8f7008d2dfddd8bb076dff96';

/// Bài làm dở của 1 đề (null nếu không có).

final class InProgressFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TakingSnapshot?>, String> {
  InProgressFamily._()
    : super(
        retry: null,
        name: r'inProgressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Bài làm dở của 1 đề (null nếu không có).

  InProgressProvider call(String testId) =>
      InProgressProvider._(argument: testId, from: this);

  @override
  String toString() => r'inProgressProvider';
}

/// Tất cả bài làm dở (để gắn nhãn "Đang làm dở" ở danh sách đề).

@ProviderFor(inProgressAll)
final inProgressAllProvider = InProgressAllProvider._();

/// Tất cả bài làm dở (để gắn nhãn "Đang làm dở" ở danh sách đề).

final class InProgressAllProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, TakingSnapshot>>,
          Map<String, TakingSnapshot>,
          FutureOr<Map<String, TakingSnapshot>>
        >
    with
        $FutureModifier<Map<String, TakingSnapshot>>,
        $FutureProvider<Map<String, TakingSnapshot>> {
  /// Tất cả bài làm dở (để gắn nhãn "Đang làm dở" ở danh sách đề).
  InProgressAllProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inProgressAllProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inProgressAllHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, TakingSnapshot>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, TakingSnapshot>> create(Ref ref) {
    return inProgressAll(ref);
  }
}

String _$inProgressAllHash() => r'9471b920060ed4b0fdf1fc974a1b802107265d82';
