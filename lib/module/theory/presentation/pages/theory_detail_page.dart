import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../data/models/theory_models.dart';
import '../controllers/theory_controller.dart';

/// Màn hình chi tiết bài học lý thuyết kèm công thức, ví dụ đề ETS và Mini Quiz
class TheoryDetailPage extends ConsumerStatefulWidget {
  const TheoryDetailPage({super.key, required this.topicId});

  final String topicId;

  @override
  ConsumerState<TheoryDetailPage> createState() => _TheoryDetailPageState();
}

class _TheoryDetailPageState extends ConsumerState<TheoryDetailPage> {
  // Quản lý đáp án user đã chọn cho từng câu quiz trong bài (index của option)
  final Map<int, int> _selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(theoryControllerProvider);
    final controller = ref.read(theoryControllerProvider.notifier);
    final topic = state.allTopics.where((t) => t.id == widget.topicId).firstOrNull;

    if (topic == null && state.isLoading) {
      return Scaffold(appBar: AppBar(), body: const AppLoadingView());
    }
    if (topic == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết lý thuyết')),
        body: const AppEmptyView(
          icon: Icons.error_outline_rounded,
          message: 'Không tìm thấy bài học này.',
        ),
      );
    }

    final isCompleted = state.isCompleted(topic.id);
    final isBookmarked = state.isBookmarked(topic.id);
    final hasQuiz = topic.quiz.isNotEmpty;
    final isQuizFinished = hasQuiz && _selectedAnswers.length == topic.quiz.length;

    // Tính số câu đúng
    int correctCount = 0;
    if (isQuizFinished) {
      for (int i = 0; i < topic.quiz.length; i++) {
        if (_selectedAnswers[i] == topic.quiz[i].answerIndex) {
          correctCount++;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        actions: [
          IconButton(
            tooltip: isBookmarked ? 'Bỏ lưu' : 'Lưu bài học',
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isBookmarked ? context.colors.primary : null,
            ),
            onPressed: () => controller.toggleBookmark(topic.id),
          ),
          IconButton(
            tooltip: isCompleted ? 'Đánh dấu chưa học' : 'Đánh dấu đã hoàn thành',
            icon: Icon(
              isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
              color: isCompleted ? AppTone.success.colorsOf(context).main : null,
            ),
            onPressed: () {
              controller.toggleCompleted(topic.id);
              showAppSnackBar(
                context,
                isCompleted ? 'Đã bỏ đánh dấu hoàn thành' : 'Đã hoàn thành bài học!',
                tone: isCompleted ? AppTone.neutral : AppTone.success,
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: AppBottomBar(
        child: AppPrimaryButton(
          label: isCompleted ? 'Đã hiểu bài (Nhấn để bỏ đánh dấu)' : 'Đánh dấu đã hoàn thành bài học',
          icon: isCompleted ? Icons.check_rounded : Icons.task_alt_rounded,
          onPressed: () {
            controller.toggleCompleted(topic.id);
            showAppSnackBar(
              context,
              isCompleted ? 'Đã bỏ đánh dấu hoàn thành' : 'Đã lưu tiến độ hoàn thành bài học!',
              tone: isCompleted ? AppTone.neutral : AppTone.success,
            );
          },
        ),
      ),
      body: ListView(
        padding: AppInsets.screen,
        children: [
          // Header bài học
          _TopicHeaderCard(topic: topic, isCompleted: isCompleted),
          Gaps.v24,

          // Các section lý thuyết & công thức
          for (final section in topic.sections) ...[
            _SectionContentWidget(section: section),
            Gaps.v16,
          ],

          // Ví dụ trích từ đề ETS
          if (topic.examples.isNotEmpty) ...[
            Gaps.v8,
            SectionHeader(
              title: 'Ví dụ thực chiến từ đề ETS',
              subtitle: 'Phân tích cách áp dụng kiến thức vào đề thi thực tế',
              trailing: StatusBadge(
                label: '${topic.examples.length} ví dụ',
                tone: AppTone.info,
              ),
            ),
            Gaps.v12,
            for (final ex in topic.examples) ...[
              _ExampleCard(example: ex),
              Gaps.v12,
            ],
            Gaps.v16,
          ],

          // Mini Quiz kiểm tra nhanh
          if (hasQuiz) ...[
            Gaps.v8,
            SectionHeader(
              title: 'Kiểm tra nhanh (Mini Quiz)',
              subtitle: 'Trả lời để củng cố phản xạ kiến thức ngay lập tức',
              trailing: StatusBadge(
                label: '${topic.quiz.length} câu',
                tone: AppTone.warning,
              ),
            ),
            Gaps.v12,
            for (int i = 0; i < topic.quiz.length; i++) ...[
              _QuizQuestionCard(
                index: i + 1,
                question: topic.quiz[i],
                selectedOption: _selectedAnswers[i],
                onSelectOption: (optionIndex) {
                  if (_selectedAnswers.containsKey(i)) return; // Khóa sau khi đã chọn
                  setState(() {
                    _selectedAnswers[i] = optionIndex;
                  });

                  // Nếu vừa làm xong câu cuối cùng, lưu kết quả
                  if (_selectedAnswers.length == topic.quiz.length) {
                    int finalCorrect = 0;
                    for (int k = 0; k < topic.quiz.length; k++) {
                      if (_selectedAnswers[k] == topic.quiz[k].answerIndex) {
                        finalCorrect++;
                      }
                    }
                    controller.recordQuizResult(topic.id, finalCorrect);
                  }
                },
              ),
              Gaps.v16,
            ],

            // Kết quả Mini Quiz
            if (isQuizFinished) ...[
              _QuizResultSummary(
                correctCount: correctCount,
                totalCount: topic.quiz.length,
                onRetry: () {
                  setState(() {
                    _selectedAnswers.clear();
                  });
                },
              ),
              Gaps.v16,
            ],
          ],

          // Khoảng đệm cho bottom bar
          Gaps.v32,
        ],
      ),
    );
  }
}

/// Thẻ đầu đề bài học
class _TopicHeaderCard extends StatelessWidget {
  const _TopicHeaderCard({required this.topic, required this.isCompleted});

  final TheoryTopic topic;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppInsets.card,
      tone: topic.category.tone,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadge(
                icon: topic.category.icon,
                tone: topic.category.tone,
                size: AppSizes.badgeMd,
              ),
              Gaps.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.category.label,
                      style: context.textStyles.labelSmall?.copyWith(
                        color: topic.category.tone.colorsOf(context).main,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      topic.title,
                      style: context.textStyles.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gaps.v12,
          Text(
            topic.subtitle,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          Gaps.v12,
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s4,
            children: [
              StatusBadge(label: topic.difficulty, tone: AppTone.info),
              StatusBadge(
                icon: Icons.access_time_rounded,
                label: '~${topic.readTimeMinutes} phút đọc',
                tone: AppTone.neutral,
              ),
              if (isCompleted)
                const StatusBadge(
                  icon: Icons.check_circle_rounded,
                  label: 'Đã hoàn thành',
                  tone: AppTone.success,
                ),
            ],
          ),
          Gaps.v12,
          Container(
            padding: const EdgeInsets.all(AppSpacing.s12),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLowest,
              borderRadius: AppRadius.brMd,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: AppSizes.iconSm,
                  color: context.colors.primary,
                ),
                Gaps.h8,
                Expanded(
                  child: Text(
                    topic.overview,
                    style: context.textStyles.bodySmall?.copyWith(
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Khối nội dung từng phần của bài học (Section)
class _SectionContentWidget extends StatelessWidget {
  const _SectionContentWidget({required this.section});

  final TheorySection section;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppInsets.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: context.textStyles.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
            ),
          ),
          Gaps.v8,
          Text(
            section.content,
            style: context.textStyles.bodyMedium?.copyWith(height: 1.5),
          ),
          if (section.formula != null) ...[
            Gaps.v12,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: AppSpacing.s12,
              ),
              decoration: BoxDecoration(
                color: context.colors.primaryContainer.withValues(alpha: 0.35),
                borderRadius: AppRadius.brMd,
                border: Border.all(
                  color: context.colors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.functions_rounded,
                    color: context.colors.primary,
                    size: AppSizes.iconMd,
                  ),
                  Gaps.h12,
                  Expanded(
                    child: Text(
                      section.formula!,
                      style: context.textStyles.titleSmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (section.bulletPoints.isNotEmpty) ...[
            Gaps.v12,
            for (final point in section.bulletPoints) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.s4),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: context.colors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Gaps.h8,
                    Expanded(
                      child: Text(
                        point,
                        style: context.textStyles.bodySmall?.copyWith(height: 1.45),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
          if (section.tips.isNotEmpty) ...[
            Gaps.v12,
            for (final tip in section.tips) ...[
              Builder(
                builder: (context) {
                  final warn = AppTone.warning.colorsOf(context);
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.s8),
                    padding: const EdgeInsets.all(AppSpacing.s12),
                    decoration: BoxDecoration(
                      color: warn.container.withValues(alpha: 0.4),
                      borderRadius: AppRadius.brMd,
                      border: Border.all(
                        color: warn.main.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_rounded,
                          color: warn.main,
                          size: AppSizes.iconSm,
                        ),
                        Gaps.h8,
                        Expanded(
                          child: Text(
                            tip,
                            style: context.textStyles.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// Thẻ ví dụ minh họa từ đề ETS
/// Câu ví dụ tô nổi cụm ngữ pháp chính ([highlight]) khi cụm đó nằm liền trong câu.
class _HighlightedSentence extends StatelessWidget {
  const _HighlightedSentence({required this.text, this.highlight, this.style});

  final String text;
  final String? highlight;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final h = highlight;
    final i = h == null || h.isEmpty ? -1 : text.indexOf(h);
    if (i < 0) return Text(text, style: style);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text.substring(0, i)),
          TextSpan(
            text: h,
            style: TextStyle(
              color: context.colors.onPrimaryContainer,
              backgroundColor: context.colors.primaryContainer,
            ),
          ),
          TextSpan(text: text.substring(i + h!.length)),
        ],
      ),
      style: style,
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.example});

  final TheoryExample example;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppInsets.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    color: context.colors.onSurfaceVariant,
                    size: AppSizes.iconSm,
                  ),
                  Gaps.h4,
                  Text(
                    'Câu ví dụ',
                    style: context.textStyles.labelSmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (example.partTag != null)
                StatusBadge(
                  label: example.partTag!,
                  tone: AppTone.info,
                ),
            ],
          ),
          Gaps.v8,
          _HighlightedSentence(
            text: example.english,
            highlight: example.highlight,
            style: context.textStyles.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colors.onSurface,
            ),
          ),
          Gaps.v4,
          Text(
            example.vietnamese,
            style: context.textStyles.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: context.colors.onSurfaceVariant,
            ),
          ),
          Gaps.v8,
          Container(
            padding: const EdgeInsets.all(AppSpacing.s8),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLowest,
              borderRadius: AppRadius.brSm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.psychology_alt_outlined,
                  size: AppSizes.iconXs,
                  color: context.colors.primary,
                ),
                Gaps.h8,
                Expanded(
                  child: Text(
                    example.explanation,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Thẻ câu hỏi Mini Quiz tương tác
class _QuizQuestionCard extends StatelessWidget {
  const _QuizQuestionCard({
    required this.index,
    required this.question,
    required this.selectedOption,
    required this.onSelectOption,
  });

  final int index;
  final TheoryQuizQuestion question;
  final int? selectedOption;
  final ValueChanged<int> onSelectOption;

  @override
  Widget build(BuildContext context) {
    final hasAnswered = selectedOption != null;
    final success = AppTone.success.colorsOf(context);

    return AppCard(
      padding: AppInsets.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: AppSpacing.s2,
                ),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.12),
                  borderRadius: AppRadius.brXs,
                ),
                child: Text(
                  'Câu $index',
                  style: context.textStyles.labelSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              if (hasAnswered)
                StatusBadge(
                  label: selectedOption == question.answerIndex ? 'Chính xác' : 'Chưa đúng',
                  tone: selectedOption == question.answerIndex ? AppTone.success : AppTone.danger,
                  icon: selectedOption == question.answerIndex
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                ),
            ],
          ),
          Gaps.v8,
          Text(
            question.question,
            style: context.textStyles.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
          Gaps.v12,

          // Các lựa chọn A, B, C, D
          for (int optIndex = 0; optIndex < question.options.length; optIndex++) ...[
            _QuizOptionTile(
              optionLabel: String.fromCharCode(65 + optIndex), // 'A', 'B', 'C', 'D'
              text: question.options[optIndex],
              isSelected: selectedOption == optIndex,
              isCorrect: optIndex == question.answerIndex,
              hasAnswered: hasAnswered,
              onTap: () => onSelectOption(optIndex),
            ),
            Gaps.v8,
          ],

          // Giải thích sau khi trả lời
          if (hasAnswered) ...[
            Gaps.v8,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.s12),
              decoration: BoxDecoration(
                color: selectedOption == question.answerIndex
                    ? success.container.withValues(alpha: 0.35)
                    : context.colors.surfaceContainerLowest,
                borderRadius: AppRadius.brMd,
                border: Border.all(
                  color: selectedOption == question.answerIndex
                    ? success.main.withValues(alpha: 0.3)
                    : context.colors.outlineVariant,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_rounded,
                        size: AppSizes.iconSm,
                        color: selectedOption == question.answerIndex
                            ? success.main
                            : context.colors.primary,
                      ),
                      Gaps.h8,
                      Text(
                        'Giải thích chi tiết:',
                        style: context.textStyles.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Gaps.v4,
                  Text(
                    question.explanation,
                    style: context.textStyles.bodySmall?.copyWith(height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Nút lựa chọn trong Quiz
class _QuizOptionTile extends StatelessWidget {
  const _QuizOptionTile({
    required this.optionLabel,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.hasAnswered,
    required this.onTap,
  });

  final String optionLabel;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool hasAnswered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color borderColor = context.colors.outlineVariant;
    Color textColor = context.colors.onSurface;
    final success = AppTone.success.colorsOf(context);

    if (hasAnswered) {
      if (isCorrect) {
        backgroundColor = success.container.withValues(alpha: 0.45);
        borderColor = success.main;
        textColor = success.main;
      } else if (isSelected) {
        backgroundColor = context.colors.errorContainer.withValues(alpha: 0.4);
        borderColor = context.colors.error;
        textColor = context.colors.error;
      }
    } else if (isSelected) {
      backgroundColor = context.colors.primaryContainer.withValues(alpha: 0.5);
      borderColor = context.colors.primary;
    }

    return InkWell(
      onTap: hasAnswered ? null : onTap,
      borderRadius: AppRadius.brMd,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s12,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.colors.surfaceContainerLowest,
          borderRadius: AppRadius.brMd,
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (hasAnswered && isCorrect)
                    ? success.main
                    : (hasAnswered && isSelected)
                        ? context.colors.error
                        : context.colors.surfaceContainerHigh,
              ),
              child: Text(
                optionLabel,
                style: context.textStyles.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: (hasAnswered && (isCorrect || isSelected))
                      ? context.colors.onPrimary
                      : context.colors.onSurface,
                ),
              ),
            ),
            Gaps.h12,
            Expanded(
              child: Text(
                text,
                style: context.textStyles.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: (hasAnswered && (isCorrect || isSelected))
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
            if (hasAnswered && isCorrect)
              Icon(
                Icons.check_circle_rounded,
                color: success.main,
                size: AppSizes.iconSm,
              )
            else if (hasAnswered && isSelected)
              Icon(
                Icons.cancel_rounded,
                color: context.colors.error,
                size: AppSizes.iconSm,
              ),
          ],
        ),
      ),
    );
  }
}

/// Thẻ tổng kết điểm Quiz khi làm xong
class _QuizResultSummary extends StatelessWidget {
  const _QuizResultSummary({
    required this.correctCount,
    required this.totalCount,
    required this.onRetry,
  });

  final int correctCount;
  final int totalCount;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isPerfect = correctCount == totalCount;
    final success = AppTone.success.colorsOf(context);

    return AppCard(
      padding: AppInsets.card,
      tone: isPerfect ? AppTone.success : AppTone.info,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPerfect ? Icons.celebration_rounded : Icons.thumb_up_alt_rounded,
                color: isPerfect ? success.main : context.colors.primary,
                size: AppSizes.iconLg,
              ),
              Gaps.h12,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPerfect ? 'Xuất sắc! Đúng toàn bộ!' : 'Đã hoàn thành Mini Quiz',
                    style: context.textStyles.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Đúng $correctCount / $totalCount câu',
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: isPerfect ? success.main : context.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gaps.v12,
          OutlinedButton.icon(
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Làm lại Quiz'),
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
