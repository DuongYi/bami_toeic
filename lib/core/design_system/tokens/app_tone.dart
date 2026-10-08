import 'package:flutter/material.dart';

import '../theme/context_ext.dart';

/// Sắc thái trạng thái dùng chung cho badge, progress, snackbar, icon…
/// Luôn kèm icon hoặc chữ – KHÔNG truyền đạt ý nghĩa chỉ bằng màu (WCAG 1.4.1).
enum AppTone {
  success(Icons.check_circle_rounded),
  warning(Icons.warning_amber_rounded),
  danger(Icons.cancel_rounded),
  info(Icons.info_rounded),
  neutral(Icons.circle_outlined);

  const AppTone(this.icon);

  final IconData icon;

  /// Ngưỡng tỉ lệ đúng dùng toàn app: ≥ 70% tốt, ≥ 50% trung bình, còn lại yếu.
  static AppTone fromRatio(double ratio) => ratio >= 0.7
      ? AppTone.success
      : ratio >= 0.5
      ? AppTone.warning
      : AppTone.danger;

  ToneColors colorsOf(BuildContext context) {
    final cs = context.colors;
    final ac = context.appColors;
    return switch (this) {
      success => ToneColors(ac.success, ac.onSuccess, ac.successContainer, ac.onSuccessContainer),
      warning => ToneColors(ac.warning, ac.onWarning, ac.warningContainer, ac.onWarningContainer),
      danger => ToneColors(cs.error, cs.onError, cs.errorContainer, cs.onErrorContainer),
      info => ToneColors(cs.primary, cs.onPrimary, cs.primaryContainer, cs.onPrimaryContainer),
      neutral => ToneColors(
        cs.outline,
        cs.surface,
        cs.surfaceContainerHighest,
        cs.onSurfaceVariant,
      ),
    };
  }
}

/// Bộ 4 màu của một tone, giống cấu trúc role M3: x / onX / xContainer / onXContainer.
class ToneColors {
  const ToneColors(this.main, this.onMain, this.container, this.onContainer);

  final Color main;
  final Color onMain;
  final Color container;
  final Color onContainer;
}
