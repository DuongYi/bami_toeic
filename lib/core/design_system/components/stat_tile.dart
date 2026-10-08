import 'package:flutter/material.dart';

import '../theme/context_ext.dart';

/// Ô chỉ số: số lớn + nhãn nhỏ. Đặt trong Row, mỗi ô tự Expanded.
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.value, required this.label, this.highlight = false});

  final String value;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        container: true,
        label: '$label: $value',
        excludeSemantics: true,
        child: Column(
          children: [
            Text(
              value,
              style: context.textStyles.headlineSmall?.copyWith(
                color: highlight ? context.colors.primary : null,
              ),
            ),
            Text(label, style: context.textStyles.labelMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
