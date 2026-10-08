import 'package:flutter/material.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';
import 'icon_badge.dart';

/// Thẻ chỉ số: icon màu + giá trị lớn + nhãn. Xếp 2 thẻ / hàng bằng [StatGrid].
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.tone = AppTone.info,
  });

  final IconData icon;
  final String value;
  final String label;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '$label: $value',
      excludeSemantics: true,
      child: Card(
        child: Padding(
          padding: AppInsets.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBadge(icon: icon, tone: tone, size: AppSizes.badgeSm),
              Gaps.v12,
              Text(value, style: context.textStyles.headlineSmall),
              Text(
                label,
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lưới 2 cột, các ô trong cùng hàng cao bằng nhau.
class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: children[i]),
              Gaps.h12,
              Expanded(child: i + 1 < children.length ? children[i + 1] : const SizedBox()),
            ],
          ),
        ),
      );
      if (i + 2 < children.length) rows.add(Gaps.v12);
    }
    return Column(children: rows);
  }
}
