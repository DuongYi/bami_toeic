import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../data/models/test_models.dart';
import '../controllers/test_providers.dart';

/// Lưu / bỏ lưu 1 câu vào "Câu đã lưu" (xem và luyện lại trong Sổ câu sai).
class SaveQuestionButton extends ConsumerWidget {
  const SaveQuestionButton({
    super.key,
    required this.question,
    required this.group,
    this.compact = false,
  });

  final Question question;
  final QuestionGroup group;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(
      savedQuestionsProvider.select(
        (s) => s.value?.any((x) => x.questionId == question.id) ?? false,
      ),
    );
    return IconButton(
      tooltip: saved ? 'Bỏ lưu câu ${question.number}' : 'Lưu câu ${question.number}',
      iconSize: compact ? AppSizes.iconSm : null,
      visualDensity: compact ? VisualDensity.compact : null,
      isSelected: saved,
      icon: const Icon(Icons.bookmark_border_rounded),
      selectedIcon: Icon(Icons.bookmark_rounded, color: context.colors.primary),
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        try {
          await ref
              .read(savedQuestionsProvider.notifier)
              .toggle(question, groupId: group.id, testId: group.testId);
          showAppSnackBarOn(
            messenger,
            saved ? 'Đã bỏ lưu câu ${question.number}' : 'Đã lưu câu ${question.number}',
            tone: saved ? AppTone.neutral : AppTone.success,
          );
        } catch (e) {
          showAppSnackBarOn(messenger, AppException.from(e).message, tone: AppTone.danger);
        }
      },
    );
  }
}
