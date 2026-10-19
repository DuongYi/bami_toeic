import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../helper/format.dart';
import '../../../../routes/app_router.dart';
import '../../../test/data/models/test_models.dart';
import '../../../test/presentation/widgets/question_group_view.dart';
import '../../../vocab/presentation/widgets/word_lookup_sheet.dart';
import '../controllers/contest_controller.dart';
import '../widgets/arena_widgets.dart';

/// Phòng thi Chủ nhật: làm như thi thật, đồng hồ theo giờ server, tự nộp khi đóng phòng.
class ContestTakingPage extends ConsumerStatefulWidget {
  const ContestTakingPage({super.key, required this.contestId});

  final String contestId;

  @override
  ConsumerState<ContestTakingPage> createState() => _ContestTakingPageState();
}

class _ContestTakingPageState extends ConsumerState<ContestTakingPage> {
  final _pageController = PageController();
  late final _provider = contestTakingProvider(widget.contestId);

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

  Future<void> _confirmSubmit() async {
    final s = ref.read(_provider).value;
    if (s == null) return;
    final left = s.totalQuestions - s.answers.length;
    final ok = await showAppConfirmDialog(
      context,
      title: 'Nộp bài?',
      message: left > 0
          ? 'Bạn còn $left câu chưa làm. Nộp rồi thì không làm lại được.'
          : 'Bạn đã làm hết ${s.totalQuestions} câu. Nộp rồi thì không làm lại được.',
      confirmLabel: 'Nộp bài',
      cancelLabel: 'Làm tiếp',
    );
    if (ok) ref.read(_provider.notifier).submit();
  }

  Future<bool> _confirmExit() => showAppConfirmDialog(
    context,
    title: 'Rời phòng thi?',
    message: 'Bài làm được lưu nháp. Bạn có thể vào lại trước khi đóng phòng, '
        'nhưng đồng hồ vẫn chạy.',
    confirmLabel: 'Rời phòng',
    cancelLabel: 'Ở lại',
  );

  void _showPalette() {
    showAppBottomSheet<void>(
      context,
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final s = ref.watch(_provider).value!;
          return SingleChildScrollView(
            padding: AppInsets.screen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Đã làm ${s.answers.length}/${s.totalQuestions}',
                    style: context.textStyles.titleMedium),
                Gaps.v12,
                Wrap(
                  spacing: AppSpacing.s8,
                  runSpacing: AppSpacing.s8,
                  children: [
                    for (final (gi, g) in s.groups.indexed)
                      for (final q in g.questions)
                        NumberCell(
                          number: q.number,
                          filled: s.answers.containsKey(q.id),
                          current: gi == s.index,
                          flagged: s.flagged.contains(q.id),
                          semanticLabel: 'Câu ${q.number}, '
                              '${s.answers.containsKey(q.id) ? 'đã trả lời' : 'chưa trả lời'}',
                          onTap: () {
                            Navigator.pop(ctx);
                            _goTo(gi);
                          },
                        ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(_provider, (prev, next) {
      final s = next.value;
      if (s == null) return;
      if (s.result != null && prev?.value?.result == null) {
        final r = s.result!;
        final messenger = ScaffoldMessenger.of(context);
        context.pushReplacement(Routes.contest);
        showAppSnackBarOn(
          messenger,
          'Đã nộp: đúng ${r.correct}/${r.questionCount} câu '
          '(nghe ${r.listeningCorrect}, đọc ${r.readingCorrect}).',
          tone: AppTone.success,
        );
      }
      if (s.submitError != null && prev?.value?.submitError == null) {
        showAppSnackBar(
          context,
          'Nộp bài thất bại: ${AppException.from(s.submitError!).message}',
          tone: AppTone.danger,
          actionLabel: 'Thử lại',
          onAction: () => ref.read(_provider.notifier).submit(),
        );
      }
    });

    final session = ref.watch(_provider);
    if (!session.hasValue) {
      return Scaffold(
        appBar: AppBar(title: const Text('Thi Chủ nhật')),
        body: AsyncView(
          value: session,
          onRetry: () => ref.invalidate(_provider),
          data: (_) => const SizedBox.shrink(),
        ),
      );
    }
    final s = session.value!;
    final notifier = ref.read(_provider.notifier);
    final group = s.groups[s.index];
    final qs = group.questions;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExit() && context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Rời phòng thi',
            icon: const Icon(Icons.close_rounded),
            onPressed: () async {
              if (await _confirmExit() && context.mounted) context.pop();
            },
          ),
          titleSpacing: 0,
          title: Text('Đã làm ${s.answers.length}/${s.totalQuestions}',
              style: context.textStyles.titleMedium),
          actions: [
            SecondTicker(
              builder: (context) {
                final left = s.deadline.difference(DateTime.now());
                final c = (left.inMinutes < 5 ? AppTone.danger : AppTone.info).colorsOf(context);
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s12,
                      vertical: AppSpacing.s4,
                    ),
                    decoration: BoxDecoration(color: c.container, borderRadius: AppRadius.brFull),
                    child: Text(
                      Fmt.clock(left.isNegative ? Duration.zero : left),
                      semanticsLabel: 'Thời gian còn lại ${Fmt.clock(left)}',
                      style: context.textStyles.labelLarge?.copyWith(
                        color: c.onContainer,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                );
              },
            ),
            Gaps.h8,
            FilledButton.tonal(
              onPressed: s.submitting ? null : _confirmSubmit,
              child: s.submitting ? const AppInlineSpinner() : const Text('Nộp bài'),
            ),
            Gaps.h12,
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(AppSizes.progressThin),
            child: LinearProgressIndicator(value: (s.index + 1) / s.groups.length),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: s.groups.length,
          onPageChanged: notifier.setIndex,
          itemBuilder: (context, i) {
            final g = s.groups[i];
            return QuestionGroupView(
              key: ValueKey(g.id),
              group: g,
              answers: s.answers,
              onSelect: notifier.select,
              isFlagged: (q) => s.flagged.contains(q.id),
              onToggleFlag: notifier.toggleFlag,
              isEliminated: (q, l) => s.eliminated[q.id]?.contains(l) ?? false,
              onToggleEliminated: notifier.toggleEliminated,
              contextMenuBuilder: lookupContextMenu(context),
              canSave: false,
            );
          },
        ),
        bottomNavigationBar: AppBottomBar(
          child: Row(
            children: [
              IconButton.filledTonal(
                tooltip: 'Câu trước',
                icon: const Icon(Icons.chevron_left),
                onPressed: s.index > 0 ? () => _goTo(s.index - 1) : null,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.grid_view_rounded),
                      label: Text(_label(qs)),
                      onPressed: _showPalette,
                    ),
                  ],
                ),
              ),
              if (s.index < s.groups.length - 1)
                IconButton.filled(
                  tooltip: 'Câu tiếp',
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _goTo(s.index + 1),
                )
              else
                FilledButton(
                  onPressed: s.submitting ? null : _confirmSubmit,
                  child: const Text('Nộp bài'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static String _label(List<Question> qs) =>
      qs.length > 1 ? 'Câu ${qs.first.number}–${qs.last.number}' : 'Câu ${qs.first.number}';
}
