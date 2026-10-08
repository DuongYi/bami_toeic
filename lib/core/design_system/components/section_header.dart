import 'package:flutter/material.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';

/// Tiêu đề section (đánh dấu heading cho screen reader) + widget phụ bên phải.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing, this.subtitle});

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(header: true, child: Text(title, style: context.textStyles.titleMedium)),
                if (subtitle != null) Text(subtitle!, style: context.textStyles.bodySmall),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
