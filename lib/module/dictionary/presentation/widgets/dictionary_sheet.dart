import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../routes/app_router.dart';
import 'dictionary_browser.dart';
import 'lookup_origin.dart';

/// Tra nhanh trong sheet, không rời màn đang học (đề thi, chép chính tả…).
/// [word] = mở sẵn mục từ (bôi đen chữ → "Tra từ"); [origin] = câu chứa từ đó trong đề.
Future<void> showDictionarySheet(BuildContext context, {String? word, LookupOrigin? origin}) {
  final router = GoRouter.of(context);
  return showAppBottomSheet<void>(
    context,
    builder: (sheetContext) => LookupOriginScope(
      origin: origin,
      child: SizedBox(
        height: MediaQuery.sizeOf(sheetContext).height * _sheetHeightFactor,
        child: DictionaryBrowser(
          initialWord: word,
          autofocus: word == null,
          trailing: (current) => IconButton(
            tooltip: 'Mở trong Từ điển',
            icon: const Icon(Icons.open_in_full_rounded),
            onPressed: () {
              Navigator.pop(sheetContext);
              router.push(Routes.dictionary(word: current));
            },
          ),
        ),
      ),
    ),
  );
}

/// Sheet gần toàn màn hình: đủ chỗ cho bàn phím + gợi ý.
const _sheetHeightFactor = 0.85;

/// Nút tra từ điển nhanh cho AppBar / header các màn học.
class DictionaryButton extends StatelessWidget {
  const DictionaryButton({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Tra từ điển',
    icon: const Icon(Icons.translate_rounded),
    visualDensity: compact ? VisualDensity.compact : null,
    onPressed: () => showDictionarySheet(context),
  );
}
