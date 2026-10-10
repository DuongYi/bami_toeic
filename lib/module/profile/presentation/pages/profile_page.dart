import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../helper/format.dart';
import '../../../../routes/app_router.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../goals/data/study_store.dart';
import '../../../goals/presentation/controllers/study_progress.dart';
import '../../../goals/presentation/widgets/goal_sheet.dart';
import '../../../leaderboard/presentation/controllers/leaderboard_controller.dart';
import '../../../leaderboard/presentation/widgets/leaderboard_profile_sheet.dart';
import '../../../plan/presentation/controllers/plan_controller.dart';
import '../../../plan/presentation/widgets/pro_sheet.dart';
import '../../../test/presentation/controllers/test_providers.dart';
import '../../../vocab/presentation/controllers/vocab_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  String _displayName(String? name, String? email) {
    if (name != null && name.trim().isNotEmpty) return name.trim();
    if (email == null || email.isEmpty) return 'Học viên Bami';
    final raw = email.split('@').first;
    if (raw.isEmpty) return 'Học viên Bami';
    return raw[0].toUpperCase() + raw.substring(1);
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final ok = await showAppConfirmDialog(
      context,
      title: 'Đăng xuất?',
      message: 'Bạn sẽ cần nhập lại email và mật khẩu để tiếp tục học.',
      confirmLabel: 'Đăng xuất',
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    await ref.read(authControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider).value;
    final email = auth?.user.email;
    final plan = ref.watch(myPlanProvider).value;
    final progress = ref.watch(studyProgressProvider).value;
    final lbProfile = ref.watch(myLeaderboardProfileProvider).value;
    final attempts = ref.watch(attemptsProvider).value ?? const [];
    final vocab = ref.watch(vocabOverviewProvider).value;

    final displayName = _displayName(lbProfile?.displayName, email);
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'B';
    final streak = progress?.streak ?? 0;
    final isStreakActive = progress?.activeToday ?? false;

    // Tính điểm cao nhất từ các bài thi
    final completedAttempts = attempts.where((a) => !a.isMistakeReview).toList();
    final highestScore = completedAttempts.isEmpty
        ? null
        : completedAttempts.map((a) => a.totalScore).reduce(math.max);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trang cá nhân',
          style: context.textStyles.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Cài đặt',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(Routes.settings),
          ),
        ],
      ),
      body: FutureBuilder<GoalSettings>(
        future: ref.watch(studyStoreProvider).readGoals(),
        builder: (context, snapshot) {
          final goals = snapshot.data ?? const GoalSettings();
          final targetScore = goals.targetScore;
          final examDate = goals.examDate;

          final daysLeft = examDate == null
              ? null
              : examDate.difference(DateTime.now()).inDays + 1;

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.s8,
              AppSpacing.screen,
              AppSpacing.s48,
            ),
            children: [
              // 1. Thẻ thông tin học viên & Avatar
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: AppSizes.iconHero / 2,
                          backgroundColor: context.colors.primaryContainer,
                          foregroundColor: context.colors.onPrimaryContainer,
                          child: Text(
                            initial,
                            style: context.textStyles.headlineSmall?.copyWith(
                              color: context.colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Gaps.h16,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      displayName,
                                      style: context.textStyles.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Gaps.h8,
                                  IconButton(
                                    tooltip: 'Đổi tên hiển thị',
                                    icon: const Icon(Icons.edit_outlined, size: AppSizes.iconSm),
                                    onPressed: () => showLeaderboardProfileSheet(context),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ],
                              ),
                              Text(
                                email ?? 'Chưa cập nhật email',
                                style: context.textStyles.bodyMedium?.copyWith(
                                  color: context.colors.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Gaps.v8,
                              Wrap(
                                spacing: AppSpacing.s8,
                                runSpacing: AppSpacing.s4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  if (plan?.isAdmin ?? false)
                                    const StatusBadge(
                                      label: 'Quản trị viên',
                                      tone: AppTone.info,
                                      icon: Icons.admin_panel_settings_outlined,
                                    )
                                  else if (plan?.isPro ?? false)
                                    const ProBadge()
                                  else
                                    const StatusBadge(
                                      label: 'Gói Miễn Phí',
                                      tone: AppTone.neutral,
                                      icon: Icons.school_outlined,
                                    ),
                                  StreakBadge(
                                    count: streak,
                                    active: isStreakActive,
                                    onTap: () => showGoalSheet(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gaps.v16,

              // 2. Thẻ gói thành viên PRO / Quản trị viên
              if (plan?.isAdmin ?? false)
                AppCard(
                  tone: AppTone.info,
                  onTap: () => context.push(Routes.adminUsers),
                  child: Row(
                    children: [
                      const IconBadge(
                        icon: Icons.admin_panel_settings_rounded,
                        tone: AppTone.info,
                      ),
                      Gaps.h12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bảng điều khiển Quản trị viên',
                              style: context.textStyles.titleMedium,
                            ),
                            Text(
                              'Cấp quyền, gia hạn hoặc thu hồi gói PRO cho học viên',
                              style: context.textStyles.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                )
              else if (plan?.isPro ?? false)
                AppCard(
                  tone: AppTone.warning,
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  child: Row(
                    children: [
                      const IconBadge(
                        icon: Icons.workspace_premium_rounded,
                        tone: AppTone.warning,
                      ),
                      Gaps.h12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Đặc quyền Bami PRO',
                                  style: context.textStyles.titleMedium,
                                ),
                                Gaps.h8,
                                const ProBadge(mini: true),
                              ],
                            ),
                            Gaps.v4,
                            Text(
                              plan?.proUntil != null
                                  ? 'Đang hoạt động · Đến ${Fmt.date(plan!.proUntil!.toLocal())}'
                                  : 'Gói Bami PRO không giới hạn',
                              style: context.textStyles.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Chi tiết gói',
                        icon: const Icon(Icons.info_outline_rounded),
                        onPressed: () => showProSheet(context),
                      ),
                    ],
                  ),
                )
              else
                UpgradeBanner(
                  title: 'Nâng cấp Bami PRO',
                  description:
                      'Mở khoá toàn bộ đề ETS 2024, giải thích chi tiết câu hỏi và phân tích bẫy đề thi AI.',
                  onUpgrade: () => showProSheet(context),
                ),
              Gaps.v24,

              // 3. Bento Grid: Thống kê học tập
              const SectionHeader(
                title: 'Thống kê học tập',
                subtitle: 'Kết quả rèn luyện và tích lũy kiến thức của bạn',
              ),
              StatGrid(
                children: [
                  StatCard(
                    icon: Icons.emoji_events_outlined,
                    value: highestScore != null ? '$highestScore' : '---',
                    label: 'Điểm TOEIC cao nhất',
                    tone: highestScore != null && highestScore >= 700
                        ? AppTone.success
                        : AppTone.info,
                  ),
                  StatCard(
                    icon: Icons.local_fire_department_rounded,
                    value: '$streak ngày',
                    label: streak > 0 ? 'Chuỗi ngày học' : 'Chưa có chuỗi',
                    tone: streak > 0 ? AppTone.warning : AppTone.neutral,
                  ),
                  StatCard(
                    icon: Icons.quiz_outlined,
                    value: '${completedAttempts.length} đề',
                    label: 'Đề thi đã hoàn thành',
                    tone: AppTone.info,
                  ),
                  StatCard(
                    icon: Icons.check_circle_outline_rounded,
                    value: '${vocab?.bank.mastered ?? 0} từ',
                    label: 'Từ vựng đã thuộc',
                    tone: AppTone.success,
                  ),
                ],
              ),
              Gaps.v24,

              // 4. Thẻ Mục Tiêu Luyện Thi
              SectionHeader(
                title: 'Mục tiêu luyện thi',
                subtitle: 'Kế hoạch bứt phá điểm số TOEIC theo ngày',
                trailing: TextButton(
                  onPressed: () => showGoalSheet(context),
                  child: const Text('Điều chỉnh'),
                ),
              ),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const IconBadge(
                          icon: Icons.flag_rounded,
                          tone: AppTone.warning,
                        ),
                        Gaps.h12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                targetScore != null
                                    ? 'Mục tiêu: $targetScore điểm TOEIC'
                                    : 'Chưa đặt điểm mục tiêu',
                                style: context.textStyles.titleMedium,
                              ),
                              if (daysLeft != null)
                                Text(
                                  daysLeft > 0
                                      ? 'Còn $daysLeft ngày đến ngày thi (${Fmt.date(examDate!)})'
                                      : 'Đã đến ngày thi (${Fmt.date(examDate!)})',
                                  style: context.textStyles.bodySmall?.copyWith(
                                    color: context.colors.onSurfaceVariant,
                                  ),
                                )
                              else
                                Text(
                                  'Chưa đặt ngày thi chính thức',
                                  style: context.textStyles.bodySmall?.copyWith(
                                    color: context.colors.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gaps.v12,
                    const Divider(),
                    Gaps.v8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${goals.dailyQuestions}',
                              style: context.textStyles.titleLarge?.copyWith(
                                color: context.colors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'câu hỏi / ngày',
                              style: context.textStyles.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '${goals.dailyWords}',
                              style: context.textStyles.titleLarge?.copyWith(
                                color: context.colors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'từ mới / ngày',
                              style: context.textStyles.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '${goals.dailyDictations}',
                              style: context.textStyles.titleLarge?.copyWith(
                                color: context.colors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'bài nghe / ngày',
                              style: context.textStyles.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gaps.v24,

              // 5. Lối tắt học tập chuyên sâu
              const SectionHeader(
                title: 'Học tập chuyên sâu',
                subtitle: 'Các công cụ củng cố kỹ năng và khắc phục điểm yếu',
              ),
              AppListGroup(
                children: [
                  ListTile(
                    leading: const IconBadge(
                      icon: Icons.bookmark_remove_outlined,
                      tone: AppTone.danger,
                    ),
                    title: const Text('Sổ câu sai & Bẫy đề thi'),
                    subtitle: const Text('Xem lại và luyện lại các câu hỏi đã chọn sai'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(Routes.mistakes),
                  ),
                  ListTile(
                    leading: const IconBadge(
                      icon: Icons.headphones_outlined,
                      tone: AppTone.info,
                    ),
                    title: const Text('Luyện chép chính tả Listening'),
                    subtitle: const Text('Rèn phản xạ nghe từng từ Part 1 & Part 2'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(Routes.listening),
                  ),
                  ListTile(
                    leading: const IconBadge(
                      icon: Icons.style_outlined,
                      tone: AppTone.success,
                    ),
                    title: const Text('Kho từ vựng cá nhân'),
                    subtitle: const Text('Danh sách từ vựng theo chủ đề và bộ đề ETS'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(Routes.vocabWords()),
                  ),
                ],
              ),
              Gaps.v24,

              // 6. Tài khoản & Cài đặt
              const SectionHeader(
                title: 'Tài khoản & ứng dụng',
              ),
              AppListGroup(
                children: [
                  ListTile(
                    leading: const IconBadge(
                      icon: Icons.settings_outlined,
                      tone: AppTone.neutral,
                    ),
                    title: const Text('Cài đặt ứng dụng'),
                    subtitle: const Text('Giao diện, âm thanh, thông báo nhắc học'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(Routes.settings),
                  ),
                  ListTile(
                    leading: const IconBadge(
                      icon: Icons.leaderboard_outlined,
                      tone: AppTone.neutral,
                    ),
                    title: const Text('Hồ sơ bảng xếp hạng'),
                    subtitle: const Text('Cấu hình đạo hiệu và quyền hiển thị thứ hạng'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => showLeaderboardProfileSheet(context),
                  ),
                  if (kDebugMode)
                    ListTile(
                      leading: const IconBadge(
                        icon: Icons.palette_outlined,
                        tone: AppTone.neutral,
                      ),
                      title: const Text('Thư viện Design System'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push(Routes.designSystem),
                    ),
                  ListTile(
                    leading: const IconBadge(
                      icon: Icons.logout_rounded,
                      tone: AppTone.danger,
                    ),
                    title: Text(
                      'Đăng xuất',
                      style: TextStyle(
                        color: context.colors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () => _signOut(context, ref),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
