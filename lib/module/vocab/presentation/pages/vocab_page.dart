import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/async_view.dart';
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
    final theme = Theme.of(context);
    final o = overview;
    final filter = ref.read(vocabFilterProvider.notifier);
    final now = DateTime.now();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          sliver: SliverList.list(
            children: [
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ôn tập hôm nay', style: theme.textTheme.titleMedium),
                            const SizedBox(height: 4),
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
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Tìm từ hoặc nghĩa',
                  isDense: true,
                ),
                onChanged: filter.setQuery,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final t in [null, ...o.topics])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
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
            child: EmptyView(
              icon: Icons.style_outlined,
              message: 'Chưa có từ nào.\nBấm + để thêm, hoặc import CSV trên Supabase.',
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 88),
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
                            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
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
    final scheme = Theme.of(context).colorScheme;
    final (String text, Color color) = item.isNew
        ? ('Mới', scheme.tertiary)
        : item.isDue(now)
        ? ('Ôn', scheme.error)
        : ('${item.review!.dueAt.difference(now).inDays + 1}d', scheme.outline);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}
