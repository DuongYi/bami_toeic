import 'package:flutter/material.dart';

import '../../../dictionary/presentation/controllers/dictionary_controller.dart';
import '../../../dictionary/presentation/widgets/dictionary_sheet.dart';
import '../../../dictionary/presentation/widgets/translation_view.dart';

/// Menu bôi đen chữ có thêm nút "Tra từ" (≤ 4 từ), "Dịch" (≥ 2 từ) và "Highlight"
/// (dùng cho SelectableText trong đề).
EditableTextContextMenuBuilder lookupContextMenu(
  BuildContext pageContext, {
  bool Function(String text)? isHighlighted,
  void Function(String text)? onToggleHighlight,
}) => (context, state) {
  final value = state.textEditingValue;
  final selected = value.selection.textInside(value.text).trim();
  final isHl = isHighlighted?.call(selected) ?? false;
  final words = wordCount(selected);
  return AdaptiveTextSelectionToolbar.buttonItems(
    anchors: state.contextMenuAnchors,
    buttonItems: [
      if (words > 0 && words <= maxLookupWords)
        ContextMenuButtonItem(
          label: 'Tra từ',
          onPressed: () {
            ContextMenuController.removeAny();
            state.hideToolbar();
            showWordLookup(pageContext, selected);
          },
        ),
      if (words >= 2)
        ContextMenuButtonItem(
          label: 'Dịch',
          onPressed: () {
            ContextMenuController.removeAny();
            state.hideToolbar();
            showTranslateSheet(pageContext, selected);
          },
        ),
      if (selected.isNotEmpty && onToggleHighlight != null)
        ContextMenuButtonItem(
          label: isHl ? 'Bỏ highlight' : 'Highlight',
          onPressed: () {
            ContextMenuController.removeAny();
            state.hideToolbar();
            onToggleHighlight(selected);
          },
        ),
      ...state.contextMenuButtonItems,
    ],
  );
};

/// Tra [text] trong từ điển (kèm từ khớp trong kho ETS) bằng sheet, không rời màn đang học.
Future<void> showWordLookup(BuildContext context, String text) =>
    showDictionarySheet(context, word: text);
