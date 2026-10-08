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
      appBar: AppBar(title: const Text('Từ vựng')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Thêm từ',
        onPressed: () => showVocabForm(context, defaultTopic: topic),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(vocabListProvider.future),
        child: AsyncView(
          value: overview,
          onRetry: () => ref.invalidate(vocabListProvider),
          data: (o) => _VocabBody(overview: o, topic: topic),
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

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.s8,
            AppSpacing.screen,
            0,
          ),
          sliver: SliverList.list(
            children: [
              AppCard(
                tone: AppTone.info,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ôn tập hôm nay', style: context.textStyles.titleMedium),
                          Gaps.v4,
                          Text('${o.dueCount} từ đến hạn · ${o.newCount} từ mới'),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: o.sessionSize == 0 ? null : () => _startSession(context, ref),
                      child: Text(o.sessionSize == 0 ? 'Xong rồi 🎉' : 'Học ${o.sessionSize}'),
                    ),
                  ],
                ),
              ),
              Gaps.v12,
              TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Tìm từ hoặc nghĩa',
                  isDense: true,
                ),
                onChanged: filter.setQuery,
              ),
              Gaps.v8,
              SizedBox(
                height: AppSizes.touchTarget,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final t in [null, ...o.topics])
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.s8),
                        child: ChoiceChip(
                          label: Text(t ?? 'Tất cả (${o.total})'),
                          selected: topic == t,
                          onSelected: (_) => filter.setTopic(t),
                        ),
                      ),
                  ],
                ),
              ),
            ],
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
            padding: AppInsets.listBottomForFab,
            sliver: SliverList.builder(
              itemCount: o.shown.length,
              itemBuilder: (context, i) {
                final v = o.shown[i];
                return ListTile(
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: v.word,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (v.ipa != null)
                          TextSpan(
                            text: '  ${v.ipa}',
                            style: TextStyle(color: context.colors.onSurfaceVariant),
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
