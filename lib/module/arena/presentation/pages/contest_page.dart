import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../helper/format.dart';
import '../../../../routes/app_router.dart';
import '../../../plan/presentation/controllers/plan_controller.dart';
import '../../../plan/presentation/widgets/pro_sheet.dart';
import '../../data/models/arena_models.dart';
import '../controllers/contest_controller.dart';
import '../widgets/arena_widgets.dart';

/// Thi trực tiếp Chủ nhật: đếm ngược, vào phòng thi, bảng xếp hạng, xem lại (PRO).
class ContestPage extends ConsumerWidget {
  const ContestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(contestOverviewProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Thi Chủ nhật')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(contestOverviewProvider.future),
        child: AsyncView(
          value: overview,
          onRetry: () => ref.invalidate(contestOverviewProvider),
          data: (o) => _Body(overview: o),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.overview});

  final ContestOverview overview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offset = serverOffset(overview.serverNow);
    final current = overview.current;
    final previous = overview.previous;
    final phase = current?.phaseAt(DateTime.now().add(offset));
    // Đang thi / vừa thi xong thì bảng của kỳ này; còn lại xem kỳ trước.
    final boardOf = phase == ContestPhase.upcoming || current == null ? previous : current;

    return ListView(
      padding: AppInsets.screen,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        if (current != null) _CurrentHero(contest: current, offset: offset),
        Gaps.v16,
        const _RulesCard(),
        if (boardOf != null) ...[
          Gaps.v24,
          SectionHeader(
            title: boardOf == current ? 'Bảng xếp hạng kỳ này' : 'Kết quả ${boardOf.title}',
            subtitle: 'Đúng nhiều hơn xếp trên; bằng nhau thì ai nộp nhanh hơn',
          ),
          _Board(contest: boardOf),
          if (boardOf.phaseAt(DateTime.now().add(offset)) == ContestPhase.finished &&
              boardOf.submitted) ...[
            Gaps.v12,
            _ReviewButton(contest: boardOf),
          ],
        ],
      ],
    );
  }
}

class _CurrentHero extends StatelessWidget {
  const _CurrentHero({required this.contest, required this.offset});

  final ContestInfo contest;
  final Duration offset;

  @override
  Widget build(BuildContext context) {
    final fg = AppHeroCard.foreground(context);
    return AppHeroCard(
      child: SecondTicker(
        builder: (context) {
          final now = DateTime.now().add(offset);
          final phase = contest.phaseAt(now);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      contest.title,
                      style: context.textStyles.titleMedium?.copyWith(color: fg),
                    ),
                  ),
                  if (phase == ContestPhase.live) const _LiveBadge(),
                ],
              ),
              Gaps.v8,
              Text(
                switch (phase) {
                  ContestPhase.upcoming => countdownLabel(contest.startsAt.difference(now)),
                  ContestPhase.live => countdownLabel(contest.endsAt.difference(now)),
                  ContestPhase.finished => 'Đã kết thúc',
                },
                style: context.textStyles.displaySmall?.copyWith(
                  color: fg,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                switch (phase) {
                  ContestPhase.upcoming => 'đến giờ mở phòng · ${contestSlotLabel(contest.startsAt)}',
                  ContestPhase.live => 'còn lại trước khi đóng phòng',
                  ContestPhase.finished => contestSlotLabel(contest.startsAt),
                },
                style: context.textStyles.bodySmall?.copyWith(color: fg),
              ),
              Gaps.v16,
              Wrap(
                spacing: AppSpacing.s16,
                runSpacing: AppSpacing.s8,
                children: [
                  IconLabel(
                    icon: Icons.help_outline_rounded,
                    label: '${contest.questionCount} câu · nghe + đọc',
                    color: fg,
                  ),
                  IconLabel(
                    icon: Icons.timer_outlined,
                    label: '${contest.endsAt.difference(contest.startsAt).inMinutes} phút',
                    color: fg,
                  ),
                  if (contest.participants > 0)
                    IconLabel(
                      icon: Icons.groups_outlined,
                      label: '${contest.participants} người vào thi',
                      color: fg,
                    ),
                ],
              ),
              Gaps.v16,
              switch (phase) {
                ContestPhase.live when contest.submitted => _Submitted(contest: contest, fg: fg),
                ContestPhase.live => AppPrimaryButton(
                  icon: Icons.login_rounded,
                  label: contest.joined ? 'Làm tiếp bài thi' : 'Vào phòng thi',
                  onPressed: () => context.push(Routes.contestTake(contest.id)),
                ),
                ContestPhase.upcoming => Text(
                  'Phòng mở đúng giờ, ai vào muộn sẽ có ít thời gian hơn. Đặt lời nhắc để không lỡ nhé!',
                  style: context.textStyles.bodySmall?.copyWith(color: fg),
                ),
                ContestPhase.finished => contest.submitted
                    ? _Submitted(contest: contest, fg: fg)
                    : Text(
                        'Bạn đã lỡ kỳ này. Hẹn 20:00 Chủ nhật tới!',
                        style: context.textStyles.bodySmall?.copyWith(color: fg),
                      ),
              },
            ],
          );
        },
      ),
    );
  }
}

