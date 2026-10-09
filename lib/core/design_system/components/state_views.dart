import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/app_exception.dart';
import '../theme/context_ext.dart';
import '../tokens/app_dimens.dart';

import 'app_skeleton.dart';

/// Render AsyncValue theo 3 trạng thái chuẩn: skeleton loading / lỗi (có Thử lại) / dữ liệu.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final WidgetBuilder? loading;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => value.when(
    data: data,
    loading: () => loading?.call(context) ?? const AppSkeletonList(),
    error: (e, _) => AppErrorView(message: AppException.from(e).message, onRetry: onRetry),
  );
}

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  @override
  Widget build(BuildContext context) => const AppSkeletonList();
}

class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return _CenteredMessage(
      icon: Icons.cloud_off_rounded,
      iconColor: context.colors.error,
      message: message,
      action: onRetry == null
          ? null
          : FilledButton.tonal(onPressed: onRetry, child: const Text('Thử lại')),
    );
  }
}

/// Trạng thái rỗng: nói lý do + (tuỳ chọn) hành động tiếp theo.
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({super.key, required this.icon, required this.message, this.action});

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => _CenteredMessage(
    icon: icon,
    iconColor: context.colors.onSurfaceVariant,
    message: message,
    action: action,
  );
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.icon,
    required this.iconColor,
    required this.message,
    this.action,
  });

  final IconData icon;
  final Color iconColor;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSizes.iconXl, color: iconColor),
            Gaps.v12,
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[Gaps.v16, action!],
          ],
        ),
      ),
    );
  }
}

/// Bọc nội dung không cuộn (Empty/Error) để vẫn kéo-làm-mới được trong RefreshIndicator.
class ScrollableFill extends StatelessWidget {
  const ScrollableFill({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    slivers: [SliverFillRemaining(hasScrollBody: false, child: child)],
  );
}
