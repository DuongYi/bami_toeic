// Kiểm tra kênh nhận dạng chữ viết tay (Vision, iOS) trên simulator / máy thật:
//
//   flutter test integration_test/handwriting_vision_test.dart -d <iPad simulator>
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:bami_toeic/core/design_system/design_system.dart';
import 'package:bami_toeic/core/handwriting/handwriting_recognizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Ảnh PNG chữ in đen trên nền trắng.
Future<Uint8List> _textPng(String text) async {
  final painter = TextPainter(
    text: TextSpan(text: text, style: const TextStyle(fontSize: 64, color: Color(0xFF000000))),
    textDirection: TextDirection.ltr,
  )..layout();
  final recorder = ui.PictureRecorder();
  final w = painter.width + 80, h = painter.height + 80;
  final canvas = Canvas(recorder)..drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = const Color(0xFFFFFFFF));
  painter.paint(canvas, const Offset(40, 40));
  final image = await recorder.endRecording().toImage(w.ceil(), h.ceil());
  return (await image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
}

DrawStroke _line(Offset a, Offset b) =>
    DrawStroke(points: [for (var t = 0.0; t <= 1; t += 0.05) Offset.lerp(a, b, t)!], color: const Color(0xFF000000));

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Vision đọc được ảnh chữ in', (tester) async {
    final text = await const MethodChannel('bami/handwriting')
        .invokeMethod<String>('recognize', {'png': await _textPng('hello world')});
    expect(text?.toLowerCase(), contains('hello world'));
  });

  testWidgets('Vision đọc được chữ "HELLO" vẽ bằng nét', (tester) async {
    // Chữ in hoa dựng từ nét thẳng + đường tròn, cao 100, rộng 60, cách nhau 30 – như người viết chữ in.
    List<DrawStroke> at(double x, List<(Offset, Offset)> segs) =>
        [for (final (a, b) in segs) _line(a + Offset(x, 0), b + Offset(x, 0))];
    final o = DrawStroke(
      points: [
        for (var i = 0; i <= 40; i++)
          Offset(4 * 90 + 30 + 30 * math.cos(i * math.pi / 20), 50 + 50 * math.sin(i * math.pi / 20)),
      ],
      color: const Color(0xFF000000),
    );
    final strokes = [
      ...at(0, [(Offset.zero, const Offset(0, 100)), (const Offset(60, 0), const Offset(60, 100)), (const Offset(0, 50), const Offset(60, 50))]),
      ...at(90, [(Offset.zero, const Offset(0, 100)), (Offset.zero, const Offset(55, 0)), (const Offset(0, 50), const Offset(45, 50)), (const Offset(0, 100), const Offset(55, 100))]),
      ...at(180, [(Offset.zero, const Offset(0, 100)), (const Offset(0, 100), const Offset(55, 100))]),
      ...at(270, [(Offset.zero, const Offset(0, 100)), (const Offset(0, 100), const Offset(55, 100))]),
      o,
    ];
    final text = await HandwritingRecognizer().recognize(strokes);
    debugPrint('Nhận dạng nét vẽ: "$text"');
    expect(text.toUpperCase().replaceAll(' ', ''), contains('HELLO'));
  });
}
