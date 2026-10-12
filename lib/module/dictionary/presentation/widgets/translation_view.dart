import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/tts/tts_service.dart';
import '../../../vocab/presentation/widgets/word_lookup_sheet.dart';
import '../controllers/dictionary_controller.dart';
import 'dict_entry_view.dart';

/// Dịch đoạn chữ dài (bôi đen nhiều từ → "Dịch") trong sheet, không rời màn đang học.
Future<void> showTranslateSheet(BuildContext context, String text) => showAppBottomSheet<void>(
  context,
  builder: (sheetContext) => ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(sheetContext).height * _sheetHeightFactor,
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s8,
        AppSpacing.screen,
        AppSpacing.s32,
      ),
      child: TranslationView(text: text),
    ),
  ),
);

const _sheetHeightFactor = 0.85;

/// Bản dịch Anh → Việt: câu gốc (nghe được, bôi đen để tra từ), bản dịch (chép được),
/// đối chiếu từng câu khi có nhiều câu. Không tự cuộn.
class TranslationView extends ConsumerWidget {
  const TranslationView({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final muted = context.colors.onSurfaceVariant;
    final label = context.textStyles.labelLarge?.copyWith(color: muted);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Tiếng Anh', style: label)),
                  IconButton(
                    tooltip: 'Nghe câu gốc',
                    icon: const Icon(Icons.volume_up_outlined),
                    onPressed: () => ref.read(ttsServiceProvider).speak(text),
                  ),
                ],
              ),
              SelectableText(
                text.trim(),
                style: context.textStyles.bodyLarge,
                contextMenuBuilder: lookupContextMenu(context),
              ),
            ],
          ),
        ),
        Gaps.v12,
        ref
            .watch(translationProvider(text))
            .when(
              loading: () => const DictSkeleton(),
              error: (e, _) => DictInlineError(
                message: AppException.from(e).message,
                onRetry: () => ref.invalidate(translationProvider(text)),
              ),
              data: (t) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    tone: AppTone.info,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Tiếng Việt',
                                style: label?.copyWith(
                                  color: AppTone.info.colorsOf(context).onContainer,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Chép bản dịch',
                              icon: const Icon(Icons.copy_rounded),
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(text: t.text));
                                if (context.mounted) showAppSnackBar(context, 'Đã chép bản dịch');
                              },
                            ),
                          ],
                        ),
                        SelectableText(
                          t.text,
                          style: context.textStyles.bodyLarge?.copyWith(
                            color: AppTone.info.colorsOf(context).onContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (t.sentences.length > 1) ...[
                    Gaps.v24,
                    const SectionHeader(title: 'Đối chiếu từng câu'),
                    AppListGroup(
                      children: [
                        for (final s in t.sentences)
                          Padding(
                            padding: AppInsets.card,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.source.trim(),
                                  style: context.textStyles.bodyMedium?.copyWith(color: muted),
                                ),
                                Gaps.v4,
                                Text(s.text.trim(), style: context.textStyles.bodyLarge),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
        Gaps.v16,
        Text(
          'Dịch máy bằng Google Dịch, có thể chưa sát ngữ cảnh. Bôi đen từ trong câu gốc để tra nghĩa.',
          style: context.textStyles.bodySmall?.copyWith(color: muted),
        ),
      ],
    );
  }
}
