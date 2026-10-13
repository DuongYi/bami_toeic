import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../design_system/design_system.dart';

part 'handwriting_recognizer.g.dart';

@Riverpod(keepAlive: true)
HandwritingRecognizer handwritingRecognizer(Ref ref) => HandwritingRecognizer();

/// Nhận dạng chữ viết tay tiếng Anh từ nét vẽ: dựng ảnh mực đen trên nền trắng rồi nhờ
/// Vision của iOS nhận dạng ngay trên máy (không gửi dữ liệu đi đâu). Bên native: ios/Runner/AppDelegate.swift.
class HandwritingRecognizer {
  static const _channel = MethodChannel('bami/handwriting');

  /// Chỉ iOS / iPadOS có Vision; nền tảng khác dùng Scribble hoặc gõ phím.
  bool get isSupported => !kIsWeb && Platform.isIOS;

  /// Chữ nhận dạng được (đã gộp các dòng, bỏ khoảng trắng thừa); rỗng nếu không đọc được.
  Future<String> recognize(List<DrawStroke> strokes) async {
    final png = await renderStrokes(strokes);
    if (png == null) return '';
    final text = await _channel.invokeMethod<String>('recognize', {'png': png});
    return (text ?? '').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Ảnh PNG chỉ gồm vùng có nét (thêm lề), nét đậm màu đen – dạng Vision đọc tốt nhất.
  @visibleForTesting
  static Future<Uint8List?> renderStrokes(List<DrawStroke> strokes, {double scale = 2}) async {
    final points = [for (final s in strokes) ...s.points];
    if (points.isEmpty) return null;
    var left = points.first.dx, top = points.first.dy, right = left, bottom = top;
    for (final p in points) {
      left = math.min(left, p.dx);
      top = math.min(top, p.dy);
      right = math.max(right, p.dx);
      bottom = math.max(bottom, p.dy);
    }
    // Lề rộng theo chiều cao nét: Vision dò dòng chữ kém khi chữ chiếm sát mép ảnh.
    final pad = math.max(32.0, (bottom - top) * 0.6);
    final width = right - left + pad * 2;
    final height = bottom - top + pad * 2;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)
      ..scale(scale)
      // ds-ignore: nền trắng của ảnh gửi cho Vision, không phải màu giao diện
      ..drawRect(Rect.fromLTWH(0, 0, width, height), Paint()..color = const Color(0xFFFFFFFF)) // ds-ignore
      ..translate(pad - left, pad - top);
    for (final s in strokes) {
      if (s.isHighlighter || s.points.isEmpty) continue;
      final paint = Paint()
        ..color = const Color(0xFF000000) // ds-ignore: mực đen cho Vision, không phải màu giao diện
        ..strokeWidth = math.max(s.strokeWidth * 1.6, 3.5)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      if (s.points.length == 1) {
        canvas.drawCircle(s.points.first, paint.strokeWidth / 2, paint..style = PaintingStyle.fill);
        continue;
      }
      final path = Path()..moveTo(s.points.first.dx, s.points.first.dy);
      for (final p in s.points.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, paint);
    }
    final image = await recorder.endRecording().toImage(
      (width * scale).ceil(),
      (height * scale).ceil(),
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return bytes?.buffer.asUint8List();
  }
}
