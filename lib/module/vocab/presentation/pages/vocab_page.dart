import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../helper/format.dart';
import '../../../../routes/app_router.dart';
import '../../../plan/presentation/controllers/plan_controller.dart';
import '../../../plan/presentation/widgets/header_badges.dart';
import '../../data/practice.dart';
import '../../data/vocab_decks.dart';
import '../controllers/vocab_controller.dart';
import '../widgets/deck_picker_sheet.dart';
import 'vocab_form_sheet.dart';

/// Tab Từ vựng: việc hôm nay (ôn + từ mới theo chỉ tiêu) → bộ từ đang học → luyện chủ động → tra cứu.
class VocabPage extends ConsumerWidget {
  const VocabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(vocabOverviewProvider);
    final isAdmin = ref.watch(myPlanProvider).value?.isAdmin ?? false;
    return Scaffold(
      // Scaffold lồng trong tab không tự tránh thanh tab nổi → nâng nút lên trên thanh.
      floatingActionButton: isAdmin
          ? Padding(
              padding: EdgeInsets.only(bottom: AppGlassTabBar.inset(context)),
              child: FloatingActionButton(
                tooltip: 'Thêm từ (admin)',
                onPressed: () => showVocabForm(context),
                child: const Icon(Icons.add_rounded),
              ),
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(vocabListProvider.future),
          child: AsyncView(
            value: overview,
            loading: (_) => const VocabSkeleton(),
            onRetry: () => ref.invalidate(vocabListProvider),
            data: (o) => _VocabBody(o: o),
          ),
        ),
      ),
    );
  }
}

class _VocabBody extends ConsumerWidget {
  const _VocabBody({required this.o});

  final VocabOverview o;

  Future<void> _study(BuildContext context, WidgetRef ref, {int extra = 0}) async {
    await context.push(Routes.flashcards(extra: extra));
    // Cập nhật số từ đến hạn / tiến độ sau phiên học.
    ref.invalidate(vocabListProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.fabClearance + AppGlassTabBar.inset(context),
      ),
      children: [
        const AppPageHeader(
          overline: 'HỌC TỪ THEO ĐỀ ETS',
          title: 'Từ vựng',
          subtitle: 'Mỗi ngày một ít, ôn đúng lúc sắp quên',
          topBar: HeaderBadges(),
        ),
        _TodayCard(
          o: o,
          onStudy: () => _study(context, ref),
          onExtra: () => _study(context, ref, extra: extraNewWords),
        ),
        Gaps.v16,
        AppCard(
          child: Row(
            children: [
              StatTile(value: '${o.bank.mastered}', label: 'Đã thuộc', highlight: true),
              StatTile(value: '${o.bank.learning}', label: 'Đang học'),
              StatTile(value: '${o.bank.fresh}', label: 'Chưa học'),
            ],
          ),
        ),
        Gaps.v24,
        SectionHeader(
          title: 'Bộ từ đang học',
          subtitle: 'Từ mới mỗi ngày lấy từ bộ này, theo thứ tự xuất hiện trong đề',
          trailing: TextButton(
            onPressed: () => showDeckPicker(context),
            child: const Text('Đổi bộ'),
          ),
        ),
        _DeckCard(stats: o.deckStats),
        Gaps.v24,
        const SectionHeader(
          title: 'Luyện chủ động',
          subtitle: 'Tự nhớ lại thay vì chỉ lật thẻ – nhớ lâu hơn',
        ),
        AppListGroup(
          dividerIndent: AppSpacing.s16 + AppSizes.badgeMd + AppSpacing.s16,
          children: [
            for (final m in PracticeMode.values)
              ListTile(
                leading: IconBadge(icon: _modeIcon(m), tone: _modeTone(m)),
                title: Text(m.label),
                subtitle: Text(m.description),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(Routes.vocabPractice(m.name)),
              ),
          ],
        ),
        Gaps.v24,
        const SectionHeader(title: 'Tra cứu'),
        AppListGroup(
          children: [
            ListTile(
              leading: const IconBadge(icon: Icons.menu_book_rounded, tone: AppTone.neutral),
              title: const Text('Tất cả từ vựng'),
              subtitle: Text('${o.bank.total} từ · tìm theo từ hoặc nghĩa'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(Routes.vocabWords()),
            ),
          ],
        ),
      ],
    );
  }

