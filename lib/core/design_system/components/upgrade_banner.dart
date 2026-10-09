import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';
import '../tokens/app_palette.dart';
import '../theme/context_ext.dart';

/// Banner giới thiệu tính năng Bami PRO và thúc đẩy chuyển đổi với nền gradient vàng sang trọng.
class UpgradeBanner extends StatelessWidget {
  const UpgradeBanner({
    super.key,
    required this.title,
    required this.description,
    required this.onUpgrade,
    this.actionLabel = 'Nâng cấp ngay',
    this.onDismiss,
    this.badge,
    this.caption,
  });

  final String title;
  final String description;
  final VoidCallback onUpgrade;
  final String actionLabel;
  final VoidCallback? onDismiss;

  /// Nhãn nhỏ cạnh tiêu đề (vd. ưu đãi có thật). null = không hiện.
  final String? badge;

  /// Dòng nhỏ cạnh nút. null = không hiện.
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: context.surfaces.gold,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.brLg,
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -16,
            bottom: -16,
            child: Icon(
              Icons.workspace_premium_rounded,
              size: 96,
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          Padding(
            padding: AppInsets.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: AppSizes.iconMd,
                      ),
                    ),
                    Gaps.h12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  title,
                                  style: context.textStyles.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              if (badge != null) ...[
                                Gaps.h8,
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.s4,
                                    vertical: AppSpacing.s2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    borderRadius: AppRadius.brXs,
                                  ),
                                  child: Text(
                                    badge!,
                                    style: context.textStyles.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Gaps.v4,
                          Text(
                            description,
                            style: context.textStyles.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.95),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onDismiss != null)
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        tooltip: 'Đóng gợi ý',
                        iconSize: AppSizes.iconSm,
                        onPressed: onDismiss,
                      ),
                  ],
                ),
                Gaps.v12,
                Row(
                  mainAxisAlignment: caption == null
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    if (caption != null)
                      Text(
                        caption!,
                        style: context.textStyles.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    FilledButton(
                      onPressed: onUpgrade,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppPalette.amber900,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s16,
                          vertical: AppSpacing.s8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(actionLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
                          Gaps.h4,
                          const Icon(Icons.arrow_forward_rounded, size: AppSizes.iconSm),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
