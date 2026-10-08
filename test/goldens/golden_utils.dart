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
  final bvp = FontLoader('BeVietnamPro');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    bvp.addFont(File('assets/fonts/BeVietnamPro-$w.ttf').readAsBytes().then(ByteData.sublistView));
  }
  await bvp.load();
  await (FontLoader('MaterialIcons')..addFont(read('MaterialIcons-Regular.otf'))).load();
}
