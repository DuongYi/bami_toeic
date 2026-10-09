import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';
import '../tokens/app_palette.dart';
import '../theme/context_ext.dart';

/// Huy hiệu Bami Gem / Coin dùng cho gamification và phần thưởng thương mại.
class CoinBadge extends StatelessWidget {
  const CoinBadge({super.key, required this.amount, this.onTap});

  final int amount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: AppRadius.brFull,
        border: Border.all(color: AppPalette.cyan500.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.diamond_rounded, size: AppSizes.iconSm, color: AppPalette.cyan500),
          const SizedBox(width: AppSpacing.s4),
          Text(
            '$amount',
            style: context.textStyles.labelMedium?.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return body;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.brFull,
      child: body,
    );
  }
}
