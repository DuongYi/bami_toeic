import 'package:flutter/material.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';

/// Bản sliver, dựng LƯỜI của [AppListGroup]: cùng kiểu card viền mảnh + divider,
/// nhưng chỉ dựng các dòng đang hiện → dùng cho danh sách dài (hàng trăm/nghìn dòng)
/// trong `CustomScrollView`. Danh sách ngắn (vài dòng) dùng [AppListGroup].
class AppSliverListGroup extends StatelessWidget {
  const AppSliverListGroup({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.dividerIndent = AppSpacing.s16,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// Lề trái của divider (đặt bằng vị trí bắt đầu chữ nếu có leading).
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    final card = Theme.of(context).cardTheme;
    final shape = card.shape ?? const RoundedRectangleBorder(borderRadius: AppRadius.brLg);
    final radius = shape is RoundedRectangleBorder && shape.borderRadius is BorderRadius
        ? shape.borderRadius as BorderRadius
        : AppRadius.brLg;
    final divider = Divider(
      height: 1,
      thickness: 1,
      indent: dividerIndent,
      color: context.colors.outlineVariant.withValues(alpha: 0.5),
    );
    return DecoratedSliver(
      // Nền + viền card vẽ theo chiều dài cả sliver, không cần dựng hết các dòng.
      decoration: ShapeDecoration(color: card.color ?? context.colors.surface, shape: shape),
      sliver: SliverList.separated(
        itemCount: itemCount,
        separatorBuilder: (_, _) => divider,
        itemBuilder: (context, i) => Material(
          // Gợn sóng khi chạm vẽ trên nền card (không bị nền che), bo theo góc ở 2 đầu.
          type: MaterialType.transparency,
          borderRadius: BorderRadius.only(
            topLeft: i == 0 ? radius.topLeft : Radius.zero,
            topRight: i == 0 ? radius.topRight : Radius.zero,
            bottomLeft: i == itemCount - 1 ? radius.bottomLeft : Radius.zero,
            bottomRight: i == itemCount - 1 ? radius.bottomRight : Radius.zero,
          ),
          clipBehavior: Clip.antiAlias,
          child: itemBuilder(context, i),
        ),
      ),
    );
  }
}
