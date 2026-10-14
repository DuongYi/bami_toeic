import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_version.g.dart';

/// Phiên bản + số build thật của app (từ pubspec qua bundle), hiện ở Cài đặt.
@Riverpod(keepAlive: true)
Future<PackageInfo> appVersion(Ref ref) => PackageInfo.fromPlatform();
