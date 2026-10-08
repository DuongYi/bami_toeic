import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';

/// Icon đặt trong ô vuông bo góc có nền màu theo tone. Dùng làm leading của item, card thống kê.
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    this.tone = AppTone.info,
    this.size = AppSizes.badgeMd,
  });

  final IconData icon;
  final AppTone tone;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = tone.colorsOf(context);
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: c.container, borderRadius: AppRadius.brMd),
        child: Icon(icon, color: c.onContainer, size: size * 0.55),
      ),
    );
  }
}
