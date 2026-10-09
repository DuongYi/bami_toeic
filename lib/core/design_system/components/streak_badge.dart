import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';
import '../theme/context_ext.dart';

/// Huy hiệu chuỗi ngày học liên tục (Streak 🔥) tạo động lực học tập.
class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key, required this.count, this.active = true, this.onTap});

  final int count;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tone = active ? AppTone.warning : AppTone.neutral;
    final tc = tone.colorsOf(context);

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
      decoration: BoxDecoration(
        color: tc.container,
        borderRadius: AppRadius.brFull,
        border: Border.all(color: tc.main.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department_rounded, size: AppSizes.iconSm, color: tc.main),
          const SizedBox(width: AppSpacing.s4),
          Text(
            '$count ngày',
            style: context.textStyles.labelMedium?.copyWith(
              color: tc.onContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return Semantics(label: 'Chuỗi $count ngày học liên tiếp', child: badge);
    }

    return Semantics(
      button: true,
      label: 'Chuỗi $count ngày học liên tiếp. Bấm để xem chi tiết.',
      child: InkWell(onTap: onTap, borderRadius: AppRadius.brFull, child: badge),
    );
  }
}
