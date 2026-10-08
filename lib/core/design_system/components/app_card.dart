import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';

/// Card chuẩn: nền surfaceContainerLow, bo lg, padding 16.
/// [tone] tô nền theo container của tone (vd. thẻ nổi bật dùng `AppTone.info`).
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppInsets.card,
    this.onTap,
    this.tone,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final AppTone? tone;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Card(
      color: tone?.colorsOf(context).container,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}
