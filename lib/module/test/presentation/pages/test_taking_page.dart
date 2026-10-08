import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../helper/format.dart';
import '../../../../routes/app_router.dart';
import '../controllers/test_taking_controller.dart';
import '../widgets/question_group_view.dart';

class TestTakingPage extends ConsumerStatefulWidget {
  const TestTakingPage({super.key, required this.testId, required this.mode, required this.parts});

  final String testId;
  final String mode;

  /// Dạng "1,2,5"
  final String parts;

  @override
  ConsumerState<TestTakingPage> createState() => _TestTakingPageState();
}

class _TestTakingPageState extends ConsumerState<TestTakingPage> {
  final _pageController = PageController();

  late final _provider = testTakingProvider(widget.testId, widget.mode, widget.parts);

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
    final unanswered = s.totalQuestions - s.answers.length;
    final ok = await showAppConfirmDialog(
      context,
      title: 'Nộp bài?',
      message: unanswered > 0
          ? 'Bạn còn $unanswered câu chưa làm.'
          : 'Bạn đã làm hết ${s.totalQuestions} câu.',
      confirmLabel: 'Nộp bài',
      cancelLabel: 'Làm tiếp',
    );
    if (ok) ref.read(_provider.notifier).submit();
  }

  Future<bool> _confirmExit() async {
    final answered = ref.read(_provider).value?.answers.length ?? 0;
    if (answered == 0) return true;
    return showAppConfirmDialog(
      context,
      title: 'Thoát bài làm?',
      message: 'Các câu đã làm sẽ không được lưu.',
      confirmLabel: 'Thoát',
      cancelLabel: 'Ở lại',
      destructive: true,
    );
  }

  void _showPalette() {
    showAppBottomSheet<void>(
      context,
      builder: (ctx) => _QuestionPalette(
        provider: _provider,
        onJump: (i) {
          Navigator.pop(ctx);
          _goTo(i);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Điều hướng / báo lỗi khi nộp bài (kể cả tự nộp khi hết giờ).
    ref.listen(_provider, (prev, next) {
      final s = next.value;
      if (s == null) return;
      if (s.submitted != null && prev?.value?.submitted == null) {
        context.pushReplacement(Routes.result(s.submitted!.id));
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

    final status = ref.watch(_provider.select((s) => s.whenData((_) {})));
    if (!status.hasValue) {
      return Scaffold(
        appBar: AppBar(),
        body: AsyncView(
          value: status,
          onRetry: () => ref.invalidate(_provider),
          data: (_) => const SizedBox.shrink(),
        ),
      );
    }

    final groups = ref.watch(_provider.select((s) => s.value!.groups));
    if (groups.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const AppEmptyView(icon: Icons.inbox_outlined, message: 'Không có câu hỏi.'),
      );
    }
    final isExam = widget.mode == 'exam';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExit() && context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: _AnsweredCounter(provider: _provider),
          actions: [
            _ClockChip(provider: _provider),
            _SubmitButton(provider: _provider, onPressed: _confirmSubmit),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(AppSizes.progressThin),
            child: _ProgressBar(provider: _provider),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: groups.length,
          onPageChanged: ref.read(_provider.notifier).setIndex,
          itemBuilder: (context, i) => _GroupPage(
            key: ValueKey(groups[i].id),
            provider: _provider,
            groupIndex: i,
            isExam: isExam,
          ),
        ),
        bottomNavigationBar: _BottomNav(
          provider: _provider,
          onPrev: (i) => _goTo(i - 1),
          onNext: (i) => _goTo(i + 1),
          onPalette: _showPalette,
          onSubmit: _confirmSubmit,
        ),
      ),
    );
  }
}

// ---------- Các widget con chỉ watch phần state mình cần ----------

class _GroupPage extends ConsumerWidget {
  const _GroupPage({
    super.key,
    required this.provider,
    required this.groupIndex,
    required this.isExam,
  });

  final TestTakingProvider provider;
  final int groupIndex;
  final bool isExam;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (group, answers, revealed) = ref.watch(
      provider.select((s) {
        final v = s.value!;
        return (v.groups[groupIndex], v.answers, v.revealed);
      }),
    );
    return QuestionGroupView(
      group: group,
      answers: answers,
      onSelect: ref.read(provider.notifier).select,
      isRevealed: (q) => revealed.contains(q.id),
      showTranscript: !isExam,
      autoPlayAudio: isExam,
    );
  }
}

class _AnsweredCounter extends ConsumerWidget {
  const _AnsweredCounter({required this.provider});

  final TestTakingProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (answered, total) = ref.watch(
      provider.select((s) => (s.value!.answers.length, s.value!.totalQuestions)),
    );
    return Text('$answered/$total câu');
  }
}

