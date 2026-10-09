import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../routes/app_router.dart';
import '../../data/models/vocab_models.dart';
import '../controllers/vocab_controller.dart';
import 'vocab_form_sheet.dart';

class VocabPage extends ConsumerWidget {
  const VocabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(vocabOverviewProvider);
    final topic = ref.watch(vocabFilterProvider.select((f) => f.topic));
    return Scaffold(
      // Scaffold lồng trong tab không tự tránh thanh tab nổi → nâng nút lên trên thanh.
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: AppGlassTabBar.inset(context)),
        child: FloatingActionButton(
          tooltip: 'Thêm từ',
          onPressed: () => showVocabForm(context, defaultTopic: topic),
          child: const Icon(Icons.add_rounded),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(vocabListProvider.future),
          child: AsyncView(
            value: overview,
            loading: (_) => const VocabSkeleton(),
            onRetry: () => ref.invalidate(vocabListProvider),
            data: (o) => _VocabBody(overview: o, topic: topic),
          ),
        ),
      ),
    );
  }
}

class _VocabBody extends ConsumerWidget {
  const _VocabBody({required this.overview, required this.topic});

  final VocabOverview overview;
  final String? topic;

  Future<void> _startSession(BuildContext context, WidgetRef ref) async {
    await context.push(Routes.flashcards(topic: topic));
    // Cập nhật số từ đến hạn sau phiên học.
    ref.invalidate(vocabListProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final o = overview;
    final filter = ref.read(vocabFilterProvider.notifier);
    final now = DateTime.now();
    final fg = AppHeroCard.foreground(context);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, 0),
          sliver: SliverList.list(
            children: [
              AppPageHeader(
                overline: 'HỌC TỪ THÔNG MINH',
                title: 'Từ vựng SRS',
                subtitle: 'Ghi nhớ dài hạn với thuật toán lặp lại ngắt quãng',
                topBar: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    CoinBadge(amount: 150),
                    Gaps.h8,
                    StreakBadge(count: 3),
                    Gaps.h8,
                    ProBadge(label: 'PRO', mini: true),
                  ],
                ),
              ),
              AppHeroCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ôn tập hôm nay',
                                style: context.textStyles.labelLarge?.copyWith(
                                  color: fg,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${o.sessionSize} từ',
                                style: context.textStyles.displaySmall?.copyWith(
                                  color: fg,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.style_rounded,
                          size: AppSizes.iconXl,
                          color: fg.withValues(alpha: 0.4),
                        ),
                      ],
                    ),
                    Gaps.v8,
                    Wrap(
                      spacing: AppSpacing.s8,
                      runSpacing: AppSpacing.s4,
                      children: [
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
                            '⚡️ ${o.dueCount} đến hạn',
                            style: context.textStyles.labelSmall?.copyWith(
                              color: fg,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s8,
                            vertical: AppSpacing.s2,
                          ),
                          decoration: BoxDecoration(
                            color: fg.withValues(alpha: 0.15),
                            borderRadius: AppRadius.brFull,
                          ),
                          child: Text(
                            '🌱 ${o.newCount} từ mới',
                            style: context.textStyles.labelSmall?.copyWith(
                              color: fg,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s8,
                            vertical: AppSpacing.s2,
                          ),
                          decoration: BoxDecoration(
                            color: fg.withValues(alpha: 0.15),
                            borderRadius: AppRadius.brFull,
                          ),
                          child: Text(
                            '📚 ${o.total} trong kho',
                            style: context.textStyles.labelSmall?.copyWith(
                              color: fg,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gaps.v16,
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: fg,
                        foregroundColor: context.surfaces.hero.first,
                        minimumSize: const Size.fromHeight(AppSizes.touchTarget),
                      ),
                      onPressed: o.sessionSize == 0 ? null : () => _startSession(context, ref),
                      icon: Icon(
                        o.sessionSize == 0 ? Icons.check_rounded : Icons.play_arrow_rounded,
                      ),
                      label: Text(
                        o.sessionSize == 0 ? 'Đã ôn xong hôm nay' : 'Bắt đầu học ngay',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.v16,
              TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: 'Tìm từ hoặc nghĩa',
                ),
                onChanged: filter.setQuery,
              ),
            ],
          ),
        ),
        // Chip chủ đề tràn mép màn hình, padding nằm trong danh sách cuộn ngang.
        SliverToBoxAdapter(
          child: SizedBox(
            height: AppSizes.touchTarget + AppSpacing.s24,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
                vertical: AppSpacing.s12,
              ),
              itemCount: o.topics.length + 1,
              separatorBuilder: (_, _) => Gaps.h8,
              itemBuilder: (context, i) {
                final t = i == 0 ? null : o.topics[i - 1];
                return ChoiceChip(
                  label: Text(t ?? 'Tất cả · ${o.total}'),
                  selected: topic == t,
                  onSelected: (_) => filter.setTopic(t),
                );
              },
            ),
          ),
        ),
        if (o.shown.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: AppEmptyView(
              icon: Icons.style_outlined,
              message: 'Chưa có từ nào.\nBấm + để thêm, hoặc import CSV trên Supabase.',
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screen,
              0,
              AppSpacing.screen,
              AppSpacing.fabClearance + AppGlassTabBar.inset(context),
            ),
            // Dựng lười: chỉ các dòng đang hiện (danh sách có thể > 1000 từ).
            sliver: AppSliverListGroup(
              itemCount: o.shown.length,
              itemBuilder: (context, i) {
                final v = o.shown[i];
                return ListTile(
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: v.word),
                        if (v.ipa != null)
                          TextSpan(
                            text: '  ${v.ipa}',
                            style: context.textStyles.bodySmall?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    [if (v.pos != null) '(${v.pos})', v.meaning].join(' '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: _StatusBadge(item: v, now: now),
                  onTap: () => showVocabForm(context, item: v),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.item, required this.now});

  final VocabItem item;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    if (item.isNew) return const StatusBadge(label: 'Mới', tone: AppTone.info);
    if (item.isDue(now)) return const StatusBadge(label: 'Cần ôn', tone: AppTone.warning);
    final days = item.review!.dueAt.difference(now).inDays + 1;
    return StatusBadge(label: '$days ngày');
  }
}
