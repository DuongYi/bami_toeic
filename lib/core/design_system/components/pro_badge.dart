import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';
import '../tokens/app_palette.dart';
import '../theme/context_ext.dart';

/// Huy hiệu PRO / Thành viên trả phí với hiệu ứng ánh kim cao cấp.
class ProBadge extends StatelessWidget {
  const ProBadge({super.key, this.label = 'PRO', this.mini = false});

  final String label;
  final bool mini;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Tài khoản $label',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: mini ? AppSpacing.s4 : AppSpacing.s8,
          vertical: mini ? AppSpacing.s2 : AppSpacing.s4,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: context.surfaces.gold,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadius.brXs,
          boxShadow: [
            BoxShadow(
              color: AppPalette.gold600.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              size: mini ? AppSizes.iconXs : AppSizes.iconSm,
              color: Colors.white,
            ),
            const SizedBox(width: AppSpacing.s4),
            Text(
              label,
              style: (mini ? context.textStyles.labelSmall : context.textStyles.labelMedium)
                  ?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
