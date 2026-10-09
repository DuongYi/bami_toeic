import 'package:flutter/material.dart';

/// Lớp 1 – PRIMITIVE. Giá trị màu thô, CHỈ được dùng bên trong design_system/.
/// UI phải dùng màu semantic: `context.colors` (ColorScheme) hoặc `context.appColors`.
abstract final class AppPalette {
  /// Màu thương hiệu (seed cho ColorScheme M3): Electric Royal Blue.
  static const brandBlue = Color(0xFF1E5EFF);
  static const brandIndigo = Color(0xFF4338CA);
  static const brandViolet = Color(0xFF6D28D9);

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

  // Commercial Accent Tokens (Gold / Rose / Emerald / Violet / Cyan / Coral)
  static const gold500 = Color(0xFFF59E0B);
  static const gold600 = Color(0xFFD97706);
  static const rose500 = Color(0xFFF43F5E);
  static const rose600 = Color(0xFFE11D48);
  static const emerald500 = Color(0xFF10B981);
  static const emerald600 = Color(0xFF059669);
  static const violet500 = Color(0xFF8B5CF6);
  static const violet600 = Color(0xFF7C3AED);
  static const cyan500 = Color(0xFF06B6D4);
  static const cyan600 = Color(0xFF0891B2);
  static const coral500 = Color(0xFFFF5722);
}
