import 'package:flutter/material.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';

/// Thanh đáy cố định chứa CTA / điều hướng (nền nổi + viền trên mảnh + safe area).
/// Đặt vào `Scaffold.bottomNavigationBar`.
/// Tự co theo chiều cao nội dung (IntrinsicHeight), nên con dùng Column/Center/Expanded vẫn an toàn.
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.surfaces.raised,
        border: Border(top: context.surfaces.hairline),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.s12,
            AppSpacing.screen,
            AppSpacing.s12,
          ),
          child: IntrinsicHeight(child: child),
        ),
      ),
    );
  }
}
