import 'package:flutter/material.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';

/// Tiêu đề lớn cho màn gốc của tab (thay AppBar). Đặt ở đầu nội dung cuộn, trong SafeArea.
/// Màn con (có nút Back) vẫn dùng AppBar.
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({super.key, required this.title, this.overline, this.trailing});

  final String title;

  /// Dòng nhỏ phía trên tiêu đề (vd. "Xin chào 👋").
  final String? overline;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s8, bottom: AppSpacing.s16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (overline != null)
                  Text(
                    overline!,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                Semantics(
                  header: true,
                  child: Text(title, style: context.textStyles.headlineMedium),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
