import 'package:flutter/material.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';

/// Ô số câu hỏi (bảng chọn câu, bảng đáp án).
/// - [tone] != null: tô theo kết quả (đúng/sai/bỏ trống).
/// - [filled]: đã trả lời (khi đang làm bài).
/// - [current]: câu đang xem.
/// - [flagged]: câu được đánh dấu để xem lại (icon cờ ở góc – không chỉ dựa vào màu).
class NumberCell extends StatelessWidget {
  const NumberCell({
    super.key,
    required this.number,
    this.tone,
    this.filled = false,
    this.current = false,
    this.flagged = false,
    this.onTap,
    this.semanticLabel,
  });

  final int number;
  final AppTone? tone;
  final bool filled;
  final bool current;
  final bool flagged;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final Color bg, fg;
    Color? border;
    if (tone != null) {
      final c = tone!.colorsOf(context);
      bg = c.container;
      fg = c.onContainer;
      border = c.main;
    } else {
      bg = filled ? cs.primary : cs.surfaceContainerHighest;
      fg = filled ? cs.onPrimary : cs.onSurface;
    }
    if (current) border = cs.tertiary;

    return Semantics(
      button: onTap != null,
      label: semanticLabel ?? 'Câu $number',
      excludeSemantics: true,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brMd,
          side: border == null ? BorderSide.none : BorderSide(color: border, width: 2),
        ),
        child: InkWell(
          borderRadius: AppRadius.brMd,
          onTap: onTap,
          child: SizedBox(
            width: AppSizes.numberCell,
            height: AppSizes.numberCellHeight,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    '$number',
                    style: context.textStyles.labelLarge?.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (flagged)
                  Positioned(
                    top: AppSpacing.s2,
                    right: AppSpacing.s2,
                    child: Icon(
                      Icons.flag_rounded,
                      size: AppSizes.iconXs,
                      color: AppTone.warning.colorsOf(context).main,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
