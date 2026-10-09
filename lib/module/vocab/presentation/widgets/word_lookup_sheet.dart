import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/tts/tts_service.dart';
import '../../../../helper/word_match.dart';
import '../../../plan/presentation/controllers/plan_controller.dart';
import '../../data/models/vocab_models.dart';
import '../controllers/vocab_controller.dart';
import '../../data/vocab_decks.dart';
import '../pages/vocab_form_sheet.dart';
import 'word_detail_sheet.dart';

/// Menu bôi đen chữ có thêm nút "Tra từ" (dùng cho SelectableText trong đề).
EditableTextContextMenuBuilder lookupContextMenu(BuildContext pageContext) => (context, state) {
  final value = state.textEditingValue;
  final selected = value.selection.textInside(value.text).trim();
  return AdaptiveTextSelectionToolbar.buttonItems(
    anchors: state.contextMenuAnchors,
    buttonItems: [
      if (selected.isNotEmpty && selected.split(RegExp(r'\s+')).length <= 4)
        ContextMenuButtonItem(
          label: 'Tra từ',
          onPressed: () {
            ContextMenuController.removeAny();
            state.hideToolbar();
            showWordLookup(pageContext, selected);
          },
        ),
      ...state.contextMenuButtonItems,
    ],
  );
};

/// Tra [text] trong sổ từ vựng; chưa có thì gợi ý thêm vào sổ.
Future<void> showWordLookup(BuildContext context, String text) =>
    showAppBottomSheet<void>(context, builder: (_) => _LookupSheet(query: text));

class _LookupSheet extends ConsumerWidget {
  const _LookupSheet({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocab = ref.watch(vocabListProvider);
    final isAdmin = ref.watch(myPlanProvider).value?.isAdmin ?? false;
    final word = WordMatch.normalize(query);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.s16),
        child: AsyncView(
          value: vocab,
          onRetry: () => ref.invalidate(vocabListProvider),
          data: (all) {
            final matches = WordMatch.find(all, query, (v) => v.word).take(3).toList();
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Tra từ "$word"', style: context.textStyles.titleLarge),
                    ),
                    IconButton(
                      tooltip: 'Nghe phát âm',
                      icon: const Icon(Icons.volume_up_outlined),
                      onPressed: () => ref.read(ttsServiceProvider).speak(word),
                    ),
                  ],
                ),
                Gaps.v12,
                if (matches.isEmpty)
                  const AppBanner(message: 'Từ này chưa có trong kho từ vựng của Bami TOEIC.')
                else
                  for (final v in matches) ...[_Entry(item: v), Gaps.v8],
                if (isAdmin) ...[
                  Gaps.v8,
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add_rounded),
                    label: Text(matches.isEmpty ? 'Thêm "$word" vào kho (admin)' : 'Thêm nghĩa khác'),
                    onPressed: () {
                      Navigator.pop(context);
                      showVocabForm(context, initialWord: word);
                    },
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry({required this.item});

  final VocabItem item;

  @override
  Widget build(BuildContext context) {
    final muted = context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant);
    return AppCard(
      onTap: () {
        Navigator.pop(context);
        showWordDetail(context, item);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.s8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(item.word, style: context.textStyles.titleMedium),
              if (item.ipa case final ipa? when ipa.isNotEmpty) Text(ipa, style: muted),
              if (item.pos case final pos? when pos.isNotEmpty)
                StatusBadge(label: pos, tone: AppTone.neutral),
            ],
          ),
          Gaps.v4,
          Text(item.meaning, style: context.textStyles.bodyLarge),
          if (item.example case final ex? when ex.isNotEmpty) ...[
            Gaps.v8,
            Text(ex, style: context.textStyles.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
            if (item.exampleMeaning case final exVi? when exVi.isNotEmpty) Text(exVi, style: muted),
          ],
          Gaps.v8,
          StatusBadge(
            label: switch (item) {
              _ when item.isMastered => 'Đã thuộc · ${topicLabel(item.topic)}',
              _ when item.isNew => 'Chưa học · ${topicLabel(item.topic)}',
              _ => 'Đang học · ${topicLabel(item.topic)}',
            },
            tone: item.isMastered
                ? AppTone.success
                : (item.isNew ? AppTone.info : AppTone.warning),
          ),
        ],
      ),
    );
  }
}
