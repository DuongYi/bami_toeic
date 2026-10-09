import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';

class AppTabItem {
  const AppTabItem({required this.icon, required this.selectedIcon, required this.label});

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Thanh tab nổi kiểu iOS 26 "Liquid Glass" (như App Store): viên thuốc kính mờ cách mép,
/// tab đang chọn có viên sáng trượt theo, icon + nhãn tô màu primary.
///
/// Dùng làm `Scaffold.bottomNavigationBar` với `extendBody: true` để nội dung cuộn chạy
/// bên dưới lớp kính. Khi đó `MediaQuery.paddingOf(context).bottom` của body đã gồm chiều
/// cao thanh → danh sách trong tab phải chừa khoảng này ở cuối (xem [AppGlassTabBar.inset]).
class AppGlassTabBar extends StatelessWidget {
  const AppGlassTabBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AppTabItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double barHeight = 64;
  static const double _sideMargin = AppSpacing.s24;
  static const double _gap = AppSpacing.s8;
  static const double _innerPadding = AppSpacing.s4;
  static const double _blurSigma = 24;

  /// Khoảng cần chừa ở cuối danh sách trong tab để mục cuối không bị thanh che.
  static double inset(BuildContext context) => MediaQuery.paddingOf(context).bottom;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    final radius = BorderRadius.circular(barHeight / 2);
    final duration = AppMotion.of(context, AppMotion.medium);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        _sideMargin,
        _gap,
        _sideMargin,
        // Máy có thanh home: đặt sát vùng an toàn như iOS; máy không có: chừa khoảng nhỏ.
        safeBottom > 0 ? safeBottom : _gap * 2,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: dark ? 0.4 : 0.12),
              blurRadius: AppSpacing.s24,
              offset: const Offset(0, AppSpacing.s8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                // Kính: nền bán trong suốt + viền sáng mảnh
                color: (dark ? cs.surfaceContainerHigh : cs.surface).withValues(
                  alpha: dark ? 0.62 : 0.68,
                ),
                border: Border.all(
                  color: (dark ? cs.onSurface : cs.outlineVariant).withValues(
                    alpha: dark ? 0.14 : 0.5,
                  ),
                  width: 0.5,
                ),
              ),
              child: SizedBox(
                height: barHeight,
                child: Padding(
                  padding: const EdgeInsets.all(_innerPadding),
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final w = c.maxWidth / items.length;
                      return Stack(
                        children: [
                          // Viên sáng sau tab đang chọn
                          AnimatedPositioned(
                            duration: duration,
                            curve: AppMotion.emphasized,
                            left: w * currentIndex,
                            top: 0,
                            bottom: 0,
                            width: w,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: radius,
                                color: cs.onSurface.withValues(alpha: dark ? 0.12 : 0.07),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              for (final (i, item) in items.indexed)
                                Expanded(
                                  child: _TabButton(
                                    item: item,
                                    selected: i == currentIndex,
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      onTap(i);
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatefulWidget {
  const _TabButton({required this.item, required this.selected, required this.onTap});

  final AppTabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  bool _pressed = false;

  void _press(bool v) => setState(() => _pressed = v);

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final color = widget.selected ? cs.primary : cs.onSurface;
    final duration = AppMotion.of(context, AppMotion.short);
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.item.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _press(true),
        onTapCancel: () => _press(false),
        onTapUp: (_) => _press(false),
        onTap: widget.onTap,
        // iOS không có gợn sóng: nhấn → co nhẹ
        child: AnimatedScale(
          scale: _pressed ? 0.9 : 1,
          duration: duration,
          curve: AppMotion.standard,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: duration,
                child: Icon(
                  widget.selected ? widget.item.selectedIcon : widget.item.icon,
                  key: ValueKey(widget.selected),
                  color: color,
                  size: AppSizes.iconMd,
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                widget.item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.labelSmall?.copyWith(
                  color: color,
                  fontWeight: widget.selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
