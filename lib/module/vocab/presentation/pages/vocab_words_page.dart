import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../plan/presentation/controllers/plan_controller.dart';
import '../../data/models/vocab_models.dart';
import '../../data/vocab_decks.dart';
import '../controllers/vocab_controller.dart';
import '../widgets/word_detail_sheet.dart';
import 'vocab_form_sheet.dart';

/// Danh sách từ của 1 bộ (hoặc cả kho): tìm, lọc theo trạng thái, chạm để xem chi tiết.
class VocabWordsPage extends ConsumerStatefulWidget {
  const VocabWordsPage({super.key, this.deckKey});

  /// null = cả kho.
  final String? deckKey;

  @override
  ConsumerState<VocabWordsPage> createState() => _VocabWordsPageState();
}

class _VocabWordsPageState extends ConsumerState<VocabWordsPage> {
  late final VocabDeck? _deck = VocabDeck.parse(widget.deckKey);
  WordFilter _filter = WordFilter.all;
  String _query = '';

  Future<void> _learnThisDeck() async {
    await ref.read(currentDeckProvider.notifier).select(_deck);
    if (mounted) {
      showAppSnackBar(context, 'Đang học bộ "${_deck!.label}"', tone: AppTone.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(vocabListProvider);
    final current = ref.watch(currentDeckProvider).value;
    final isAdmin = ref.watch(myPlanProvider).value?.isAdmin ?? false;
    final deck = _deck;
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(deck?.label ?? 'Tất cả từ vựng'),
        actions: [
          if (deck != null && deck != current)
            TextButton(onPressed: _learnThisDeck, child: const Text('Học bộ này')),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              tooltip: 'Thêm từ (admin)',
              onPressed: () => showVocabForm(context, defaultTopic: deck?.topic),
              child: const Icon(Icons.add_rounded),
            )
          : null,
      body: items.when(
        skipLoadingOnRefresh: true,
        loading: () => const AppLoadingView(),
        error: (e, _) => AppErrorView(
          message: AppException.from(e).message,
          onRetry: () => ref.invalidate(vocabListProvider),
        ),
        data: (all) {
          final shown = filterWords(all, deck: deck, filter: _filter, query: _query, now: now);
          return CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.s8,
                  AppSpacing.screen,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: 'Tìm từ hoặc nghĩa',
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: AppSizes.touchTarget + AppSpacing.s24,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screen,
                      vertical: AppSpacing.s12,
                    ),
                    itemCount: WordFilter.values.length,
                    separatorBuilder: (_, _) => Gaps.h8,
                    itemBuilder: (_, i) {
                      final f = WordFilter.values[i];
                      return ChoiceChip(
                        label: Text(f.label),
                        selected: _filter == f,
                        onSelected: (_) => setState(() => _filter = f),
                      );
                    },
                  ),
                ),
              ),
              if (shown.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyView(
                    icon: Icons.search_off_rounded,
                    message: 'Không có từ nào khớp.\nThử bỏ bộ lọc hoặc đổi từ khoá.',
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    0,
                    AppSpacing.screen,
                    AppSpacing.fabClearance,
                  ),
                  // Dựng lười: kho có thể > 1000 từ.
                  sliver: AppSliverListGroup(
                    itemCount: shown.length,
                    itemBuilder: (context, i) => _WordTile(item: shown[i], now: now),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _WordTile extends StatelessWidget {
  const _WordTile({required this.item, required this.now});

  final VocabItem item;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final v = item;
    return ListTile(
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: v.word),
            if (v.ipa case final ipa? when ipa.isNotEmpty)
              TextSpan(
                text: '  $ipa',
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
      subtitle: Text(
        [if (v.pos case final pos? when pos.isNotEmpty) '($pos)', v.meaning].join(' '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: WordStatusBadge(item: v, now: now),
      onTap: () => showWordDetail(context, v),
    );
  }
}

/// Nhãn trạng thái của 1 từ trong danh sách.
class WordStatusBadge extends StatelessWidget {
  const WordStatusBadge({super.key, required this.item, required this.now});

  final VocabItem item;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    if (item.isNew) return const StatusBadge(label: 'Mới', tone: AppTone.info);
    if (item.isMastered) {
      return const StatusBadge(label: 'Đã thuộc', tone: AppTone.success, icon: Icons.check_rounded);
    }
    if (item.isDue(now)) return const StatusBadge(label: 'Cần ôn', tone: AppTone.warning);
    // Làm tròn lên theo giờ: còn 30 giờ → "2 ngày".
    final hours = item.review!.dueAt.difference(now).inHours;
    final days = (hours / 24).ceil().clamp(1, 9999);
    return StatusBadge(label: '$days ngày');
  }
}
