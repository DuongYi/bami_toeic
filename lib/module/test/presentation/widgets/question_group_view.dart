import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/media/media_image.dart';
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
/// Hỗ trợ chia 2/3 (ngữ cảnh + câu hỏi) và 1/3 (câu trả lời / phiếu đáp án) khi quay ngang iPad.
class QuestionGroupView extends StatelessWidget {
  const QuestionGroupView({
    super.key,
    required this.group,
    required this.answers,
    this.onSelect,
    this.isRevealed,
    this.showTranscript = false,
    this.autoPlayAudio = false,
    this.showAudio = true,
    this.isFlagged,
    this.onToggleFlag,
    this.contextMenuBuilder,
    this.allGroups,
    this.currentGroupIndex,
    this.onJumpToGroup,
  });

  final QuestionGroup group;
  final Map<String, String?> answers;

  /// null = chỉ xem (chế độ xem lại)
  final void Function(Question q, String letter)? onSelect;

  /// Câu nào đã được hiện đáp án đúng/sai
  final bool Function(Question q)? isRevealed;
  final bool showTranscript;
  final bool autoPlayAudio;

  /// false khi audio do nơi khác phát (thi thử nghe liền mạch).
  final bool showAudio;

  /// Đánh dấu câu (null = không hiện nút cờ, vd. màn xem lại)
  final bool Function(Question q)? isFlagged;
  final void Function(Question q)? onToggleFlag;

  /// Menu khi bôi đen chữ (vd. thêm "Tra từ"); null = menu mặc định.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Dành cho chế độ iPad Split View: hỗ trợ xem toàn bài & nhảy câu
  final List<QuestionGroup>? allGroups;
  final int? currentGroupIndex;
  final ValueChanged<int>? onJumpToGroup;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    final isLandscape = media.width > media.height;
    // Kích hoạt split screen khi màn hình xoay ngang và chiều rộng đủ lớn (iPad / tablet / web landscape)
    final isSplitLayout = isLandscape && media.width >= 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Audio Header ghim cố định ở đỉnh màn hình:
        // KHÔNG BAO GIỜ bị cuộn trôi đi, KHÔNG BAO GIỜ bị ngắt hay phát lại từ đầu khi scroll!
        if (showAudio && group.audioUrl != null)
          _StickyAudioBar(
            url: group.audioUrl!,
            autoPlay: autoPlayAudio,
          ),
        Expanded(
          child: isSplitLayout
              ? _buildSplitLayout(context)
              : _buildSingleColumnLayout(context),
        ),
      ],
    );
  }

  /// Bố cục chia 2/3 (nội dung đề) & 1/3 (câu trả lời / phiếu đáp án) tối ưu cho iPad quay ngang
  Widget _buildSplitLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Phần 2/3 (Bên trái): Hiển thị ảnh, đoạn văn đọc hiểu và nội dung các câu hỏi
        Expanded(
          flex: 2,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.s12,
              AppSpacing.s16,
              AppSpacing.s32,
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Semantics(
                  header: true,
                  child: StatusBadge(
                    label: partNames[group.part] ?? 'Part ${group.part}',
                    tone: AppTone.info,
                    icon: group.part <= 4
                        ? Icons.headphones_rounded
                        : Icons.chrome_reader_mode_outlined,
                  ),
                ),
              ),
              Gaps.v12,
              if (group.imageUrl != null) ...[
                _ZoomableImage(url: group.imageUrl!),
                Gaps.v12,
              ],
              if (group.passage != null && group.passage!.trim().isNotEmpty) ...[
                AppCard(
                  child: SelectableText(
                    group.passage!,
                    style: context.textStyles.bodyLarge,
                    contextMenuBuilder: contextMenuBuilder,
                  ),
                ),
                Gaps.v12,
              ],
              if (showTranscript && group.transcript != null)
                ExpansionTile(
                  title: const Text('Transcript'),
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.only(bottom: AppSpacing.s12),
                  children: [
                    SelectableText(
                      group.transcript!,
                      contextMenuBuilder: contextMenuBuilder,
                    ),
                  ],
                ),
              for (final q in group.questions)
                _QuestionTile(
                  question: q,
                  chosen: answers[q.id],
                  onSelect: onSelect,
                  revealed: isRevealed?.call(q) ?? false,
                  flagged: isFlagged?.call(q) ?? false,
                  onToggleFlag: onToggleFlag,
                  contextMenuBuilder: contextMenuBuilder,
                ),
            ],
          ),
        ),
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: context.colors.outlineVariant.withValues(alpha: 0.4),
        ),
        // Phần 1/3 (Bên phải): Hiển thị câu trả lời hoặc phiếu đáp án
        Expanded(
          flex: 1,
          child: _AnswerSheetColumn(
            group: group,
            allGroups: allGroups,
            currentGroupIndex: currentGroupIndex,
            onJumpToGroup: onJumpToGroup,
            answers: answers,
            onSelect: onSelect,
            isRevealed: isRevealed,
            isFlagged: isFlagged,
            onToggleFlag: onToggleFlag,
          ),
        ),
      ],
    );
  }

  /// Bố cục 1 cột truyền thống cho điện thoại hoặc iPad chế độ dọc
  Widget _buildSingleColumnLayout(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s8,
        AppSpacing.screen,
        AppSpacing.s32,
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Semantics(
            header: true,
            child: StatusBadge(
              label: partNames[group.part] ?? 'Part ${group.part}',
              tone: AppTone.info,
              icon: group.part <= 4
                  ? Icons.headphones_rounded
                  : Icons.chrome_reader_mode_outlined,
            ),
          ),
        ),
        Gaps.v12,
        if (group.imageUrl != null) ...[
          _ZoomableImage(url: group.imageUrl!),
          Gaps.v12,
        ],
        if (group.passage != null && group.passage!.trim().isNotEmpty) ...[
          AppCard(
            child: SelectableText(
              group.passage!,
              style: context.textStyles.bodyLarge,
              contextMenuBuilder: contextMenuBuilder,
            ),
          ),
          Gaps.v12,
        ],
        if (showTranscript && group.transcript != null)
          ExpansionTile(
            title: const Text('Transcript'),
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(bottom: AppSpacing.s12),
            children: [
              SelectableText(
                group.transcript!,
                contextMenuBuilder: contextMenuBuilder,
              ),
            ],
          ),
        for (final q in group.questions)
          _QuestionTile(
            question: q,
            chosen: answers[q.id],
            onSelect: onSelect,
            revealed: isRevealed?.call(q) ?? false,
            flagged: isFlagged?.call(q) ?? false,
            onToggleFlag: onToggleFlag,
            contextMenuBuilder: contextMenuBuilder,
          ),
      ],
    );
  }
}

