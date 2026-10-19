// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tình hình học hôm nay, gom cho nhắc học thông minh và widget màn hình chính.

@ProviderFor(habitStatus)
final habitStatusProvider = HabitStatusProvider._();

/// Tình hình học hôm nay, gom cho nhắc học thông minh và widget màn hình chính.

final class HabitStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<HabitStatus>,
          HabitStatus,
          FutureOr<HabitStatus>
        >
    with $FutureModifier<HabitStatus>, $FutureProvider<HabitStatus> {
  /// Tình hình học hôm nay, gom cho nhắc học thông minh và widget màn hình chính.
  HabitStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'habitStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$habitStatusHash();

  @$internal
  @override
  $FutureProviderElement<HabitStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HabitStatus> create(Ref ref) {
    return habitStatus(ref);
  }
}

String _$habitStatusHash() => r'28e76a50b28089ef90cb6a94fff3ab5467716631';
