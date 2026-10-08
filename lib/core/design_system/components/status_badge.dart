import 'package:flutter/material.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';

/// Nhãn trạng thái nhỏ có viền: "Mới", "Ôn", "3d"…
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, this.tone = AppTone.neutral, this.icon});

  final String label;
  final AppTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = tone.colorsOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s2),
      decoration: BoxDecoration(
        border: Border.all(color: c.main),
        borderRadius: AppRadius.brSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: AppSizes.iconSm, color: c.main), Gaps.h4],
          Text(label, style: context.textStyles.labelSmall?.copyWith(color: c.main)),
        ],
      ),
    );
  }
}

/// Icon trạng thái theo tone (đúng/sai/cảnh báo) – luôn có semanticLabel.
class ToneIcon extends StatelessWidget {
  const ToneIcon({super.key, required this.tone, required this.semanticLabel, this.size});

  final AppTone tone;
  final String semanticLabel;
  final double? size;

  @override
  Widget build(BuildContext context) => Icon(
    tone.icon,
    color: tone.colorsOf(context).main,
    size: size ?? AppSizes.iconMd,
    semanticLabel: semanticLabel,
  );
}