/// Nhãn "ĐANG THI" nền đặc – đọc rõ trên nền gradient của thẻ hero.
class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    final c = AppTone.danger.colorsOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
      decoration: BoxDecoration(color: c.main, borderRadius: AppRadius.brFull),
      child: Text(
        'ĐANG THI',
        style: context.textStyles.labelSmall?.copyWith(
          color: c.onMain,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Submitted extends StatelessWidget {
  const _Submitted({required this.contest, required this.fg});

  final ContestInfo contest;
  final Color fg;

  @override
  Widget build(BuildContext context) => IconLabel(
    icon: Icons.check_circle_outline_rounded,
    label: 'Đã nộp · đúng ${contest.correct ?? 0}/${contest.questionCount} câu',
    color: fg,
  );
}

class _RulesCard extends StatelessWidget {
  const _RulesCard();

  @override
  Widget build(BuildContext context) {
    const rules = [
      (Icons.event_rounded, 'Mỗi Chủ nhật 20:00–20:40, mọi người làm cùng một đề.'),
      (Icons.headphones_rounded, 'Khoảng 50 câu đủ 7 Part, rút ngẫu nhiên từ ngân hàng đề.'),
      (Icons.leaderboard_outlined, 'Xếp hạng theo số câu đúng, bằng nhau thì ai nộp nhanh hơn.'),
      (Icons.workspace_premium_outlined, 'PRO được xem lại đáp án và giải thích sau giờ thi.'),
    ];
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (i, (icon, text)) in rules.indexed) ...[
            if (i > 0) Gaps.v8,
            IconLabel(icon: icon, label: text, style: context.textStyles.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class _Board extends ConsumerWidget {
  const _Board({required this.contest});

  final ContestInfo contest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(contestBoardProvider(contest.id));
    return AsyncView(
      value: board,
      onRetry: () => ref.invalidate(contestBoardProvider(contest.id)),
      loading: (_) => const AppCard(child: Center(child: AppInlineSpinner())),
      data: (list) {
        if (list.isEmpty) {
          return const AppCard(
            child: Text('Chưa ai nộp bài. Người nộp đầu tiên sẽ đứng đầu bảng!'),
          );
        }
        final me = list.where((r) => r.isMe).firstOrNull;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (me != null) ...[
              AppCard(
                tone: AppTone.info,
                child: Row(
                  children: [
                    IconBadge(icon: Icons.emoji_events_rounded, tone: AppTone.warning),
                    Gaps.h12,
                    Expanded(
                      child: Text(
                        me.total <= 1
                            ? 'Bạn đang hạng 1 – chưa có ai khác nộp bài.'
                            : 'Hạng ${me.rank}/${me.total} · bạn hơn ${me.percentile ?? 0}% người thi',
                        style: context.textStyles.titleSmall,
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.v12,
            ],
            AppListGroup(
              children: [
                for (final r in list)
                  ListTile(
                    leading: _RankCircle(rank: r.rank),
                    title: Text(r.isMe ? '${r.displayName} (bạn)' : r.displayName),
                    subtitle: Text('Làm trong ${Fmt.clock(Duration(seconds: r.durationMs ~/ 1000))}'),
                    trailing: Text(
                      '${r.correct}/${contest.questionCount}',
                      style: context.textStyles.titleMedium,
                    ),
                    selected: r.isMe,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _RankCircle extends StatelessWidget {
  const _RankCircle({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final tone = switch (rank) {
      1 => AppTone.warning,
      2 || 3 => AppTone.info,
      _ => AppTone.neutral,
    };
    final c = tone.colorsOf(context);
    return CircleAvatar(
      radius: AppSizes.badgeMd / 2,
      backgroundColor: c.container,
      foregroundColor: c.onContainer,
      child: Text('$rank', style: context.textStyles.labelLarge),
    );
  }
}

class _ReviewButton extends ConsumerWidget {
  const _ReviewButton({required this.contest});

  final ContestInfo contest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(myPlanProvider).value?.isPro ?? false;
    return FilledButton.tonalIcon(
      icon: Icon(isPro ? Icons.fact_check_outlined : Icons.lock_outline_rounded),
      label: Text(isPro ? 'Xem lại đáp án & giải thích' : 'Xem lại đáp án (PRO)'),
      onPressed: () => isPro
          ? context.push(Routes.contestReview(contest.id))
          : showProSheet(context),
    );
  }
}
