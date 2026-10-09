import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';
import '../theme/context_ext.dart';

/// Huy hiệu PRO / Thành viên trả phí hoặc tính năng cao cấp.
class ProBadge extends StatelessWidget {
  const ProBadge({super.key, this.label = 'PRO', this.mini = false});

  final String label;
  final bool mini;

  @override
  Widget build(BuildContext context) {
    final tc = AppTone.warning.colorsOf(context);
    final textStyle = (mini ? context.textStyles.labelSmall : context.textStyles.labelMedium)
        ?.copyWith(color: tc.onContainer, fontWeight: FontWeight.w800, letterSpacing: 0.5);

    return Semantics(
      label: 'Tài khoản $label',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: mini ? AppSpacing.s4 : AppSpacing.s8,
          vertical: mini ? AppSpacing.s2 : AppSpacing.s4,
        ),
        decoration: BoxDecoration(
          color: tc.container,
          borderRadius: AppRadius.brXs,
          border: Border.all(color: tc.main.withValues(alpha: 0.4), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              size: mini ? AppSizes.iconXs : AppSizes.iconSm,
              color: tc.main,
            ),
            SizedBox(width: AppSpacing.s4),
            Text(label, style: textStyle),
          ],
        ),
      ),
    );
  }
}
