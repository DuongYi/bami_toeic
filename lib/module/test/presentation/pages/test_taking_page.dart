import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/app_exception.dart';
import '../../../../core/widgets/async_view.dart';
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
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeOut,
  );

  Future<void> _confirmSubmit() async {
    final s = ref.read(_provider).value;
    if (s == null) return;
    final unanswered = s.totalQuestions - s.answers.length;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nộp bài?'),
        content: Text(
          unanswered > 0
              ? 'Bạn còn $unanswered câu chưa làm.'
              : 'Bạn đã làm hết ${s.totalQuestions} câu.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Làm tiếp')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Nộp bài')),
        ],
      ),
    );
    if (ok == true) ref.read(_provider.notifier).submit();
  }

  Future<bool> _confirmExit() async {
    final answered = ref.read(_provider).value?.answers.length ?? 0;
    if (answered == 0) return true;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thoát bài làm?'),
        content: const Text('Các câu đã làm sẽ không được lưu.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Ở lại')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Thoát')),
        ],
      ),
    );
    return ok == true;
  }

  void _showPalette() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nộp bài thất bại: ${AppException.from(s.submitError!).message}'),
            action: SnackBarAction(
              label: 'Thử lại',
              onPressed: () => ref.read(_provider.notifier).submit(),
            ),
          ),
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
          data: (_) => const SizedBox(),
        ),
      );
    }

    final groups = ref.watch(_provider.select((s) => s.value!.groups));
    if (groups.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Không có câu hỏi.')),
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
            preferredSize: const Size.fromHeight(3),
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

  String _fmt(Duration d) {
    final h = d.inHours, m = d.inMinutes.remainder(60), s = d.inSeconds.remainder(60);
    final mm = m.toString().padLeft(2, '0'), ss = s.toString().padLeft(2, '0');
    return h > 0 ? '$h:$mm:$ss' : '$mm:$ss';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (clock, isExam) = ref.watch(provider.select((s) => (s.value!.clock, s.value!.isExam)));
    final lowTime = isExam && clock.inMinutes < 5;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Chip(
          avatar: Icon(isExam ? Icons.timer_outlined : Icons.schedule, size: 18),
          label: Text(
            _fmt(clock),
            style: TextStyle(
              fontFeatures: const [FontFeature.tabularFigures()],
              color: lowTime ? Theme.of(context).colorScheme.error : null,
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
      child: submitting
          ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : const Text('Nộp bài'),
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
    return LinearProgressIndicator(value: (index + 1) / total, minHeight: 3);
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
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: Row(
          children: [
            IconButton.filledTonal(
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
    final scheme = Theme.of(context).colorScheme;
    final (groups, answers, index) = ref.watch(
      provider.select((s) => (s.value!.groups, s.value!.answers, s.value!.index)),
    );
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      builder: (context, scroll) => GridView.count(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        crossAxisCount: 6,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: [
          for (final (gi, g) in groups.indexed)
            for (final q in g.questions)
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onJump(gi),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: answers.containsKey(q.id)
                        ? scheme.primary
                        : scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                    border: gi == index ? Border.all(color: scheme.tertiary, width: 2) : null,
                  ),
                  child: Text(
                    '${q.number}',
                    style: TextStyle(
                      color: answers.containsKey(q.id) ? scheme.onPrimary : scheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
