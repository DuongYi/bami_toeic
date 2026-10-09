import 'dart:io';

import 'package:flutter/services.dart';

/// Nạp font Roboto + Material Icons thật từ Flutter SDK để ảnh golden hiển thị chữ thay vì ô vuông.
Future<void> loadAppFonts() async {
  final dir = '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts';
  Future<ByteData> read(String name) async =>
      ByteData.sublistView(await File('$dir/$name').readAsBytes());

  final roboto = FontLoader('Roboto');
  for (final f in ['Roboto-Regular.ttf', 'Roboto-Medium.ttf', 'Roboto-Bold.ttf']) {
    roboto.addFont(read(f));
  }
  await roboto.load();
  final manrope = FontLoader('Manrope');
  for (final w in ['ExtraLight', 'Light', 'Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    manrope.addFont(
      File('assets/fonts/manrope/Manrope-$w.ttf').readAsBytes().then(ByteData.sublistView),
    );
  }
  await manrope.load();
  await (FontLoader('MaterialIcons')..addFont(read('MaterialIcons-Regular.otf'))).load();
}
