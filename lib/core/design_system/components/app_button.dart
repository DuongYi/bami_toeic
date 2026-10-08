import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';

/// Nút hành động chính (CTA) của màn hình: cao 52, mặc định full-width, có trạng thái loading.
/// Mỗi màn tối đa 1 AppPrimaryButton. Hành động phụ dùng `FilledButton.tonal` / `TextButton`.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      minimumSize: Size(expand ? double.infinity : AppSizes.touchTarget, AppSizes.buttonLarge),
    );
    final child = loading
        ? const SizedBox.square(
            dimension: AppSizes.spinnerSm,
            child: CircularProgressIndicator(strokeWidth: AppSizes.strokeThin),
          )
        : Text(label);
    final onTap = loading ? null : onPressed;

    return icon == null || loading
        ? FilledButton(style: style, onPressed: onTap, child: child)
        : FilledButton.icon(style: style, onPressed: onTap, icon: Icon(icon), label: child);
  }
}

/// Spinner nhỏ đặt trong nút / AppBar khi đang xử lý.
class AppInlineSpinner extends StatelessWidget {
  const AppInlineSpinner({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.square(
    dimension: AppSizes.spinnerSm,
    child: CircularProgressIndicator(strokeWidth: AppSizes.strokeThin),
  );
}