  static IconData _modeIcon(PracticeMode m) => switch (m) {
    PracticeMode.meaning => Icons.translate_rounded,
    PracticeMode.listen => Icons.hearing_rounded,
    PracticeMode.cloze => Icons.short_text_rounded,
    PracticeMode.spell => Icons.keyboard_rounded,
  };

  static AppTone _modeTone(PracticeMode m) => switch (m) {
    PracticeMode.meaning => AppTone.info,
    PracticeMode.listen => AppTone.success,
    PracticeMode.cloze => AppTone.warning,
    PracticeMode.spell => AppTone.neutral,
  };
}

/// Việc hôm nay: số thẻ cần ôn + từ mới còn trong chỉ tiêu; hết thì "Xong hôm nay".
class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.o, required this.onStudy, required this.onExtra});

  final VocabOverview o;
  final VoidCallback onStudy;
  final VoidCallback onExtra;

  @override
  Widget build(BuildContext context) {
    final fg = AppHeroCard.foreground(context);
    final muted = fg.withValues(alpha: 0.85);
    final newRatio = o.dailyNew == 0 ? 1.0 : (o.newToday / o.dailyNew).clamp(0.0, 1.0);
    final button = FilledButton.styleFrom(
      backgroundColor: fg,
      foregroundColor: context.surfaces.hero.first,
      minimumSize: const Size.fromHeight(AppSizes.touchTarget),
    );

    return AppHeroCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  o.doneToday ? 'Xong hôm nay' : 'Hôm nay',
                  style: context.textStyles.labelLarge?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  o.doneToday ? 'Tuyệt vời!' : '${o.todayCount} thẻ',
                  style: context.textStyles.displaySmall?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Gaps.v4,
                Text(
                  o.doneToday
                      ? (o.deckFreshLeft == 0
                            ? 'Đã học hết bộ này. Đổi bộ khác để học tiếp.'
                            : 'Đã ôn hết và đủ ${o.dailyNew} từ mới. Quay lại ngày mai nhé.')
                      : '${o.dueCount} thẻ cần ôn · ${o.newLeft} từ mới',
                  style: context.textStyles.bodySmall?.copyWith(color: muted),
                ),
                Gaps.v16,
                if (!o.doneToday)
                  FilledButton.icon(
                    style: button,
                    onPressed: onStudy,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Bắt đầu học'),
                  )
                else if (o.deckFreshLeft > 0)
                  FilledButton.icon(
                    style: button,
                    onPressed: onExtra,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Học thêm $extraNewWords từ mới'),
                  ),
              ],
            ),
          ),
          Gaps.h16,
          ScoreRing(
            value: newRatio,
            size: AppSizes.ringMd,
            strokeWidth: AppSizes.ringStrokeMd,
            color: fg,
            trackColor: fg.withValues(alpha: 0.25),
            semanticLabel: 'Từ mới hôm nay ${o.newToday} trên ${o.dailyNew}',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${o.newToday}/${o.dailyNew}',
                  style: context.textStyles.titleMedium?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text('từ mới', style: context.textStyles.labelSmall?.copyWith(color: muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeckCard extends StatelessWidget {
  const _DeckCard({required this.stats});

  final DeckStats stats;

  @override
  Widget build(BuildContext context) {
    final deck = stats.deck;
    return AppCard(
      onTap: () => context.push(Routes.vocabWords(deck: deck?.key)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadge(
                icon: deck?.kind == DeckKind.topic ? Icons.category_outlined : Icons.quiz_outlined,
              ),
              Gaps.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(deck?.label ?? 'Tất cả đề ETS 2026', style: context.textStyles.titleMedium),
                    Text(
                      '${stats.mastered}/${stats.total} đã thuộc · ${stats.fresh} chưa học',
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
          Gaps.v12,
          LabeledProgress(
            label: 'Tiến độ',
            value: stats.progress,
            trailing: Fmt.percent(stats.progress),
          ),
        ],
      ),
    );
  }
}
