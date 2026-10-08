import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimens.dart';
import '../tokens/app_palette.dart';

/// Lớp 3 – COMPONENT: cấu hình mặc định cho mọi widget Material.
/// Widget trong app chỉ cần dùng component chuẩn, KHÔNG tự set màu/bo góc/padding.
abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light, AppColors.light, contrast: 0);
  static ThemeData dark() => _build(Brightness.dark, AppColors.dark, contrast: 0);
  static ThemeData lightHighContrast() =>
      _build(Brightness.light, AppColors.lightHighContrast, contrast: 1);
  static ThemeData darkHighContrast() =>
      _build(Brightness.dark, AppColors.darkHighContrast, contrast: 1);

  static ThemeData _build(Brightness brightness, AppColors appColors, {required double contrast}) {
    final cs = ColorScheme.fromSeed(
      seedColor: AppPalette.brandBlue,
      brightness: brightness,
      contrastLevel: contrast,
    );
    final base = ThemeData(colorScheme: cs, useMaterial3: true);
    final text = _textTheme(base.textTheme);

    return base.copyWith(
      textTheme: text,
      extensions: [appColors],
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: const AppBarTheme(centerTitle: false, scrolledUnderElevation: 2),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: cs.surfaceContainerLow,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brLg),
        clipBehavior: Clip.antiAlias,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        minVerticalPadding: AppSpacing.s8,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: AppRadius.brMd),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(AppSizes.touchTarget, AppSizes.touchTarget),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(AppSizes.touchTarget, AppSizes.touchTarget),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(AppSizes.touchTarget, AppSizes.touchTarget),
        ),
      ),
      chipTheme: const ChipThemeData(shape: RoundedRectangleBorder(borderRadius: AppRadius.brSm)),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brSm),
      ),
      bottomSheetTheme: const BottomSheetThemeData(showDragHandle: true),
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brXl),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        linearTrackColor: cs.surfaceContainerHighest,
        linearMinHeight: AppSizes.progressThin,
      ),
      dividerTheme: DividerThemeData(color: cs.outlineVariant, space: AppSpacing.s32),
    );
  }

  /// M3 type scale + line-height thoáng hơn cho dấu tiếng Việt (Ấ, Ễ, Ộ…).
  static TextTheme _textTheme(TextTheme t) => t.copyWith(
    displaySmall: t.displaySmall?.copyWith(fontWeight: FontWeight.w700, height: 1.25),
    headlineMedium: t.headlineMedium?.copyWith(height: 1.3),
    headlineSmall: t.headlineSmall?.copyWith(fontWeight: FontWeight.w600, height: 1.3),
    titleLarge: t.titleLarge?.copyWith(height: 1.35),
    titleMedium: t.titleMedium?.copyWith(fontWeight: FontWeight.w600, height: 1.4),
    titleSmall: t.titleSmall?.copyWith(height: 1.4),
    bodyLarge: t.bodyLarge?.copyWith(height: 1.5),
    bodyMedium: t.bodyMedium?.copyWith(height: 1.5),
    bodySmall: t.bodySmall?.copyWith(height: 1.45),
    labelLarge: t.labelLarge?.copyWith(height: 1.4),
  );
}
