import 'package:flutter/material.dart';

/// Lớp nền của app (semantic). Lấy bằng `context.surfaces`.
/// - [background]: nền màn hình (xám nhạt ở light).
/// - [raised]: nền khối nổi (card, ô nhập, nav bar, sheet).
/// - [hairline]: viền mảnh tách khối nổi khỏi nền.
/// - [hero] / [onHero]: gradient + màu chữ của thẻ nổi bật (AppHeroCard, header login).
@immutable
class AppSurfaces extends ThemeExtension<AppSurfaces> {
  const AppSurfaces({
    required this.background,
    required this.raised,
    required this.hairline,
    required this.hero,
    required this.onHero,
  });

  final Color background;
  final Color raised;
  final BorderSide hairline;
  final List<Color> hero;
  final Color onHero;

  @override
  AppSurfaces copyWith({
    Color? background,
    Color? raised,
    BorderSide? hairline,
    List<Color>? hero,
    Color? onHero,
  }) => AppSurfaces(
    background: background ?? this.background,
    raised: raised ?? this.raised,
    hairline: hairline ?? this.hairline,
    hero: hero ?? this.hero,
    onHero: onHero ?? this.onHero,
  );

  @override
  AppSurfaces lerp(AppSurfaces? other, double t) {
    if (other == null) return this;
    return AppSurfaces(
      background: Color.lerp(background, other.background, t)!,
      raised: Color.lerp(raised, other.raised, t)!,
      hairline: BorderSide.lerp(hairline, other.hairline, t),
      hero: [for (var i = 0; i < hero.length; i++) Color.lerp(hero[i], other.hero[i], t)!],
      onHero: Color.lerp(onHero, other.onHero, t)!,
    );
  }
}

/// Font chữ của app: Be Vietnam Pro (thiết kế cho tiếng Việt, SIL OFL).
abstract final class AppTypography {
  static const fontFamily = 'BeVietnamPro';
}