/// Thanh phát audio ghim cố định ở đỉnh để không bao giờ bị gián đoạn hay reset khi cuộn trang
class _StickyAudioBar extends StatelessWidget {
  const _StickyAudioBar({
    required this.url,
    required this.autoPlay,
  });

  final String url;
  final bool autoPlay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s8,
        AppSpacing.screen,
        AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(
          bottom: BorderSide(
            color: context.colors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: AudioBar(
        key: ValueKey(url),
        url: url,
        autoPlay: autoPlay,
      ),
    );
  }
}

/// Cột 1/3 bên phải: Phiếu đáp án & danh sách câu trả lời tiện dụng trên iPad
class _AnswerSheetColumn extends StatefulWidget {
  const _AnswerSheetColumn({
    required this.group,
    this.allGroups,
    this.currentGroupIndex,
    this.onJumpToGroup,
    required this.answers,
    required this.onSelect,
    required this.isRevealed,
    required this.isFlagged,
    required this.onToggleFlag,
  });

  final QuestionGroup group;
  final List<QuestionGroup>? allGroups;
  final int? currentGroupIndex;
  final ValueChanged<int>? onJumpToGroup;
  final Map<String, String?> answers;
  final void Function(Question q, String letter)? onSelect;
  final bool Function(Question q)? isRevealed;
  final bool Function(Question q)? isFlagged;
  final void Function(Question q)? onToggleFlag;

  @override
  State<_AnswerSheetColumn> createState() => _AnswerSheetColumnState();
}

class _AnswerSheetColumnState extends State<_AnswerSheetColumn> {
  bool _showAllOmr = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surfaces = context.surfaces;
    final textStyles = context.textStyles;
    final questions = widget.group.questions;
    final answeredCount = questions.where((q) => widget.answers[q.id] != null).length;

