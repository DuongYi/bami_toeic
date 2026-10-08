import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// Lối tắt truy cập token từ theme. Dùng thay cho `Theme.of(context)...`.
extension DesignSystemContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
