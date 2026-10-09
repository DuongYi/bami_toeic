import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../helper/format.dart';
import '../../../../routes/app_router.dart';
import '../../data/models/leaderboard_models.dart';
import '../../data/realm.dart';
import '../controllers/leaderboard_controller.dart';
import '../widgets/leaderboard_profile_sheet.dart';

/// Thương Khung Bảng: xếp hạng theo điểm full test cao nhất hoặc số câu đã làm 7 ngày qua.
class LeaderboardPage extends ConsumerStatefulWidget {
  const LeaderboardPage({super.key});

  @override
  ConsumerState<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends ConsumerState<LeaderboardPage> {
  LeaderboardBoard _board = LeaderboardBoard.score;

  Future<void> _refresh() {
    ref.invalidate(myLeaderboardProfileProvider);
    return ref.refresh(leaderboardProvider(_board).future);
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(leaderboardProvider(_board));
    final hidden = ref.watch(myLeaderboardProfileProvider).value?.showOnLeaderboard == false;
    final bottom = AppSpacing.screen + AppGlassTabBar.inset(context);

    final header = SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      sliver: SliverList.list(
        children: [
          AppPageHeader(
            overline: 'BẢNG XẾP HẠNG',
            title: 'Thương Khung Bảng',
            subtitle: 'So tài cùng các đạo hữu, xem ai đang ở cảnh giới nào',
            trailing: IconButton(
              tooltip: 'Hồ sơ xếp hạng',
              icon: const Icon(Icons.manage_accounts_outlined),
              onPressed: () => showLeaderboardProfileSheet(context),
            ),
          ),
          SegmentedButton<LeaderboardBoard>(
            segments: const [
              ButtonSegment(
                value: LeaderboardBoard.score,
                icon: Icon(Icons.workspace_premium_outlined),
                label: Text('Cảnh giới'),
              ),
              ButtonSegment(
                value: LeaderboardBoard.week,
                icon: Icon(Icons.local_fire_department_outlined),
                label: Text('Chăm chỉ 7 ngày'),
              ),
            ],
            selected: {_board},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _board = s.first),
          ),
          Gaps.v16,
          if (hidden) ...[
            const AppBanner(
              message: 'Bạn đang ẩn khỏi bảng. Người khác không thấy tên và điểm của bạn.',
              tone: AppTone.info,
              icon: Icons.visibility_off_outlined,
            ),
            Gaps.v16,
          ],
        ],
      ),
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              header,
              ...entries.when(
                skipLoadingOnRefresh: true,
                loading: () => const [SliverFillRemaining(child: AppLoadingView())],
                error: (e, _) => [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppErrorView(message: AppException.from(e).message, onRetry: _refresh),
                  ),
                ],
                data: (list) => _content(list, bottom),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _content(List<LeaderboardEntry> list, double bottom) {
    final ranked = list.where((e) => e.rank != null).toList();
    final me = list.where((e) => e.isMe).firstOrNull;
    final padded = EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, bottom);

    if (ranked.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: AppEmptyView(
              icon: Icons.leaderboard_outlined,
              message: _board == LeaderboardBoard.score
                  ? 'Chưa ai có điểm full test.\nLàm trọn 1 đề 200 câu để ghi danh lên bảng.'
                  : 'Chưa ai làm bài trong 7 ngày qua.\nLàm vài câu để mở màn bảng tuần này.',
              action: FilledButton.tonal(
                onPressed: () => context.go(Routes.tests),
                child: const Text('Làm đề'),
              ),
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        sliver: SliverList.list(
          children: [
            if (me != null) ...[_MyStanding(me: me, board: _board, total: ranked.length), Gaps.v24],
            SectionHeader(
              title: _board == LeaderboardBoard.score ? 'Điểm full test cao nhất' : '7 ngày qua',
              subtitle: _board == LeaderboardBoard.score
                  ? 'Chỉ tính đề làm trọn 200 câu'
                  : 'Xếp theo số câu đã làm, bằng nhau thì xét số câu đúng',
            ),
          ],
        ),
      ),
      SliverPadding(
        padding: padded,
        sliver: AppSliverListGroup(
          itemCount: ranked.length,
          dividerIndent: AppSpacing.s16 + AppSizes.badgeMd + AppSpacing.s16,
          itemBuilder: (_, i) => _EntryTile(entry: ranked[i], board: _board),
        ),
      ),
    ];
  }
}

/// Thẻ hero: hạng của mình + cảnh giới (bảng điểm) hoặc tỉ lệ đúng (bảng tuần).
class _MyStanding extends StatelessWidget {
  const _MyStanding({required this.me, required this.board, required this.total});

  final LeaderboardEntry me;
  final LeaderboardBoard board;
  final int total;

