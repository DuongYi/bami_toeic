import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/async_view.dart';
import '../../../routes/app_router.dart';
import '../vocab_repository.dart';
import 'flashcard_page.dart';
import 'vocab_form_sheet.dart';

class VocabPage extends ConsumerStatefulWidget {
  const VocabPage({super.key});

  @override
  ConsumerState<VocabPage> createState() => _VocabPageState();
}

class _VocabPageState extends ConsumerState<VocabPage> {
  String? _topic;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final vocab = ref.watch(vocabListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Từ vựng')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Thêm từ',
        onPressed: () => showVocabForm(context, defaultTopic: _topic),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(vocabListProvider.future),
        child: AsyncView(
          value: vocab,
          onRetry: () => ref.invalidate(vocabListProvider),
          data: _buildBody,
        ),
      ),
    );
  }

  Widget _buildBody(List<VocabItem> all) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final topics = all.map((v) => v.topic).toSet().toList()..sort();
    final inTopic = _topic == null ? all : all.where((v) => v.topic == _topic).toList();
    final q = _query.toLowerCase();
    final shown = q.isEmpty
        ? inTopic
        : inTopic
              .where((v) => v.word.toLowerCase().contains(q) || v.meaning.toLowerCase().contains(q))
              .toList();
    final session = buildSession(inTopic, now);
    final due = inTopic.where((v) => v.isDue(now)).length;
    final newCount = inTopic.where((v) => v.isNew).length;

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
                            Text('$due từ đến hạn · $newCount từ mới'),
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: session.isEmpty
                            ? null
                            : () async {
                                await context.push(Routes.flashcards(topic: _topic));
                                // Cập nhật số từ đến hạn sau phiên học.
                                ref.invalidate(vocabListProvider);
                              },
                        child: Text(session.isEmpty ? 'Xong rồi 🎉' : 'Học ${session.length}'),
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
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final t in [null, ...topics])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(t ?? 'Tất cả (${all.length})'),
                          selected: _topic == t,
                          onSelected: (_) => setState(() => _topic = t),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (shown.isEmpty)
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
              itemCount: shown.length,
              itemBuilder: (context, i) {
                final v = shown[i];
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
