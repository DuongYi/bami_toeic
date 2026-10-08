import 'package:flutter/material.dart';

import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';
import '../tokens/app_tone.dart';

/// Hộp thoại xác nhận chuẩn. [destructive] = hành động phá huỷ (xoá, thoát mất dữ liệu):
/// nút xác nhận tô màu error. Trả về true nếu người dùng xác nhận.
Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  required String confirmLabel,
  String cancelLabel = 'Huỷ',
  bool destructive = false,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(cancelLabel)),
        destructive
            ? TextButton(
                style: TextButton.styleFrom(foregroundColor: ctx.colors.error),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(confirmLabel),
              )
            : FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(confirmLabel)),
      ],
    ),
  );
  return ok ?? false;
}

/// Snackbar chuẩn (floating, có icon theo tone, tuỳ chọn 1 hành động như "Thử lại", "Hoàn tác").
void showAppSnackBar(
  BuildContext context,
  String message, {
  AppTone tone = AppTone.neutral,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  showAppSnackBarOn(
    ScaffoldMessenger.of(context),
    message,
    tone: tone,
    actionLabel: actionLabel,
    onAction: onAction,
  );
}

/// Như [showAppSnackBar] nhưng dùng messenger đã lấy trước (khi widget có thể bị gỡ sau await).
void showAppSnackBarOn(
  ScaffoldMessengerState messenger,
  String message, {
  AppTone tone = AppTone.neutral,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (tone != AppTone.neutral) ...[
              Icon(tone.icon, color: messenger.context.colors.onInverseSurface),
              Gaps.h12,
            ],
            Expanded(child: Text(message)),
          ],
        ),
        action: actionLabel == null
            ? null
            : SnackBarAction(label: actionLabel, onPressed: onAction ?? () {}),
      ),
    );
}

/// Bottom sheet chuẩn: có drag handle, cuộn được, đẩy lên khi bàn phím mở.
Future<T?> showAppBottomSheet<T>(BuildContext context, {required WidgetBuilder builder}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
      child: builder(ctx),
    ),
  );
}
