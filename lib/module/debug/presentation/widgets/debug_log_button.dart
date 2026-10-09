import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/logging/app_log.dart';

/// Nút nổi nhỏ (chỉ bản debug/profile) mở màn Nhật ký debug; hiện số lỗi.
/// Nhấn giữ để ẩn trong phiên chạy này.
class DebugLogButton extends StatefulWidget {
  const DebugLogButton({super.key, required this.child, required this.onOpen});

  final Widget child;
  final VoidCallback onOpen;

  @override
  State<DebugLogButton> createState() => _DebugLogButtonState();
}

class _DebugLogButtonState extends State<DebugLogButton> {
  bool _hidden = false;

  @override
  Widget build(BuildContext context) {
    if (_hidden) return widget.child;
    return Stack(
      children: [
        widget.child,
        Positioned(
          left: AppSpacing.s8,
          bottom: AppSpacing.fabClearance,
          child: SafeArea(
            child: ListenableBuilder(
              listenable: AppLog.instance,
              builder: (context, _) {
                final errors = AppLog.instance.errorCount;
                // Nằm ngoài Navigator (MaterialApp.builder) → không có Overlay, không dùng Tooltip.
                return Semantics(
                  button: true,
                  label: 'Nhật ký debug, $errors lỗi. Nhấn giữ để ẩn',
                  child: GestureDetector(
                    onLongPress: () => setState(() => _hidden = true),
                    child: Badge(
                      isLabelVisible: errors > 0,
                      label: Text('$errors'),
                      child: FloatingActionButton.small(
                        heroTag: 'debug-log',
                        onPressed: widget.onOpen,
                        backgroundColor: errors > 0
                            ? context.colors.errorContainer
                            : context.colors.surfaceContainerHighest,
                        foregroundColor: errors > 0
                            ? context.colors.onErrorContainer
                            : context.colors.onSurfaceVariant,
                        child: const Icon(Icons.receipt_long_rounded),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
