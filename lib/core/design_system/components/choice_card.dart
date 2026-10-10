import 'package:flutter/material.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';
import 'icon_badge.dart';

/// Thẻ lựa chọn: icon + tiêu đề + mô tả, viền primary khi được chọn.
/// [multiSelect] = true hiển thị ô tick (chọn nhiều), false hiển thị radio (chọn một).
class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.multiSelect = false,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool selected;
  final bool multiSelect;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final indicator = multiSelect
        ? (selected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded)
        : (selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded);

    return Semantics(
      button: true,
      selected: selected,
      child: AnimatedContainer(
        duration: AppMotion.of(context, AppMotion.short),
        decoration: BoxDecoration(
          color: selected ? cs.primaryContainer.withValues(alpha: 0.45) : context.surfaces.raised,
          borderRadius: AppRadius.brLg,
          border: selected ? Border.all(color: cs.primary, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: selected ? 0.08 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: AppRadius.brLg,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s12),
              child: Row(
                children: [
                  if (icon != null) ...[
                    IconBadge(icon: icon!, tone: selected ? AppTone.info : AppTone.neutral),
                    Gaps.h12,
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: context.textStyles.titleMedium),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: context.textStyles.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (trailing != null) ...[Gaps.h8, trailing!],
                  Gaps.h8,
                  Icon(indicator, color: selected ? cs.primary : cs.outline),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
