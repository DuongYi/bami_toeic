import 'package:flutter/material.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';

/// Khung thông báo nằm trong nội dung (lỗi form, cảnh báo, gợi ý).
/// Được đọc ngay bởi screen reader (liveRegion) khi xuất hiện.
class AppBanner extends StatelessWidget {
  const AppBanner({super.key, required this.message, this.tone = AppTone.info, this.icon});

  final String message;
  final AppTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = tone.colorsOf(context);
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s12),
        decoration: BoxDecoration(color: c.container, borderRadius: AppRadius.brMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon ?? tone.icon, size: AppSizes.iconMd, color: c.onContainer),
            Gaps.h12,
            Expanded(
              child: Text(
                message,
                style: context.textStyles.bodyMedium?.copyWith(color: c.onContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
