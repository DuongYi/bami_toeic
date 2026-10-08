import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';

/// Vòng tiến độ tròn với nội dung ở giữa (điểm, %, số câu).
/// Không truyền [tone] thì màu theo [AppTone.fromRatio].
class ScoreRing extends StatelessWidget {
  const ScoreRing({
    super.key,
    required this.value,
    required this.child,
    this.size = AppSizes.ringLg,
    this.strokeWidth = AppSizes.ringStrokeLg,
    this.tone,
    this.trackColor,
    this.color,
    this.semanticLabel,
  });

  final double value;
  final Widget child;
  final double size;
  final double strokeWidth;
  final AppTone? tone;

  /// Màu nền của vòng (mặc định container của tone).
  final Color? trackColor;

  /// Màu vòng (mặc định main của tone). Dùng khi đặt trên nền màu, vd. AppHeroCard.
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = (tone ?? AppTone.fromRatio(value)).colorsOf(context);
    return Semantics(
      label: semanticLabel,
      value: '${(value * 100).round()}%',
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value.clamp(0, 1)),
              duration: AppMotion.of(context, AppMotion.long),
              curve: AppMotion.emphasized,
              builder: (context, v, _) => CircularProgressIndicator(
                value: v,
                strokeWidth: strokeWidth,
                strokeCap: StrokeCap.round,
                color: color ?? c.main,
                backgroundColor: trackColor ?? c.container,
              ),
            ),
            Center(child: ExcludeSemantics(child: child)),
          ],
        ),
      ),
    );
  }
}
