import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../helper/format.dart';
import '../../../../routes/app_router.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../goals/presentation/controllers/study_progress.dart';
import '../../../goals/presentation/widgets/goal_sheet.dart';
import '../../../vocab/presentation/controllers/vocab_controller.dart';
import '../../data/in_progress_store.dart';
import '../../data/models/test_models.dart';
import '../controllers/test_providers.dart';

/// Màn chủ: lời chào kèm chuỗi học tập, thẻ dự đoán điểm TOEIC, nhiệm vụ ngày,
/// bento lối tắt luyện tập và danh sách đề thi chuẩn hóa ETS.
class TestListPage extends ConsumerStatefulWidget {
  const TestListPage({super.key});

  @override
  ConsumerState<TestListPage> createState() => _TestListPageState();
}

class _TestListPageState extends ConsumerState<TestListPage> {
  String _filter = 'all';

  Future<void> _refresh() {
    ref
      ..invalidate(attemptsProvider)
      ..invalidate(mistakesProvider)
      ..invalidate(inProgressAllProvider)
      ..invalidate(vocabListProvider);
    return ref.refresh(testListProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final tests = ref.watch(testListProvider);
    final attempts = ref.watch(attemptsProvider).value ?? const <Attempt>[];
    final inProgress = ref.watch(inProgressAllProvider).value ?? const {};

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: AsyncView(
            value: tests,
            loading: (_) => const TestListSkeleton(),
            onRetry: () => ref.invalidate(testListProvider),
            data: (list) {
              final filtered = switch (_filter) {
                'ets' => list.where((t) => t.questionCount >= 100).toList(),
                'mini' => list.where((t) => t.questionCount < 100).toList(),
                _ => list,
              };

              return ListView(
                // Chừa chỗ cho thanh tab nổi (nội dung cuộn chạy dưới thanh kính)
                padding: AppInsets.screen.copyWith(
                  bottom: AppSpacing.screen + AppGlassTabBar.inset(context),
                ),
                children: [
                  const _Greeting(),
                  _OverviewHero(attempts: attempts),
                  Gaps.v16,
                  const _DailyMission(),
                  Gaps.v16,
                  const _QuickActions(),
                  Gaps.v16,
                  _CommercialUpgradeBanner(),
                  Gaps.v24,
                  SectionHeader(
                    title: 'Đề thi ETS & Luyện tập',
                    subtitle: 'Được biên soạn chuẩn theo format đề thi thật',
                    trailing: Text(
                      '${list.length} đề',
                      style: context.textStyles.labelLarge?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ChoiceChip(
                          label: Text('Tất cả (${list.length})'),
                          selected: _filter == 'all',
                          onSelected: (_) => setState(() => _filter = 'all'),
                        ),
                        Gaps.h8,
                        ChoiceChip(
                          label: const Text('🔥 ETS 2024 Hot'),
                          selected: _filter == 'ets',
                          onSelected: (_) => setState(() => _filter = 'ets'),
                        ),
                        Gaps.h8,
                        ChoiceChip(
                          label: const Text('⚡️ Mini Test 15p'),
                          selected: _filter == 'mini',
                          onSelected: (_) => setState(() => _filter = 'mini'),
                        ),
                      ],
                    ),
                  ),
                  Gaps.v16,
                  if (filtered.isEmpty)
                    const AppCard(
                      child: AppEmptyView(
                        icon: Icons.inbox_outlined,
                        message: 'Không tìm thấy đề thi phù hợp với bộ lọc.',
                      ),
                    )
                  else
                    for (final t in filtered) ...[
                      _TestCard(
                        test: t,
                        lastAttempt: attempts
                            .where((a) => a.testId == t.id && !a.isMistakeReview)
                            .firstOrNull,
                        inProgress: inProgress[t.id],
                      ),
                      Gaps.v12,
                    ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Greeting extends ConsumerWidget {
  const _Greeting();

  void _openAccount(BuildContext context, WidgetRef ref, String? email, int streak) {
    showAppBottomSheet<void>(
      context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            0,
            AppSpacing.screen,
            AppSpacing.s16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tài khoản học viên', style: ctx.textStyles.titleLarge),
                  const ProBadge(),
                ],
              ),
              Gaps.v12,
              AppListGroup(
                children: [
                  ListTile(
                    leading: const IconBadge(icon: Icons.person_rounded),
                    title: Text(email ?? 'Học viên Bami'),
                    subtitle: const Text('Gói Bami PRO · Không giới hạn'),
                  ),
                  ListTile(
                    leading: const IconBadge(
                      icon: Icons.local_fire_department_rounded,
                      tone: AppTone.warning,
                    ),
                    title: const Text('Mục tiêu & nhắc học'),
                    subtitle: Text(
                      streak == 0 ? 'Bắt đầu chuỗi ngày học hôm nay' : '$streak ngày học liên tiếp',
                    ),
                    trailing: StreakBadge(count: streak, active: streak > 0),
                    onTap: () {
                      Navigator.pop(ctx);
                      showGoalSheet(context);
                    },
                  ),
                  if (kDebugMode)
                    ListTile(
                      leading: const IconBadge(icon: Icons.palette_outlined, tone: AppTone.neutral),
                      title: const Text('Design System'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.pop(ctx);
                        context.push(Routes.designSystem);
                      },
                    ),
                  ListTile(
                    leading: const IconBadge(icon: Icons.logout_rounded, tone: AppTone.danger),
                    title: Text('Đăng xuất', style: TextStyle(color: ctx.colors.error)),
                    onTap: () async {
                      final ok = await showAppConfirmDialog(
                        ctx,
                        title: 'Đăng xuất?',
                        message: 'Bạn sẽ cần nhập lại email và mật khẩu.',
                        confirmLabel: 'Đăng xuất',
                        destructive: true,
                      );
                      if (!ok) return;
                      if (ctx.mounted) Navigator.pop(ctx);
                      ref.read(authControllerProvider.notifier).signOut();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _displayName(String? email) {
    if (email == null || email.isEmpty) return 'Học viên';
    final name = email.split('@').first;
    if (name.isEmpty) return 'Học viên';
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(authControllerProvider).value?.user.email;
    final progress = ref.watch(studyProgressProvider).value;
    final initial = (email == null || email.isEmpty) ? 'B' : email[0].toUpperCase();
    final streak = progress?.streak ?? 0;
    final isStreakActive = progress?.activeToday ?? false;

    return AppPageHeader(
      topBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Semantics(
            button: true,
            label: 'Tài khoản học viên: ${_displayName(email)}',
            child: InkWell(
              onTap: () => _openAccount(context, ref, email, streak),
              borderRadius: AppRadius.brFull,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s4,
                  AppSpacing.s4,
                  AppSpacing.s12,
                  AppSpacing.s4,
                ),
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerHighest.withValues(alpha: 0.6),
                  borderRadius: AppRadius.brFull,
                  border: Border.all(
                    color: context.colors.outlineVariant.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: AppSizes.avatarSm / 2,
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.onPrimary,
                      child: Text(
                        initial,
                        style: context.textStyles.labelMedium?.copyWith(
                          color: context.colors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Gaps.h8,
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child: Text(
                        _displayName(email),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Gaps.h4,
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: AppSizes.iconSm,
                      color: context.colors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CoinBadge(
                amount: 150,
                onTap: () => _openAccount(context, ref, email, streak),
              ),
              Gaps.h8,
              StreakBadge(
                count: streak,
                active: isStreakActive,
                onTap: () => showGoalSheet(context),
              ),
            ],
          ),
        ],
      ),
      overline: 'LỘ TRÌNH ETS HÔM NAY',
      title: 'Hôm nay luyện gì nhỉ?',
      subtitle: streak > 0
          ? 'Đang duy trì chuỗi $streak ngày liên tục. Tiếp tục phát huy nhé! 🔥'
          : 'Chọn 1 đề thi ngắn để khởi động chuỗi học tập bứt phá điểm số.',
    );
  }
}

/// Thẻ tổng quan: điểm dự đoán (dữ liệu thật) so với mục tiêu, ngày thi. Chạm để đặt mục tiêu.
class _OverviewHero extends ConsumerWidget {
  const _OverviewHero({required this.attempts});

  final List<Attempt> attempts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fg = AppHeroCard.foreground(context);
    final progress = ref.watch(studyProgressProvider).value;
    final prediction = progress?.prediction;
    final target = progress?.goals.targetScore;
    final daysLeft = progress?.daysToExam(DateTime.now());
    final last = attempts.firstOrNull;
    final ratio = prediction == null || target == null
        ? null
        : (prediction.total / target).clamp(0.0, 1.0);

    final caption = [
      if (prediction != null)
        '${prediction.basis} · L ${prediction.listening} · R ${prediction.reading}'
      else
        'Làm ít nhất 30 câu Listening và 30 câu Reading để có điểm dự đoán.',
      if (daysLeft != null && daysLeft >= 0)
        daysLeft == 0 ? 'Thi hôm nay!' : 'Còn $daysLeft ngày đến ngày thi',
      if (prediction == null && last != null) 'Gần nhất: ${last.testTitle}',
    ].join('\n');

    return Semantics(
      button: true,
      label: 'Mục tiêu học tập',
      child: InkWell(
        onTap: () => showGoalSheet(context),
        borderRadius: AppRadius.brLg,
        child: AppHeroCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.s8,
                      runSpacing: AppSpacing.s4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Dự đoán TOEIC',
                          style: context.textStyles.labelLarge?.copyWith(
                            color: fg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s8,
                            vertical: AppSpacing.s2,
                          ),
                          decoration: BoxDecoration(
                            color: fg.withValues(alpha: 0.2),
                            borderRadius: AppRadius.brFull,
                          ),
                          child: Text(
                            target == null ? 'Đặt mục tiêu' : 'Mục tiêu $target',
                            style: context.textStyles.labelSmall?.copyWith(
                              color: fg,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (prediction != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s8,
                              vertical: AppSpacing.s2,
                            ),
                            decoration: BoxDecoration(
                              color: fg.withValues(alpha: 0.18),
                              borderRadius: AppRadius.brFull,
                            ),
                            child: Text(
                              '🎧 ${prediction.listening} · 📖 ${prediction.reading}',
                              style: context.textStyles.labelSmall?.copyWith(
                                color: fg,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Gaps.v4,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          prediction?.total.toString() ?? '—',
                          style: context.textStyles.displaySmall?.copyWith(
                            color: fg,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Gaps.h4,
                        Text(
                          '/ 990',
                          style: context.textStyles.titleMedium?.copyWith(
                            color: fg.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                    Gaps.v8,
                    Text(
                      caption,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: fg.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              if (ratio != null) ...[
                Gaps.h16,
                ScoreRing(
                  value: ratio,
                  size: AppSizes.ringMd,
                  strokeWidth: AppSizes.ringStrokeMd,
                  color: fg,
                  trackColor: fg.withValues(alpha: 0.25),
                  semanticLabel: 'Tiến độ hướng tới điểm mục tiêu',
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Fmt.percent(ratio),
                        style: context.textStyles.titleMedium?.copyWith(
                          color: fg,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'mục tiêu',
                        style: context.textStyles.labelSmall?.copyWith(
                          color: fg.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Nhiệm vụ hôm nay, tính từ hoạt động thật. Chạm → mở việc chưa xong đầu tiên.
class _DailyMission extends ConsumerWidget {
  const _DailyMission();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(studyProgressProvider).value;
    if (progress == null) return const SizedBox.shrink();
    final next = progress.missions.where((m) => !m.isDone).firstOrNull;
    return DailyMissionCard(
      completed: progress.missionsDone,
      total: progress.missions.length,
      items: [
        for (final m in progress.missions)
          DailyMissionItem(
            title: m.title,
            isDone: m.isDone,
            trailing: '${m.done.clamp(0, m.target)}/${m.target}',
          ),
      ],
      onTap: next == null
          ? () => showGoalSheet(context)
          : () => switch (next.kind) {
              MissionKind.questions => context.go(Routes.tests),
              MissionKind.words => context.go(Routes.vocab),
              MissionKind.mistakes => context.push(Routes.mistakes),
              MissionKind.dictations => context.push(Routes.listening),
            },
    );
  }
}

/// Lối tắt hành động dạng Bento Grid trực quan.
class _QuickActions extends ConsumerWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocab = ref.watch(vocabOverviewProvider).value;
    final mistakes = ref.watch(mistakesProvider).value;

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _QuickAction(
                  icon: Icons.style_rounded,
                  tone: AppTone.warning,
                  title: 'Ôn từ vựng',
                  subtitle: vocab == null ? 'Flashcard SRS' : '${vocab.sessionSize} từ hôm nay',
                  onTap: () => context.go(Routes.vocab),
                ),
              ),
              Gaps.h12,
              Expanded(
                child: _QuickAction(
                  icon: Icons.assignment_late_outlined,
                  tone: AppTone.danger,
                  title: 'Sổ câu sai',
                  subtitle: mistakes == null
                      ? 'Ôn câu làm sai'
                      : mistakes.isEmpty
                      ? 'Chưa có câu sai'
                      : '${mistakes.length} câu cần ôn',
                  onTap: () => context.push(Routes.mistakes),
                ),
              ),
            ],
          ),
        ),
        Gaps.v12,
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _QuickAction(
                  icon: Icons.hearing_rounded,
                  tone: AppTone.info,
                  title: 'Luyện nghe',
                  subtitle: 'Chép chính tả, nói theo',
                  onTap: () => context.push(Routes.listening),
                ),
              ),
              Gaps.h12,
              Expanded(
                child: _QuickAction(
                  icon: Icons.timer_outlined,
                  tone: AppTone.success,
                  title: 'Thi thử 120p',
                  subtitle: 'Bấm giờ như thi thật',
                  onTap: () => context.go(Routes.tests),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.tone,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final AppTone tone;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          IconBadge(icon: icon, tone: tone),
          Gaps.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textStyles.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Banner thương mại hoá Bami PRO.
class _CommercialUpgradeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UpgradeBanner(
      title: 'Mở khoá đặc quyền Bami PRO',
      description: 'Ngân hàng 20+ đề ETS 2024 mới nhất & AI phân tích giải thích bẫy đề.',
      actionLabel: 'Xem chi tiết',
      onUpgrade: () {
        showAppSnackBar(
          context,
          'Bạn đang sử dụng phiên bản Bami PRO đầy đủ!',
          tone: AppTone.success,
        );
      },
    );
  }
}

class _TestCard extends StatelessWidget {
  const _TestCard({required this.test, this.lastAttempt, this.inProgress});

  final TestSummary test;
  final Attempt? lastAttempt;
  final TakingSnapshot? inProgress;

  @override
  Widget build(BuildContext context) {
    final a = lastAttempt;
    final done = a == null
        ? null
        : a.isFullTest
        ? '${a.totalScore} điểm'
        : '${a.correct}/${a.totalQuestions} đúng';

    final isFullTest = test.questionCount >= 100;

    return AppCard(
      onTap: () => context.go(Routes.testDetail(test.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSizes.badgeLg,
                height: AppSizes.badgeLg,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isFullTest ? context.surfaces.hero : context.surfaces.cyan,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.brMd,
                ),
                child: Center(
                  child: Icon(
                    isFullTest ? Icons.menu_book_rounded : Icons.bolt_rounded,
                    color: context.surfaces.onHero,
                    size: AppSizes.iconMd,
                  ),
                ),
              ),
              Gaps.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            test.title,
                            style: context.textStyles.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (isFullTest)
                          const ProBadge(label: 'PRO', mini: true),
                      ],
                    ),
                    Gaps.v4,
                    Wrap(
                      spacing: AppSpacing.s12,
                      runSpacing: AppSpacing.s4,
                      children: [
                        Text(
                          '⏱ ${isFullTest ? "120 phút" : "15 phút"}',
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '📝 ${test.questionCount} câu',
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '⭐️ 4.9',
                          style: context.textStyles.bodySmall?.copyWith(
                            color: AppTone.warning.colorsOf(context).main,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gaps.v12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.s8,
                  runSpacing: AppSpacing.s4,
                  children: [
                    TestTag(
                      label: isFullTest ? 'Chuẩn ETS' : 'Mini Test',
                      tone: isFullTest ? TestTagTone.success : TestTagTone.neutral,
                    ),
                    if (inProgress case final p?)
                      StatusBadge(
                        label: 'Làm dở · ${p.answers.length}/${p.totalQuestions}',
                        tone: AppTone.info,
                        icon: Icons.pause_circle_outline_rounded,
                      ),
                    if (done != null)
                      StatusBadge(
                        label: 'Đã làm · $done',
                        tone: AppTone.success,
                        icon: Icons.check_rounded,
                      ),
                  ],
                ),
              ),
              Gaps.h8,
              FilledButton.tonal(
                onPressed: () => context.go(Routes.testDetail(test.id)),
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Làm bài'),
                    Gaps.h4,
                    Icon(Icons.arrow_forward_rounded, size: AppSizes.iconXs),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
