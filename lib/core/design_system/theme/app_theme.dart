import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimens.dart';
import '../tokens/app_palette.dart';
import '../tokens/app_surfaces.dart';

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
      // vibrant: primary rực đúng màu thương hiệu, container vẫn dịu (fidelity làm container quá đậm).
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    );
    final light = brightness == Brightness.light;
    // Lớp nền: màn hình xám nhạt, card nổi lên (trắng ở light, sáng hơn nền ở dark).
    final background = light ? cs.surfaceContainerLow : cs.surface;
    final raised = light ? cs.surfaceContainerLowest : cs.surfaceContainerHigh;
    final hairline = BorderSide(color: cs.outlineVariant.withValues(alpha: light ? 0.6 : 0.4));

    final base = ThemeData(
      colorScheme: cs,
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
    );
    final text = _textTheme(base.textTheme);

    return base.copyWith(
      textTheme: text,
      extensions: [
        appColors,
        AppSurfaces(
          background: background,
          raised: raised,
          hairline: hairline,
          // Light: gradient primary rực. Dark: tông container đậm để không chói.
          hero: light
              ? [cs.primary, Color.lerp(cs.primary, cs.tertiary, 0.55)!]
              : [cs.primaryContainer, Color.lerp(cs.primaryContainer, cs.tertiaryContainer, 0.55)!],
          onHero: light ? cs.onPrimary : cs.onPrimaryContainer,
        ),
      ],
      scaffoldBackgroundColor: background,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        titleTextStyle: text.titleLarge?.copyWith(color: cs.onSurface, fontWeight: FontWeight.w700),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: raised,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brLg, side: hairline),
        clipBehavior: Clip.antiAlias,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: raised,
        surfaceTintColor: Colors.transparent,
        indicatorColor: cs.primaryContainer,
        elevation: 0,
        height: AppSizes.navBarHeight,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => text.labelMedium?.copyWith(
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            color: states.contains(WidgetState.selected) ? cs.onSurface : cs.onSurfaceVariant,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? cs.onPrimaryContainer
                : cs.onSurfaceVariant,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        minVerticalPadding: AppSpacing.s12,
        titleTextStyle: text.titleMedium?.copyWith(color: cs.onSurface),
        subtitleTextStyle: text.bodySmall?.copyWith(color: cs.onSurfaceVariant),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: raised,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s16,
        ),
        prefixIconColor: cs.onSurfaceVariant,
        suffixIconColor: cs.onSurfaceVariant,
        border: OutlineInputBorder(borderRadius: AppRadius.brMd, borderSide: hairline),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(AppSizes.touchTarget, AppSizes.touchTarget),
          textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(AppSizes.touchTarget, AppSizes.touchTarget),
          side: BorderSide(color: cs.outlineVariant),
          textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(AppSizes.touchTarget, AppSizes.touchTarget),
          textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 2,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brLg),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: cs.primaryContainer,
          selectedForegroundColor: cs.onPrimaryContainer,
          backgroundColor: raised,
          side: BorderSide(color: cs.outlineVariant),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide(color: cs.outlineVariant),
        backgroundColor: raised,
        selectedColor: cs.primaryContainer,
        showCheckmark: false,
        labelStyle: text.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        showDragHandle: true,
        backgroundColor: raised,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: raised,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brXl),
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
    displaySmall: t.displaySmall?.copyWith(fontWeight: FontWeight.w700, height: 1.2),
    headlineLarge: t.headlineLarge?.copyWith(fontWeight: FontWeight.w700, height: 1.25),
    headlineMedium: t.headlineMedium?.copyWith(fontWeight: FontWeight.w700, height: 1.3),
    headlineSmall: t.headlineSmall?.copyWith(fontWeight: FontWeight.w700, height: 1.3),
    titleLarge: t.titleLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.35),
    titleMedium: t.titleMedium?.copyWith(fontWeight: FontWeight.w600, height: 1.4),
    titleSmall: t.titleSmall?.copyWith(height: 1.4),
    bodyLarge: t.bodyLarge?.copyWith(height: 1.5),
    bodyMedium: t.bodyMedium?.copyWith(height: 1.5),
    bodySmall: t.bodySmall?.copyWith(height: 1.45),
    labelLarge: t.labelLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.4),
    labelMedium: t.labelMedium?.copyWith(fontWeight: FontWeight.w500),
  );
}
