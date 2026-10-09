import 'package:flutter/material.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';

/// Tiêu đề lớn cho màn gốc của tab (thay AppBar). Đặt ở đầu nội dung cuộn, trong SafeArea.
/// Màn con (có nút Back) vẫn dùng AppBar.
/// Hỗ trợ cả bố cục 1 tầng (inline) và 2 tầng (khi có [topBar] như HUD gamification / profile).
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.overline,
    this.subtitle,
    this.leading,
    this.trailing,
    this.topBar,
    this.compact = false,
  });

  final String title;

  /// Dòng nhỏ phía trên tiêu đề (vd. "Xin chào 👋" hoặc "LỘ TRÌNH ETS").
  final String? overline;

  /// Dòng chú thích / động lực học tập phía dưới tiêu đề.
  final String? subtitle;

  /// Widget đặt trước tiêu đề (vd. Avatar, icon thương hiệu, nút back tuỳ chỉnh).
  final Widget? leading;

  /// Widget đặt sau tiêu đề (chỉ dùng khi tiêu đề ngắn hoặc có 1 action nhỏ).
  final Widget? trailing;

  /// Thanh điều hướng / trạng thái nằm phía trên tiêu đề (vd: Profile + Gamification HUD).
  /// Khi có [topBar], tiêu đề sẽ được hiển thị trọn vẹn 100% chiều rộng bên dưới,
  /// không bao giờ bị chèn ép hay co rút dòng.
  final Widget? topBar;

  /// Khoảng cách gọn gàng hơn.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final titleSection = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[
          leading!,
          Gaps.h12,
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (overline != null) ...[
                Text(
                  overline!,
                  style: context.textStyles.labelMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
              ],
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: context.textStyles.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              if (subtitle != null) ...[
                Gaps.v4,
                Text(
                  subtitle!,
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          Gaps.h12,
          trailing!,
        ],
      ],
    );

    final topPadding = compact ? AppSpacing.s4 : AppSpacing.s8;
    final bottomPadding = compact ? AppSpacing.s8 : AppSpacing.s16;

    if (topBar != null) {
      return Padding(
        padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            topBar!,
            Gaps.v16,
            titleSection,
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: titleSection,
    );
  }
}