    return Container(
      color: surfaces.raised.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header của cột 1/3
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s12,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(
                bottom: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.assignment_turned_in_outlined,
                  size: AppSizes.iconSm,
                  color: colors.primary,
                ),
                Gaps.h8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _showAllOmr ? 'Phiếu toàn bài thi' : 'Phiếu đáp án',
                        style: textStyles.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _showAllOmr
                            ? '${widget.allGroups?.length ?? 0} nhóm câu'
                            : '$answeredCount/${questions.length} câu đã trả lời',
                        style: textStyles.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                if (widget.allGroups != null && widget.onJumpToGroup != null)
                  IconButton(
                    tooltip: _showAllOmr ? 'Xem câu nhóm này' : 'Xem phiếu toàn bài',
                    icon: Icon(_showAllOmr ? Icons.view_headline_rounded : Icons.grid_view_rounded),
                    onPressed: () => setState(() => _showAllOmr = !_showAllOmr),
                  ),
              ],
            ),
          ),
          // Nội dung của cột 1/3
          Expanded(
            child: _showAllOmr && widget.allGroups != null
                ? _buildAllOmrView(context)
                : _buildCurrentGroupAnswers(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentGroupAnswers(BuildContext context) {
    final questions = widget.group.questions;
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.s16),
      itemCount: questions.length,
      separatorBuilder: (_, _) => Gaps.v16,
      itemBuilder: (context, i) {
        final q = questions[i];
        final chosen = widget.answers[q.id];
        final isRev = widget.isRevealed?.call(q) ?? false;
        final isFlg = widget.isFlagged?.call(q) ?? false;

        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s8,
                      vertical: AppSpacing.s4,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.primaryContainer,
                      borderRadius: AppRadius.brSm,
                    ),
                    child: Text(
                      'Câu ${q.number}',
                      style: context.textStyles.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.onPrimaryContainer,
                      ),
                    ),
                  ),
                  if (chosen != null) ...[
                    Gaps.h8,
                    Text(
                      'Đã chọn: $chosen',
                      style: context.textStyles.labelSmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (widget.onToggleFlag != null)
                    IconButton(
                      tooltip: isFlg ? 'Bỏ cờ câu ${q.number}' : 'Đánh dấu cờ',
                      iconSize: AppSizes.iconSm,
                      visualDensity: VisualDensity.compact,
                      isSelected: isFlg,
                      icon: const Icon(Icons.outlined_flag_rounded),
                      selectedIcon: Icon(
                        Icons.flag_rounded,
                        color: AppTone.warning.colorsOf(context).main,
                      ),
                      onPressed: () => widget.onToggleFlag!(q),
                    ),
                ],
              ),
              Gaps.v8,
              for (final (optIdx, letter) in q.letters.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                  child: AnswerOption(
                    letter: letter,
                    text: q.optionText(optIdx),
                    selected: chosen == letter,
                    result: !isRev
                        ? null
                        : letter == q.answer
                            ? AppTone.success
                            : chosen == letter
                                ? AppTone.danger
                                : null,
                    onTap: widget.onSelect == null || isRev
                        ? null
                        : () => widget.onSelect!(q, letter),
                  ),
                ),
              if (isRev) ...[
                if (chosen == null)
                  Text(
                    'Bỏ trống · Đáp án: ${q.answer}',
                    style: context.textStyles.bodySmall?.copyWith(
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
      },
    );
  }

  Widget _buildAllOmrView(BuildContext context) {
    final allGroups = widget.allGroups!;
    final entries = [
      for (final (gi, g) in allGroups.indexed)
        for (final q in g.questions) (gi, q),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s8,
        horizontal: AppSpacing.s12,
      ),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final (gi, q) = entries[i];
        final chosen = widget.answers[q.id];
        final isRev = widget.isRevealed?.call(q) ?? false;
        final isFlg = widget.isFlagged?.call(q) ?? false;
        final isCurrentGroup = gi == widget.currentGroupIndex;

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.s4),
          decoration: BoxDecoration(
            color: isCurrentGroup ? context.colors.primaryContainer.withValues(alpha: 0.25) : null,
            borderRadius: AppRadius.brSm,
          ),
          child: _OmrCompactRow(
            question: q,
            chosen: chosen,
            locked: isRev,
            flagged: isFlg,
            isCurrent: isCurrentGroup,
            onJump: () {
              widget.onJumpToGroup?.call(gi);
              setState(() => _showAllOmr = false);
            },
            onSelect: (letter) => widget.onSelect?.call(q, letter),
          ),
        );
      },
    );
  }
}

