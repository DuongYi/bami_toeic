import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Lớp nền của app (semantic). Lấy bằng `context.surfaces`.
/// - [background]: nền màn hình (xám nhạt ở light, dark surface ở dark).
/// - [raised]: nền khối nổi (card, ô nhập, nav bar, sheet).
/// - [hairline]: viền mảnh tách khối nổi khỏi nền.
/// - [hero] / [onHero]: gradient + màu chữ của thẻ nổi bật (AppHeroCard, header login).
/// - [gold]: gradient vàng kim dùng cho PRO và chuỗi ngày học.
/// - [rose]: gradient đỏ hồng dùng cho cảnh báo và câu sai.
/// - [emerald]: gradient xanh ngọc dùng cho tăng trưởng điểm và kết quả cao.
/// - [violet]: gradient tím dùng cho tính năng AI và phân tích thông minh.
/// - [cyan]: gradient xanh lam ngọc cho mini-test và tính năng nhanh.
@immutable
class AppSurfaces extends ThemeExtension<AppSurfaces> {
  const AppSurfaces({
    required this.background,
    required this.raised,
    required this.hairline,
    required this.hero,
    required this.onHero,
    this.gold = const [AppPalette.gold500, AppPalette.gold600],
    this.rose = const [AppPalette.rose500, AppPalette.rose600],
    this.emerald = const [AppPalette.emerald600, AppPalette.emerald500],
    this.violet = const [AppPalette.violet600, AppPalette.violet500],
    this.cyan = const [AppPalette.cyan600, AppPalette.cyan500],
  });

  final Color background;
  final Color raised;
  final BorderSide hairline;
  final List<Color> hero;
  final Color onHero;
  final List<Color> gold;
  final List<Color> rose;
  final List<Color> emerald;
  final List<Color> violet;
  final List<Color> cyan;

  @override
  AppSurfaces copyWith({
    Color? background,
    Color? raised,
    BorderSide? hairline,
    List<Color>? hero,
    Color? onHero,
    List<Color>? gold,
    List<Color>? rose,
    List<Color>? emerald,
    List<Color>? violet,
    List<Color>? cyan,
  }) => AppSurfaces(
    background: background ?? this.background,
    raised: raised ?? this.raised,
    hairline: hairline ?? this.hairline,
    hero: hero ?? this.hero,
    onHero: onHero ?? this.onHero,
    gold: gold ?? this.gold,
    rose: rose ?? this.rose,
    emerald: emerald ?? this.emerald,
    violet: violet ?? this.violet,
    cyan: cyan ?? this.cyan,
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
      gold: [for (var i = 0; i < gold.length; i++) Color.lerp(gold[i], other.gold[i], t)!],
      rose: [for (var i = 0; i < rose.length; i++) Color.lerp(rose[i], other.rose[i], t)!],
      emerald: [for (var i = 0; i < emerald.length; i++) Color.lerp(emerald[i], other.emerald[i], t)!],
      violet: [for (var i = 0; i < violet.length; i++) Color.lerp(violet[i], other.violet[i], t)!],
      cyan: [for (var i = 0; i < cyan.length; i++) Color.lerp(cyan[i], other.cyan[i], t)!],
    );
  }
}

/// Font chữ của app: Be Vietnam Pro (thiết kế cho tiếng Việt, SIL OFL).
abstract final class AppTypography {
  static const fontFamily = 'BeVietnamPro';
}
