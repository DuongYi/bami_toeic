import 'package:flutter/material.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';

/// Thẻ nổi bật màu thương hiệu (gradient `surfaces.hero`) cho thông tin quan trọng nhất của màn.
/// Nội dung bên trong dùng màu [AppHeroCard.foreground]. Tối đa 1 thẻ / màn.
class AppHeroCard extends StatelessWidget {
  const AppHeroCard({super.key, required this.child, this.padding = AppInsets.cardLarge});

  final Widget child;
  final EdgeInsetsGeometry padding;

  static Color foreground(BuildContext context) => context.surfaces.onHero;

  @override
  Widget build(BuildContext context) {
    final fg = foreground(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.brXl,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: context.surfaces.hero,
        ),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: fg),
        child: IconTheme.merge(
          data: IconThemeData(color: fg),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
