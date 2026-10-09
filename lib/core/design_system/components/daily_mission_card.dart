import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';
import 'app_card.dart';
import 'app_progress_bar.dart';
import '../theme/context_ext.dart';

class DailyMissionItem {
  const DailyMissionItem({required this.title, required this.isDone, this.trailing});

  final String title;
  final bool isDone;
  final String? trailing;
}

/// Thẻ nhiệm vụ học tập mỗi ngày (Daily Mission) giúp duy trì thói quen học tập.
class DailyMissionCard extends StatelessWidget {
  const DailyMissionCard({
    super.key,
    required this.completed,
    required this.total,
    required this.items,
    this.onTap,
  });

  final int completed;
  final int total;
  final List<DailyMissionItem> items;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : (completed / total).clamp(0.0, 1.0);
    final isAllDone = completed >= total && total > 0;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isAllDone ? Icons.check_circle_rounded : Icons.flag_circle_rounded,
                color: isAllDone ? context.appColors.success : context.colors.primary,
                size: AppSizes.iconMd,
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: Text(
                  'Mục tiêu hôm nay',
                  style: context.textStyles.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: AppSpacing.s2,
                ),
                decoration: BoxDecoration(
                  color: isAllDone
                      ? context.appColors.successContainer
                      : context.colors.primaryContainer,
                  borderRadius: AppRadius.brFull,
                ),
                child: Text(
                  '$completed/$total',
                  style: context.textStyles.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isAllDone
                        ? context.appColors.onSuccessContainer
                        : context.colors.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          AppProgressBar(value: ratio, tone: isAllDone ? AppTone.success : AppTone.info),
          const SizedBox(height: AppSpacing.s12),
          for (final item in items) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
              child: Row(
                children: [
                  Icon(
                    item.isDone
                        ? Icons.check_circle_outline_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: AppSizes.iconSm,
                    color: item.isDone
                        ? context.appColors.success
                        : context.colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: Text(
                      item.title,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: item.isDone
                            ? context.colors.onSurfaceVariant
                            : context.colors.onSurface,
                        decoration: item.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  if (item.trailing != null)
                    Text(
                      item.trailing!,
                      style: context.textStyles.labelSmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
