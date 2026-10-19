import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_system/design_system.dart';
import '../../core/home_widget/home_widget_service.dart';
import '../../core/notifications/reminder_service.dart';
import '../goals/presentation/controllers/habit_sync.dart';

/// Khung 4 tab. Thanh tab nổi kiểu iOS 26 (kính mờ); nội dung cuộn chạy bên dưới thanh.
/// Theo dõi tình hình học để cập nhật nhắc học và widget màn hình chính.
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(habitStatusProvider, (_, next) {
      if (next.value case final s?) {
        ref.read(reminderServiceProvider).updateStatus(s);
        ref.read(homeWidgetServiceProvider).update(s);
      }
    });
    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: AppGlassTabBar(
        currentIndex: shell.currentIndex,
        onTap: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        items: const [
          AppTabItem(icon: Icons.quiz_outlined, selectedIcon: Icons.quiz, label: 'Đề thi'),
          AppTabItem(icon: Icons.style_outlined, selectedIcon: Icons.style, label: 'Từ vựng'),
          AppTabItem(icon: Icons.insights_outlined, selectedIcon: Icons.insights, label: 'Tiến độ'),
          AppTabItem(
            icon: Icons.leaderboard_outlined,
            selectedIcon: Icons.leaderboard,
            label: 'Xếp hạng',
          ),
        ],
      ),
    );
  }
}