class _ClockChip extends ConsumerWidget {
  const _ClockChip({required this.provider});

  final TestTakingProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (clock, isExam) = ref.watch(provider.select((s) => (s.value!.clock, s.value!.isExam)));
    final lowTime = isExam && clock.inMinutes < 5;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.s8),
        child: Chip(
          avatar: Icon(isExam ? Icons.timer_outlined : Icons.schedule, size: AppSizes.iconSm),
          label: Text(
            Fmt.clock(clock),
            style: TextStyle(
              fontFeatures: const [FontFeature.tabularFigures()],
              color: lowTime ? context.colors.error : null,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends ConsumerWidget {
  const _SubmitButton({required this.provider, required this.onPressed});

  final TestTakingProvider provider;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submitting = ref.watch(provider.select((s) => s.value!.submitting));
    return TextButton(
      onPressed: submitting ? null : onPressed,
      child: submitting ? const AppInlineSpinner() : const Text('Nộp bài'),
    );
  }
}

class _ProgressBar extends ConsumerWidget {
  const _ProgressBar({required this.provider});

  final TestTakingProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (index, total) = ref.watch(
      provider.select((s) => (s.value!.index, s.value!.groups.length)),
    );
    return LinearProgressIndicator(value: (index + 1) / total);
  }
}

class _BottomNav extends ConsumerWidget {
  const _BottomNav({
    required this.provider,
    required this.onPrev,
    required this.onNext,
    required this.onPalette,
    required this.onSubmit,
  });

  final TestTakingProvider provider;
  final ValueChanged<int> onPrev;
  final ValueChanged<int> onNext;
  final VoidCallback onPalette;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (index, groups, submitting) = ref.watch(
      provider.select((s) => (s.value!.index, s.value!.groups, s.value!.submitting)),
    );
    final qs = groups[index].questions;
    final label = qs.length > 1
        ? 'Câu ${qs.first.number}–${qs.last.number}'
        : 'Câu ${qs.first.number}';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s12,
          AppSpacing.s4,
          AppSpacing.s12,
          AppSpacing.s8,
        ),
        child: Row(
          children: [
            IconButton.filledTonal(
              tooltip: 'Câu trước',
              icon: const Icon(Icons.chevron_left),
              onPressed: index > 0 ? () => onPrev(index) : null,
            ),
            Expanded(
              child: TextButton.icon(
                icon: const Icon(Icons.grid_view_rounded),
                label: Text(label),
                onPressed: onPalette,
              ),
            ),
            if (index < groups.length - 1)
              IconButton.filled(
                tooltip: 'Câu tiếp',
                icon: const Icon(Icons.chevron_right),
                onPressed: () => onNext(index),
              )
            else
              FilledButton(onPressed: submitting ? null : onSubmit, child: const Text('Nộp bài')),
          ],
        ),
      ),
    );
  }
}

class _QuestionPalette extends ConsumerWidget {
  const _QuestionPalette({required this.provider, required this.onJump});

  final TestTakingProvider provider;
  final ValueChanged<int> onJump;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (groups, answers, index) = ref.watch(
      provider.select((s) => (s.value!.groups, s.value!.answers, s.value!.index)),
    );
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      builder: (context, scroll) => SingleChildScrollView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.s24),
        child: Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            for (final (gi, g) in groups.indexed)
              for (final q in g.questions)
                NumberCell(
                  number: q.number,
                  filled: answers.containsKey(q.id),
                  current: gi == index,
                  semanticLabel:
                      'Câu ${q.number}, ${answers.containsKey(q.id) ? 'đã trả lời' : 'chưa trả lời'}',
                  onTap: () => onJump(gi),
                ),
          ],
        ),
      ),
    );
  }
}
