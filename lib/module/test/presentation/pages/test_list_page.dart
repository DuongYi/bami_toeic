import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../helper/format.dart';
import '../../../../routes/app_router.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../dictionary/presentation/widgets/dictionary_sheet.dart';
import '../../../goals/presentation/controllers/study_progress.dart';
import '../../../goals/presentation/widgets/goal_sheet.dart';
import '../../../plan/data/models/plan_models.dart';
import '../../../plan/presentation/controllers/plan_controller.dart';
import '../../../plan/presentation/widgets/pro_sheet.dart';
import '../../../vocab/presentation/controllers/vocab_controller.dart';
import '../../data/in_progress_store.dart';
import '../../data/models/test_models.dart';
import '../../data/test_catalog.dart';
import '../controllers/test_providers.dart';
import '../widgets/test_collection_card.dart';

/// Màn chủ: lời chào kèm chuỗi học tập, thẻ dự đoán điểm TOEIC, nhiệm vụ ngày,
/// bento lối tắt luyện tập và thư viện đề chia theo bộ (ETS, rút gọn, luyện Part).
class TestListPage extends ConsumerStatefulWidget {
  const TestListPage({super.key});

  @override
  ConsumerState<TestListPage> createState() => _TestListPageState();
}

class _TestListPageState extends ConsumerState<TestListPage> {
  Future<void> _refresh() {
    ref
      ..invalidate(attemptsProvider)
      ..invalidate(mistakesProvider)
      ..invalidate(inProgressAllProvider)
      ..invalidate(vocabListProvider)
      ..invalidate(myPlanProvider);
    return ref.refresh(testListProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final tests = ref.watch(testListProvider);
    final attempts = ref.watch(attemptsProvider).value ?? const <Attempt>[];
    final inProgress = ref.watch(inProgressAllProvider).value ?? const {};
    final plan = ref.watch(myPlanProvider).value;

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
                  if (plan != null && !plan.isPro) ...[
                    const _CommercialUpgradeBanner(),
                    Gaps.v8,
                  ],
                  Gaps.v16,
                  _TestLibrary(
                    tests: list,
                    attempts: attempts,
                    inProgress: inProgress,
                    plan: plan,
                  ),
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
    final initial = (email == null || email.isEmpty)
        ? 'B'
        : email[0].toUpperCase();
    final streak = progress?.streak ?? 0;
    final isStreakActive = progress?.activeToday ?? false;

    return AppPageHeader(
      topBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Semantics(
            button: true,
            label: 'Trang cá nhân học viên: ${_displayName(email)}',
            child: InkWell(
              onTap: () => context.push(Routes.profile),
              borderRadius: AppRadius.brMd,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s4,
                  AppSpacing.s4,
                  AppSpacing.s12,
                  AppSpacing.s4,
                ),
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerHighest.withValues(
                    alpha: 0.6,
                  ),
                  borderRadius: AppRadius.brMd,
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
                      Icons.chevron_right_rounded,
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
              if (ref.watch(myPlanProvider).value?.isPro ?? false) ...[
                const ProBadge(mini: true),
                Gaps.h8,
              ],
              StreakBadge(
                count: streak,
                active: isStreakActive,
                onTap: () => showGoalSheet(context),
              ),
              Gaps.h4,
              const DictionaryButton(compact: true),
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
                            target == null
                                ? 'Đặt mục tiêu'
                                : 'Mục tiêu $target',
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
                  subtitle: switch (vocab) {
                    null => 'Flashcard SRS',
                    final v when v.doneToday => 'Xong hôm nay',
                    final v => '${v.todayCount} thẻ hôm nay',
                  },
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
                  icon: Icons.auto_stories_rounded,
                  tone: AppTone.success,
                  title: 'Lý thuyết & Mẹo thi',
                  subtitle: 'Ngữ pháp, IPA, bẫy ETS',
                  onTap: () => context.push(Routes.theory),
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
                  style: context.textStyles.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
  const _CommercialUpgradeBanner();

  @override
  Widget build(BuildContext context) {
    return UpgradeBanner(
      title: 'Mở khoá đặc quyền Bami PRO',
      description: 'Làm mọi đề ETS full 200 câu, chép chính tả mọi đề và ghi danh Cảnh giới.',
      actionLabel: 'Xem chi tiết',
      onUpgrade: () => showProSheet(context),
    );
  }
}

/// Thư viện đề: thẻ "Làm tiếp" (đề làm dở gần nhất) + các bộ đề chia theo nhóm, lưới 2 cột.
class _TestLibrary extends StatelessWidget {
  const _TestLibrary({
    required this.tests,
    required this.attempts,
    required this.inProgress,
    required this.plan,
  });

  final List<TestSummary> tests;
  final List<Attempt> attempts;
  final Map<String, TakingSnapshot> inProgress;
  final MyPlan? plan;

  @override
  Widget build(BuildContext context) {
    final entries = groupTests(tests);
    final resume = inProgress.values
        .where((s) => tests.any((t) => t.id == s.testId))
        .fold<TakingSnapshot?>(
          null,
          (best, s) =>
              best == null || s.savedAt.isAfter(best.savedAt) ? s : best,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Thư viện đề',
          subtitle: 'Chia theo bộ, làm lần lượt từ đề 1',
          trailing: Text(
            '${tests.length} đề',
            style: context.textStyles.labelLarge?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        if (tests.isEmpty)
          const AppCard(
            child: AppEmptyView(
              icon: Icons.inbox_outlined,
              message: 'Chưa có đề nào. Kéo xuống để tải lại.',
            ),
          ),
        if (resume != null) ...[
          _ResumeCard(
            snapshot: resume,
            test: tests.firstWhere((t) => t.id == resume.testId),
          ),
          Gaps.v16,
        ],
        for (final shelf in TestShelf.values)
          if (entries.where((e) => e.collection.shelf == shelf).toList()
              case final shelfEntries when shelfEntries.isNotEmpty) ...[
            Text(
              shelf.title.toUpperCase(),
              style: context.textStyles.labelMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v8,
            for (var i = 0; i < shelfEntries.length; i += 2) ...[
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _card(context, shelfEntries[i])),
                    Gaps.h12,
                    Expanded(
                      child: i + 1 < shelfEntries.length
                          ? _card(context, shelfEntries[i + 1])
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              Gaps.v12,
            ],
            Gaps.v8,
          ],
      ],
    );
  }

  Widget _card(BuildContext context, CollectionEntry e) => TestCollectionCard(
    collection: e.collection,
    progress: CollectionProgress.of(e.tests, attempts, inProgress.keys.toSet()),
    locked: e.tests.every((t) => isTestLocked(t, plan)),
    onTap: () => context.go(Routes.testCollection(e.collection.id)),
  );
}

/// Đề đang làm dở gần nhất: chạm để mở lại.
class _ResumeCard extends StatelessWidget {
  const _ResumeCard({required this.snapshot, required this.test});

  final TakingSnapshot snapshot;
  final TestSummary test;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      tone: AppTone.info,
      onTap: () => context.go(Routes.testDetail(test.id)),
      child: Row(
        children: [
          const IconBadge(icon: Icons.play_arrow_rounded, tone: AppTone.info),
          Gaps.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Làm tiếp',
                  style: context.textStyles.labelMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  test.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${snapshot.answers.length}/${snapshot.totalQuestions} câu · '
                  '${snapshot.isExam ? 'Thi thử' : 'Luyện tập'}',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: context.colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