/// Dòng phiếu tô OMR gọn gàng cho Cột 1/3
class _OmrCompactRow extends StatelessWidget {
  const _OmrCompactRow({
    required this.question,
    required this.chosen,
    required this.locked,
    required this.flagged,
    required this.isCurrent,
    required this.onJump,
    required this.onSelect,
  });

  final Question question;
  final String? chosen;
  final bool locked;
  final bool flagged;
  final bool isCurrent;
  final VoidCallback onJump;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        children: [
          InkWell(
            onTap: onJump,
            borderRadius: AppRadius.brSm,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s8,
                vertical: AppSpacing.s4,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${question.number}',
                    style: context.textStyles.labelLarge?.copyWith(
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent ? colors.primary : colors.onSurface,
                    ),
                  ),
                  if (flagged) ...[
                    Gaps.h4,
                    Icon(
                      Icons.flag_rounded,
                      size: AppSizes.iconXs,
                      color: AppTone.warning.colorsOf(context).main,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Spacer(),
          for (final letter in question.letters)
            Semantics(
              button: true,
              selected: chosen == letter,
              label: 'Câu ${question.number} đáp án $letter',
              excludeSemantics: true,
              child: InkResponse(
                onTap: locked ? null : () => onSelect(letter),
                radius: AppSizes.touchTarget / 2,
                child: SizedBox.square(
                  dimension: AppSizes.touchTarget,
                  child: Center(
                    child: AnimatedContainer(
                      duration: AppMotion.of(context, AppMotion.short),
                      width: AppSizes.avatarSm,
                      height: AppSizes.avatarSm,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: chosen == letter ? colors.primary : null,
                        border: Border.all(
                          color: chosen == letter ? colors.primary : colors.outlineVariant,
                          width: chosen == letter ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        letter,
                        style: context.textStyles.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: chosen == letter ? colors.onPrimary : colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  const _QuestionTile({
    required this.question,
    required this.chosen,
    required this.onSelect,
    required this.revealed,
    this.flagged = false,
    this.onToggleFlag,
    this.contextMenuBuilder,
  });

  final Question question;
  final String? chosen;
  final void Function(Question q, String letter)? onSelect;
  final bool revealed;
  final bool flagged;
  final void Function(Question q)? onToggleFlag;
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  @override
  Widget build(BuildContext context) {
    final q = question;

    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.s12),
                  child: SelectableText.rich(
                    contextMenuBuilder: contextMenuBuilder,
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
                ),
              ),
              if (onToggleFlag != null)
                IconButton(
                  tooltip: flagged ? 'Bỏ đánh dấu câu ${q.number}' : 'Đánh dấu câu ${q.number}',
                  isSelected: flagged,
                  icon: const Icon(Icons.outlined_flag_rounded),
                  selectedIcon: Icon(
                    Icons.flag_rounded,
                    color: AppTone.warning.colorsOf(context).main,
                  ),
                  onPressed: () => onToggleFlag!(q),
                ),
            ],
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
    final fill = tone?.container ?? (selected ? cs.primaryContainer : context.surfaces.raised);
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

/// Ảnh có thể phóng to, khống chế chiều cao tối đa tránh tràn màn hình iPad quay ngang
class _ZoomableImage extends StatelessWidget {
  const _ZoomableImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    final isLandscape = media.width > media.height;
    // Khống chế chiều cao ảnh: Landscape iPad tối đa 360dp, Portrait tối đa 300dp
    final maxHeight = isLandscape ? 360.0 : 300.0;

    return Semantics(
      image: true,
      label: 'Hình minh hoạ, chạm để phóng to',
      child: GestureDetector(
        onTap: () => showDialog<void>(
          context: context,
          builder: (_) => Dialog.fullscreen(
            child: Stack(
              children: [
                InteractiveViewer(
                  maxScale: 5,
                  child: Center(child: Image(image: mediaImage(url))),
                ),
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
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.surfaces.raised,
            borderRadius: AppRadius.brMd,
            border: Border.all(
              color: context.colors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: ClipRRect(
            borderRadius: AppRadius.brMd,
            child: Image(
              image: mediaImage(url),
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : const SizedBox(
                      height: AppSizes.imagePlaceholder,
                      child: AppLoadingView(),
                    ),
              errorBuilder: (_, _, _) => const SizedBox(
                height: AppSizes.imagePlaceholder,
                child: AppErrorView(message: 'Không tải được ảnh'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
