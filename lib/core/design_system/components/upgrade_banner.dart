import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';
import 'app_card.dart';
import '../theme/context_ext.dart';

/// Banner giới thiệu tính năng Bami PRO và thúc đẩy chuyển đổi.
class UpgradeBanner extends StatelessWidget {
  const UpgradeBanner({
    super.key,
    required this.title,
    required this.description,
    required this.onUpgrade,
    this.actionLabel = 'Nâng cấp ngay',
    this.onDismiss,
  });

  final String title;
  final String description;
  final VoidCallback onUpgrade;
  final String actionLabel;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final tc = AppTone.warning.colorsOf(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s8),
                decoration: BoxDecoration(color: tc.container, borderRadius: AppRadius.brSm),
                child: Icon(Icons.auto_awesome_rounded, color: tc.main, size: AppSizes.iconMd),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textStyles.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      description,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Đóng gợi ý',
                  iconSize: AppSizes.iconSm,
                  onPressed: onDismiss,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonal(
              onPressed: onUpgrade,
              style: FilledButton.styleFrom(
                backgroundColor: tc.container,
                foregroundColor: tc.onContainer,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s16,
                  vertical: AppSpacing.s8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(actionLabel),
                  const SizedBox(width: AppSpacing.s4),
                  const Icon(Icons.arrow_forward_rounded, size: AppSizes.iconSm),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
