import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_system/design_system.dart';

/// Khung 4 tab. Thanh tab nổi kiểu iOS 26 (kính mờ); nội dung cuộn chạy bên dưới thanh.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
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
