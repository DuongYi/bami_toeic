import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Lớp 2 – SEMANTIC (bổ sung cho ColorScheme M3).
///
/// ColorScheme đã có: primary, secondary, tertiary, error, surface*, outline…
/// AppColors thêm các vai trò M3 không có: success, warning.
/// Lấy bằng `context.appColors`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  static const light = AppColors(
    success: AppPalette.green700,
    onSuccess: Colors.white,
    successContainer: AppPalette.green100,
    onSuccessContainer: AppPalette.green900,
    warning: AppPalette.amber800,
    onWarning: Colors.white,
    warningContainer: AppPalette.amber100,
    onWarningContainer: AppPalette.amber900,
  );

  static const dark = AppColors(
    success: AppPalette.green300,
    onSuccess: AppPalette.green900,
    successContainer: AppPalette.green800,
    onSuccessContainer: AppPalette.green50,
    warning: AppPalette.amber300,
    onWarning: AppPalette.amber900,
    warningContainer: AppPalette.amber700,
    onWarningContainer: AppPalette.amber100,
  );

  /// Tương phản cao: dùng màu đậm nhất / nhạt nhất.
  static const lightHighContrast = AppColors(
    success: AppPalette.green900,
    onSuccess: Colors.white,
    successContainer: AppPalette.green100,
    onSuccessContainer: AppPalette.green900,
    warning: AppPalette.amber900,
    onWarning: Colors.white,
    warningContainer: AppPalette.amber100,
    onWarningContainer: AppPalette.amber900,
  );

  static const darkHighContrast = AppColors(
    success: AppPalette.green50,
    onSuccess: AppPalette.green900,
    successContainer: AppPalette.green800,
    onSuccessContainer: Colors.white,
    warning: AppPalette.amber100,
    onWarning: AppPalette.amber900,
    warningContainer: AppPalette.amber700,
    onWarningContainer: Colors.white,
  );

  @override
  AppColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
  }) => AppColors(
    success: success ?? this.success,
    onSuccess: onSuccess ?? this.onSuccess,
    successContainer: successContainer ?? this.successContainer,
    onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
    warning: warning ?? this.warning,
    onWarning: onWarning ?? this.onWarning,
    warningContainer: warningContainer ?? this.warningContainer,
    onWarningContainer: onWarningContainer ?? this.onWarningContainer,
  );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
    );
  }
}
