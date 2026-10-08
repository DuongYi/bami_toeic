import 'package:flutter/material.dart';

import '../../../config/theme.dart';
import '../models.dart';
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
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        Text(
          partNames[group.part] ?? 'Part ${group.part}',
          style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 8),
        if (group.audioUrl != null) ...[
          AudioBar(url: group.audioUrl!, autoPlay: autoPlayAudio),
          const SizedBox(height: 8),
        ],
        if (group.imageUrl != null) ...[
          _ZoomableImage(url: group.imageUrl!),
          const SizedBox(height: 12),
        ],
        if (group.passage != null && group.passage!.trim().isNotEmpty) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                group.passage!,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (showTranscript && group.transcript != null) ...[
          ExpansionTile(
            title: const Text('Transcript'),
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(bottom: 12),
            children: [SelectableText(group.transcript!, style: theme.textTheme.bodyMedium)],
          ),
        ],
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final q = question;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
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
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final (i, letter) in q.letters.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _OptionButton(
                letter: letter,
                text: q.optionText(i),
                selected: chosen == letter,
                status: !revealed
                    ? null
                    : letter == q.answer
                    ? true
                    : chosen == letter
                    ? false
                    : null,
                onTap: onSelect == null || revealed ? null : () => onSelect!(q, letter),
              ),
            ),
          if (revealed) ...[
            if (chosen == null)
              Text(
                'Bạn bỏ trống · Đáp án: ${q.answer}',
                style: TextStyle(color: scheme.error, fontWeight: FontWeight.w600),
              ),
            if (q.explanation != null && q.explanation!.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('💡 ${q.explanation}', style: theme.textTheme.bodyMedium),
              ),
          ],
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.letter,
    required this.text,
    required this.selected,
    required this.status,
    required this.onTap,
  });

  final String letter;
  final String text;
  final bool selected;

  /// true = đáp án đúng, false = chọn sai, null = bình thường
  final bool? status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color border = switch (status) {
      true => AppTheme.correct,
      false => AppTheme.wrong,
      null => selected ? scheme.primary : scheme.outlineVariant,
    };
    final Color fill = switch (status) {
      true => AppTheme.correct.withValues(alpha: 0.12),
      false => AppTheme.wrong.withValues(alpha: 0.12),
      null => selected ? scheme.primaryContainer : Colors.transparent,
    };

    return Material(
      color: fill,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: border, width: selected || status != null ? 2 : 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: selected || status != null
                      ? border
                      : scheme.surfaceContainerHighest,
                  foregroundColor: selected || status != null ? Colors.white : scheme.onSurface,
                  child: Text(letter, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(text)),
                if (status == true) const Icon(Icons.check_circle, color: AppTheme.correct),
                if (status == false) const Icon(Icons.cancel, color: AppTheme.wrong),
              ],
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
    return GestureDetector(
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => Dialog.fullscreen(
          child: Stack(
            children: [
              InteractiveViewer(maxScale: 5, child: Center(child: Image.network(url))),
              Positioned(
                top: 8,
                right: 8,
                child: SafeArea(
                  child: IconButton.filled(
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
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, progress) => progress == null
              ? child
              : const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
          errorBuilder: (_, _, _) =>
              const SizedBox(height: 120, child: Center(child: Text('Không tải được ảnh'))),
        ),
      ),
    );
  }
}
