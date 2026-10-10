import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../routes/app_router.dart';
import '../../../goals/presentation/controllers/study_progress.dart';
import '../../../goals/presentation/widgets/goal_sheet.dart';
import '../controllers/plan_controller.dart';

/// Chuỗi ngày học thật + nhãn PRO (chỉ khi có PRO) + lối tắt Trang cá nhân cho `AppPageHeader.topBar` của các tab.
class HeaderBadges extends ConsumerWidget {
  const HeaderBadges({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(studyProgressProvider).value;
    final isPro = ref.watch(myPlanProvider).value?.isPro ?? false;
    final streak = progress?.streak ?? 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        StreakBadge(
          count: streak,
          active: progress?.activeToday ?? false,
          onTap: () => showGoalSheet(context),
        ),
        if (isPro) ...[Gaps.h8, const ProBadge(mini: true)],
        Gaps.h8,
        IconButton(
          tooltip: 'Trang cá nhân',
          icon: const Icon(Icons.person_outline_rounded),
          onPressed: () => context.push(Routes.profile),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
