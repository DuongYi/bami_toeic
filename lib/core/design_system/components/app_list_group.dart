import 'package:flutter/material.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';

/// Nhóm item trong 1 card, ngăn bằng divider mảnh (kiểu inset-grouped).
/// Con thường là ListTile; padding ngang để [ListTileTheme] lo.
class AppListGroup extends StatelessWidget {
  const AppListGroup({super.key, required this.children, this.dividerIndent = AppSpacing.s16});

  final List<Widget> children;

  /// Lề trái của divider (đặt bằng vị trí bắt đầu chữ nếu có leading).
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          for (final (i, child) in children.indexed) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                indent: dividerIndent,
                color: context.colors.outlineVariant.withValues(alpha: 0.5),
              ),
            child,
          ],
        ],
      ),
    );
  }
}