  @override
  Widget build(BuildContext context) {
    final fg = AppHeroCard.foreground(context);
    final muted = fg.withValues(alpha: 0.85);
    final isScore = board == LeaderboardBoard.score;
    final score = me.bestScore;
    final realm = score == null ? null : Realm.of(score);
    final next = realm?.next;

    final String value;
    final String unit;
    final String caption;
    final double? ring;
    final String ringLabel;
    if (isScore) {
      value = score?.toString() ?? '—';
      unit = '/ 990';
      caption = switch ((realm, next)) {
        (null, _) => 'Làm trọn 1 đề 200 câu để có cảnh giới.',
        (_, null) => 'Đã đạt cảnh giới cao nhất\nL ${me.bestListening} · R ${me.bestReading}',
        (_, final n?) =>
          'Còn ${n.minScore - score!} điểm để lên ${n.label}\nL ${me.bestListening} · R ${me.bestReading}',
      };
      ring = realm == null
          ? null
          : next == null
          ? 1
          : (score! - realm.minScore) / (next.minScore - realm.minScore);
      ringLabel = 'đột phá';
    } else {
      value = '${me.weekQuestions}';
      unit = 'câu';
      caption = me.weekQuestions == 0
          ? 'Chưa làm câu nào trong 7 ngày qua.'
          : 'Đúng ${me.weekCorrect}/${me.weekQuestions} câu trong 7 ngày qua';
      ring = me.weekQuestions == 0 ? null : me.weekAccuracy;
      ringLabel = 'đúng';
    }

    final rankText = me.rank == null ? 'Chưa xếp hạng' : 'Hạng ${me.rank} / $total';
    return Semantics(
      container: true,
      label: '$rankText. $caption',
      child: AppHeroCard(
        child: Row(
          children: [
            Expanded(
              child: ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      [rankText, if (isScore && realm != null) realm.label].join(' · '),
                      style: context.textStyles.labelLarge?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gaps.v4,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          value,
                          style: context.textStyles.displaySmall?.copyWith(
                            color: fg,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Gaps.h4,
                        Text(unit, style: context.textStyles.titleMedium?.copyWith(color: muted)),
                      ],
                    ),
                    Gaps.v8,
                    Text(caption, style: context.textStyles.bodySmall?.copyWith(color: muted)),
                  ],
                ),
              ),
            ),
            if (ring != null) ...[
              Gaps.h16,
              ScoreRing(
                value: ring.clamp(0.0, 1.0),
                size: AppSizes.ringMd,
                strokeWidth: AppSizes.ringStrokeMd,
                color: fg,
                trackColor: fg.withValues(alpha: 0.25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Fmt.percent(ring.clamp(0.0, 1.0)),
                      style: context.textStyles.titleMedium?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(ringLabel, style: context.textStyles.labelSmall?.copyWith(color: muted)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.entry, required this.board});

  final LeaderboardEntry entry;
  final LeaderboardBoard board;

  @override
  Widget build(BuildContext context) {
    final isScore = board == LeaderboardBoard.score;
    final score = entry.bestScore;
    final subtitle = isScore
        ? [
            if (score != null) Realm.of(score).label,
            'L ${entry.bestListening ?? '—'} · R ${entry.bestReading ?? '—'}',
            '${entry.fullTests} đề',
          ].join(' · ')
        : 'Đúng ${Fmt.percent(entry.weekAccuracy)}';
    final metric = isScore ? '${score ?? '—'}' : '${entry.weekQuestions} câu';

    return ListTile(
      selected: entry.isMe,
      leading: _RankBadge(rank: entry.rank!),
      title: Row(
        children: [
          Flexible(child: Text(entry.displayName, overflow: TextOverflow.ellipsis)),
          if (entry.isMe) ...[Gaps.h8, const StatusBadge(label: 'Bạn', tone: AppTone.info)],
        ],
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        metric,
        style: context.textStyles.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Ô số hạng; top 3 có màu riêng (vàng / xám / xanh) kèm icon để không chỉ dựa vào màu.
class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final tone = switch (rank) {
      1 => AppTone.warning,
      2 => AppTone.neutral,
      3 => AppTone.info,
      _ => null,
    };
    final c = tone?.colorsOf(context);
    return Semantics(
      label: 'Hạng $rank',
      child: ExcludeSemantics(
        child: Container(
          width: AppSizes.badgeMd,
          height: AppSizes.badgeMd,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c?.container ?? context.colors.surfaceContainerHigh,
          ),
          child: tone == null
              ? Text(
                  '$rank',
                  style: context.textStyles.labelLarge?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.emoji_events_rounded, size: AppSizes.iconXs, color: c!.onContainer),
                    Text(
                      '$rank',
                      style: context.textStyles.labelSmall?.copyWith(
                        color: c.onContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
