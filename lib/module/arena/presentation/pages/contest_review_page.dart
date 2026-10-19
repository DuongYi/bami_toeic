import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../test/presentation/widgets/question_group_view.dart';
import '../../../vocab/presentation/widgets/word_lookup_sheet.dart';
import '../../data/models/arena_models.dart';
import '../controllers/contest_controller.dart';

/// Xem lại bài thi Chủ nhật sau giờ thi (PRO): đáp án đúng, giải thích, transcript.
class ContestReviewPage extends ConsumerStatefulWidget {
  const ContestReviewPage({super.key, required this.contestId});

  final String contestId;

  @override
  ConsumerState<ContestReviewPage> createState() => _ContestReviewPageState();
}

class _ContestReviewPageState extends ConsumerState<ContestReviewPage> {
  final _pageController = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int i) => _pageController.animateToPage(
    i,
    duration: AppMotion.of(context, AppMotion.medium),
    curve: AppMotion.standard,
  );

  @override
  Widget build(BuildContext context) {
    final review = ref.watch(contestReviewProvider(widget.contestId));
    return Scaffold(
      appBar: AppBar(title: Text(review.value?.title ?? 'Xem lại bài thi')),
      body: AsyncView(
        value: review,
        onRetry: () => ref.invalidate(contestReviewProvider(widget.contestId)),
        data: (r) {
          final groups = paperToGroups(r.id, r.groups, key: r.key);
          final answers = {
            for (final e in r.answers.entries) paperQuestionId(int.parse(e.key)): e.value,
          };
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: groups.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) => QuestionGroupView(
                    key: ValueKey(groups[i].id),
                    group: groups[i],
                    answers: answers,
                    isRevealed: (_) => true,
                    showTranscript: true,
                    contextMenuBuilder: lookupContextMenu(context),
                    canSave: false,
                  ),
                ),
              ),
              AppBottomBar(
                child: Row(
                  children: [
                    IconButton.filledTonal(
                      tooltip: 'Nhóm trước',
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _index > 0 ? () => _goTo(_index - 1) : null,
                    ),
                    Expanded(
                      child: Text(
                        '${_index + 1}/${groups.length}',
                        textAlign: TextAlign.center,
                        style: context.textStyles.titleMedium,
                      ),
                    ),
                    IconButton.filled(
                      tooltip: 'Nhóm sau',
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _index < groups.length - 1 ? () => _goTo(_index + 1) : null,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
