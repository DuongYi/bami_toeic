import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Lưu ảnh chụp màn hình của integration test vào thư mục SCREENSHOT_DIR (mặc định build/screenshots).
Future<void> main() => integrationDriver(
  onScreenshot: (name, bytes, [args]) async {
    final dir = Platform.environment['SCREENSHOT_DIR'] ?? 'build/screenshots';
    final f = File('$dir/$name.png');
    await f.create(recursive: true);
    await f.writeAsBytes(bytes);
    return true;
  },
);
