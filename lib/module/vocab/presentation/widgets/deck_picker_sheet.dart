import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../data/vocab_decks.dart';
import '../controllers/vocab_controller.dart';

/// Chọn bộ từ đang học: theo đề ETS (học đúng từ của đề sắp làm) hoặc theo chủ đề.
Future<void> showDeckPicker(BuildContext context) =>
    showAppBottomSheet<void>(context, builder: (_) => const _DeckPicker());

class _DeckPicker extends ConsumerStatefulWidget {
  const _DeckPicker();

  @override
  ConsumerState<_DeckPicker> createState() => _DeckPickerState();
}

class _DeckPickerState extends ConsumerState<_DeckPicker> {
  DeckKind? _kind;

  Future<void> _select(VocabDeck? deck) async {
    await ref.read(currentDeckProvider.notifier).select(deck);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final overview = ref.watch(vocabOverviewProvider).value;
    if (overview == null) {
      return const SizedBox(height: AppSizes.ringLg, child: AppLoadingView());
    }
    final current = overview.deck;
    final kind = _kind ?? current?.kind ?? DeckKind.test;
    final decks = overview.decks.where((d) => d.deck!.kind == kind).toList();

    Widget tile(DeckStats s, {String? title}) {
      final selected = s.deck == current;
      return ListTile(
        selected: selected,
        title: Text(title ?? s.deck!.label),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s4),
          child: LabeledProgress(
            label: '${s.mastered}/${s.total} đã thuộc',
            value: s.progress,
            trailing: '${s.fresh} chưa học',
          ),
        ),
        trailing: Icon(
          selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
          color: selected ? context.colors.primary : context.colors.onSurfaceVariant,
        ),
        onTap: () => _select(s.deck),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.s16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Chọn bộ từ', style: context.textStyles.titleLarge),
            Gaps.v12,
            SegmentedButton<DeckKind>(
              segments: const [
                ButtonSegment(value: DeckKind.test, label: Text('Theo đề ETS')),
                ButtonSegment(value: DeckKind.topic, label: Text('Theo chủ đề')),
              ],
              selected: {kind},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() => _kind = s.first),
            ),
            Gaps.v12,
            Flexible(
              child: SingleChildScrollView(
                child: AppListGroup(
                  children: [
                    tile(overview.bank, title: 'Tất cả (theo thứ tự đề)'),
                    for (final d in decks) tile(d),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
