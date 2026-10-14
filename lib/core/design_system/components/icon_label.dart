import 'package:flutter/material.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';

/// Icon nhỏ + chữ trên một dòng (thông tin phụ: "120 phút", "200 câu"). Thay cho emoji đầu dòng.
/// Màu mặc định: chữ phụ (`onSurfaceVariant`); truyền [color] khi đặt trên nền hero.
class IconLabel extends StatelessWidget {
  const IconLabel({super.key, required this.icon, required this.label, this.style, this.color});

  final IconData icon;
  final String label;

  /// Mặc định `bodySmall` đậm vừa.
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.colors.onSurfaceVariant;
    final textStyle = (style ?? context.textStyles.bodySmall?.copyWith(fontWeight: FontWeight.w500))
        ?.copyWith(color: c);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSizes.iconXs, color: c),
        const SizedBox(width: AppSpacing.s4),
        Flexible(child: Text(label, style: textStyle)),
      ],
    );
  }
}
