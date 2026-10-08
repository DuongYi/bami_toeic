import 'package:flutter/material.dart';

/// Lớp 1 – PRIMITIVE. Giá trị màu thô, CHỈ được dùng bên trong design_system/.
/// UI phải dùng màu semantic: `context.colors` (ColorScheme) hoặc `context.appColors`.
abstract final class AppPalette {
  /// Màu thương hiệu (seed cho ColorScheme M3).
  static const brandBlue = Color(0xFF1E5EFF);

  // Success (xanh lá) – đã kiểm tra tương phản AA với nền surface tương ứng.
  static const green700 = Color(0xFF1B7F3B); // 5.0:1 trên trắng
  static const green100 = Color(0xFFD7F5DF);
  static const green900 = Color(0xFF0B3D1C);
  static const green300 = Color(0xFF6FDB8F); // dùng cho dark
  static const green800 = Color(0xFF0F5129);
  static const green50 = Color(0xFFC9F5D5);

  // Warning (cam/hổ phách)
  static const amber800 = Color(0xFF9A5B00); // 5.0:1 trên trắng
  static const amber100 = Color(0xFFFFE8C7);
  static const amber900 = Color(0xFF4A2B00);
  static const amber300 = Color(0xFFFFB95C); // dùng cho dark
  static const amber700 = Color(0xFF6B3F00);
}
