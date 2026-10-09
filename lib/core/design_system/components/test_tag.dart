import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';
import '../theme/context_ext.dart';

enum TestTagTone { neutral, info, success, warning, danger }

/// Thẻ phân loại đề thi (nguồn đề, độ khó, tính năng đặc biệt).
class TestTag extends StatelessWidget {
  const TestTag({super.key, required this.label, this.icon, this.tone = TestTagTone.neutral});

  final String label;
  final IconData? icon;
  final TestTagTone tone;

  AppTone get _appTone => switch (tone) {
    TestTagTone.neutral => AppTone.neutral,
    TestTagTone.info => AppTone.info,
    TestTagTone.success => AppTone.success,
    TestTagTone.warning => AppTone.warning,
    TestTagTone.danger => AppTone.danger,
  };

  @override
  Widget build(BuildContext context) {
    final tc = _appTone.colorsOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s2),
      decoration: BoxDecoration(
        color: tc.container,
        borderRadius: AppRadius.brXs,
        border: Border.all(color: tc.main.withValues(alpha: 0.25), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppSizes.iconXs, color: tc.main),
            const SizedBox(width: AppSpacing.s4),
          ],
          Text(
            label,
            style: context.textStyles.labelSmall?.copyWith(
              color: tc.onContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
