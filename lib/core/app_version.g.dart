// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Phiên bản + số build thật của app (từ pubspec qua bundle), hiện ở Cài đặt.

@ProviderFor(appVersion)
final appVersionProvider = AppVersionProvider._();

/// Phiên bản + số build thật của app (từ pubspec qua bundle), hiện ở Cài đặt.

final class AppVersionProvider
    extends
        $FunctionalProvider<
          AsyncValue<PackageInfo>,
          PackageInfo,
          FutureOr<PackageInfo>
        >
    with $FutureModifier<PackageInfo>, $FutureProvider<PackageInfo> {
  /// Phiên bản + số build thật của app (từ pubspec qua bundle), hiện ở Cài đặt.
  AppVersionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appVersionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appVersionHash();

  @$internal
  @override
  $FutureProviderElement<PackageInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PackageInfo> create(Ref ref) {
    return appVersion(ref);
  }
}

String _$appVersionHash() => r'16968f2a3006959948f649923e390b5137d8b330';
