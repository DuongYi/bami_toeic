import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../helper/format.dart';
import '../../../../helper/score.dart';
import '../../../../routes/app_router.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../vocab/presentation/controllers/vocab_controller.dart';
import '../../data/in_progress_store.dart';
import '../../data/models/test_models.dart';
import '../controllers/test_providers.dart';

/// Màn chủ: lời chào, thẻ tổng quan, lối tắt, danh sách đề.
class TestListPage extends ConsumerWidget {
  const TestListPage({super.key});

  Future<void> _refresh(WidgetRef ref) {
    ref
      ..invalidate(attemptsProvider)
      ..invalidate(mistakesProvider)
      ..invalidate(inProgressAllProvider)
      ..invalidate(vocabListProvider);
    return ref.refresh(testListProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(testListProvider);
    final attempts = ref.watch(attemptsProvider).value ?? const <Attempt>[];
    final inProgress = ref.watch(inProgressAllProvider).value ?? const {};

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: AsyncView(
            value: tests,
            onRetry: () => ref.invalidate(testListProvider),
            data: (list) => ListView(
              padding: AppInsets.screen,
              children: [
                const _Greeting(),
                _OverviewHero(attempts: attempts),
                Gaps.v12,
                const _QuickActions(),
                Gaps.v24,
                SectionHeader(
                  title: 'Đề thi',
                  trailing: Text(
                    '${list.length} đề',
                    style: context.textStyles.labelLarge?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
                if (list.isEmpty)
                  const AppCard(
                    child: AppEmptyView(
                      icon: Icons.inbox_outlined,
                      message: 'Chưa có đề nào.\nDùng script tool/import_test.dart để thêm đề.',
                    ),
                  )
                else
                  for (final t in list) ...[
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
            ),
          ),
        ),
      ),
    );
  }
}

class _Greeting extends ConsumerWidget {
  const _Greeting();

  void _openAccount(BuildContext context, WidgetRef ref, String? email) {
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
              Text('Tài khoản', style: ctx.textStyles.titleLarge),
              Gaps.v12,
              AppListGroup(
                children: [
                  ListTile(
                    leading: const IconBadge(icon: Icons.person_rounded),
                    title: Text(email ?? 'Không rõ email'),
                    subtitle: const Text('Đang đăng nhập'),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(authControllerProvider).value?.user.email;
    final initial = (email == null || email.isEmpty) ? '?' : email[0].toUpperCase();
    return AppPageHeader(
      overline: 'Xin chào 👋',
      title: 'Hôm nay luyện gì nhỉ?',
      trailing: Tooltip(
        message: 'Tài khoản',
        child: InkResponse(
          onTap: () => _openAccount(context, ref, email),
          radius: AppSizes.touchTarget / 2,
          child: CircleAvatar(
            radius: AppSizes.touchTarget / 2,
            backgroundColor: context.colors.primaryContainer,
            foregroundColor: context.colors.onPrimaryContainer,
            child: Text(initial, style: context.textStyles.titleMedium),
          ),
        ),
      ),
    );
  }
}

/// Thẻ tổng quan: điểm cao nhất + lượt làm gần nhất.
class _OverviewHero extends StatelessWidget {
  const _OverviewHero({required this.attempts});

  final List<Attempt> attempts;

  @override
  Widget build(BuildContext context) {
    final fg = AppHeroCard.foreground(context);
    final last = attempts.firstOrNull;
    final best = attempts
        .where((a) => a.isFullTest)
        .map((a) => ToeicScore.listening(a.listeningCorrect) + ToeicScore.reading(a.readingCorrect))
        .fold<int?>(null, (m, v) => m == null || v > m ? v : m);
    final lastRatio = last == null || last.totalQuestions == 0
        ? 0.0
        : last.correct / last.totalQuestions;

    return AppHeroCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  best == null ? 'Chưa có điểm full test' : 'Điểm cao nhất',
                  style: context.textStyles.labelLarge?.copyWith(color: fg),
                ),
                Gaps.v4,
                Text(
                  best?.toString() ?? '—',
                  style: context.textStyles.displaySmall?.copyWith(color: fg),
                ),
                Gaps.v8,
                Text(
                  last == null
                      ? 'Chọn một đề bên dưới để bắt đầu.'
                      : 'Gần nhất: ${last.testTitle}\n${Fmt.dateTime(last.finishedAt)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.bodySmall?.copyWith(color: fg),
                ),
              ],
            ),
          ),
          if (last != null) ...[
            Gaps.h16,
            ScoreRing(
              value: lastRatio,
              size: AppSizes.ringMd,
              strokeWidth: AppSizes.ringStrokeMd,
              color: fg,
              trackColor: fg.withValues(alpha: 0.25),
              semanticLabel: 'Tỉ lệ đúng lần gần nhất',
              child: Text(
                Fmt.percent(lastRatio),
                style: context.textStyles.titleMedium?.copyWith(color: fg),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickActions extends ConsumerWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocab = ref.watch(vocabOverviewProvider).value;
    final mistakes = ref.watch(mistakesProvider).value;
    return IntrinsicHeight(
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
        ? '${ToeicScore.listening(a.listeningCorrect) + ToeicScore.reading(a.readingCorrect)} điểm'
        : '${a.correct}/${a.totalQuestions} đúng';

    return AppCard(
      onTap: () => context.go(Routes.testDetail(test.id)),
      child: Row(
        children: [
          const IconBadge(icon: Icons.menu_book_rounded, size: AppSizes.badgeLg),
          Gaps.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(test.title, style: context.textStyles.titleMedium),
                Gaps.v4,
                Text(
                  [if (test.source != null) test.source!, '${test.questionCount} câu'].join(' · '),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                if (done != null || inProgress != null) ...[
                  Gaps.v8,
                  Wrap(
                    spacing: AppSpacing.s8,
                    runSpacing: AppSpacing.s4,
                    children: [
                      if (inProgress case final p?)
                        StatusBadge(
                          label: 'Đang làm dở · ${p.answers.length}/${p.totalQuestions}',
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
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: context.colors.onSurfaceVariant),
        ],
      ),
    );
  }
}
