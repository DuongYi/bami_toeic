import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';
import '../../data/models/test_models.dart';
import 'audio_bar.dart';

const partNames = {
  1: 'Part 1 · Mô tả tranh',
  2: 'Part 2 · Hỏi - Đáp',
  3: 'Part 3 · Hội thoại',
  4: 'Part 4 · Bài nói',
  5: 'Part 5 · Hoàn thành câu',
  6: 'Part 6 · Hoàn thành đoạn văn',
  7: 'Part 7 · Đọc hiểu',
};

/// Hiển thị một nhóm câu hỏi: audio, ảnh, đoạn văn và các câu hỏi.
class QuestionGroupView extends StatelessWidget {
  const QuestionGroupView({
    super.key,
    required this.group,
    required this.answers,
    this.onSelect,
    this.isRevealed,
    this.showTranscript = false,
    this.autoPlayAudio = false,
  });

  final QuestionGroup group;
  final Map<String, String?> answers;

  /// null = chỉ xem (chế độ xem lại)
  final void Function(Question q, String letter)? onSelect;

  /// Câu nào đã được hiện đáp án đúng/sai
  final bool Function(Question q)? isRevealed;
  final bool showTranscript;
  final bool autoPlayAudio;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s8,
        AppSpacing.screen,
        AppSpacing.s32,
      ),
      children: [
        Semantics(
          header: true,
          child: Text(
            partNames[group.part] ?? 'Part ${group.part}',
            style: context.textStyles.labelLarge?.copyWith(color: context.colors.primary),
          ),
        ),
        Gaps.v8,
        if (group.audioUrl != null) ...[
          AudioBar(url: group.audioUrl!, autoPlay: autoPlayAudio),
          Gaps.v8,
        ],
        if (group.imageUrl != null) ...[_ZoomableImage(url: group.imageUrl!), Gaps.v12],
        if (group.passage != null && group.passage!.trim().isNotEmpty) ...[
          AppCard(child: SelectableText(group.passage!, style: context.textStyles.bodyLarge)),
          Gaps.v12,
        ],
        if (showTranscript && group.transcript != null)
          ExpansionTile(
            title: const Text('Transcript'),
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(bottom: AppSpacing.s12),
            children: [SelectableText(group.transcript!)],
          ),
        for (final q in group.questions)
          _QuestionTile(
            question: q,
            chosen: answers[q.id],
            onSelect: onSelect,
            revealed: isRevealed?.call(q) ?? false,
          ),
      ],
    );
  }
}

class _QuestionTile extends StatelessWidget {
  const _QuestionTile({
    required this.question,
    required this.chosen,
    required this.onSelect,
    required this.revealed,
  });

  final Question question;
  final String? chosen;
  final void Function(Question q, String letter)? onSelect;
  final bool revealed;

  @override
  Widget build(BuildContext context) {
    final q = question;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${q.number}. ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (q.content != null) TextSpan(text: q.content),
              ],
            ),
            style: context.textStyles.titleMedium?.copyWith(fontWeight: FontWeight.w400),
          ),
          Gaps.v8,
          for (final (i, letter) in q.letters.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s8),
              child: AnswerOption(
                letter: letter,
                text: q.optionText(i),
                selected: chosen == letter,
                result: !revealed
                    ? null
                    : letter == q.answer
                    ? AppTone.success
                    : chosen == letter
                    ? AppTone.danger
                    : null,
                onTap: onSelect == null || revealed ? null : () => onSelect!(q, letter),
              ),
            ),
          if (revealed) ...[
            if (chosen == null)
              Text(
                'Bạn bỏ trống · Đáp án: ${q.answer}',
                style: context.textStyles.bodyMedium?.copyWith(
                  color: context.colors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (q.explanation != null && q.explanation!.isNotEmpty) ...[
              Gaps.v4,
              _Explanation(text: q.explanation!),
            ],
          ],
        ],
      ),
    );
  }
}

class _Explanation extends StatelessWidget {
  const _Explanation({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = AppTone.info.colorsOf(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(color: c.container, borderRadius: AppRadius.brMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, size: AppSizes.iconSm, color: c.onContainer),
          Gaps.h8,
          Expanded(
            child: Text(text, style: context.textStyles.bodyMedium?.copyWith(color: c.onContainer)),
          ),
        ],
      ),
    );
  }
}

/// Một lựa chọn A/B/C/D. [result]: success = đáp án đúng, danger = bạn chọn sai.
class AnswerOption extends StatelessWidget {
  const AnswerOption({
    super.key,
    required this.letter,
    required this.text,
    required this.selected,
    required this.result,
    required this.onTap,
  });

  final String letter;
  final String text;
  final bool selected;
  final AppTone? result;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tone = result?.colorsOf(context);
    final emphasized = selected || tone != null;
    final border = tone?.main ?? (selected ? cs.primary : cs.outlineVariant);
    final fill = tone?.container ?? (selected ? cs.primaryContainer : cs.surface);
    final onFill = tone?.onContainer ?? (selected ? cs.onPrimaryContainer : cs.onSurface);

    final resultLabel = switch (result) {
      AppTone.success => ', đáp án đúng',
      AppTone.danger => ', bạn chọn sai',
      _ => '',
    };

    return Semantics(
      button: onTap != null,
      selected: selected,
      label: 'Đáp án $letter${text.isEmpty ? '' : ': $text'}$resultLabel',
      excludeSemantics: true,
      child: Material(
        color: fill,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: border, width: emphasized ? 2 : 1),
          borderRadius: AppRadius.brMd,
        ),
        child: InkWell(
          borderRadius: AppRadius.brMd,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.touchTarget),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s12,
                vertical: AppSpacing.s8,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: AppSizes.avatarSm / 2,
                    backgroundColor: emphasized ? border : cs.surfaceContainerHighest,
                    foregroundColor: emphasized ? tone?.onMain ?? cs.onPrimary : cs.onSurface,
                    child: Text(letter, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Gaps.h12,
                  Expanded(
                    child: Text(text, style: TextStyle(color: onFill)),
                  ),
                  if (result != null) Icon(result!.icon, color: tone!.main),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ZoomableImage extends StatelessWidget {
  const _ZoomableImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Hình minh hoạ, chạm để phóng to',
      child: GestureDetector(
        onTap: () => showDialog<void>(
          context: context,
          builder: (_) => Dialog.fullscreen(
            child: Stack(
              children: [
                InteractiveViewer(maxScale: 5, child: Center(child: Image.network(url))),
                Positioned(
                  top: AppSpacing.s8,
                  right: AppSpacing.s8,
                  child: SafeArea(
                    child: IconButton.filled(
                      tooltip: 'Đóng',
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: AppRadius.brMd,
          child: Image.network(
            url,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) => progress == null
                ? child
                : const SizedBox(height: AppSizes.imagePlaceholder, child: AppLoadingView()),
            errorBuilder: (_, _, _) => const SizedBox(
              height: AppSizes.imagePlaceholder,
              child: AppErrorView(message: 'Không tải được ảnh'),
            ),
          ),
        ),
      ),
    );
  }
}
