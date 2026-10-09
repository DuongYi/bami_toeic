import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../helper/format.dart';
import '../../../../routes/app_router.dart';
import '../../data/models/test_models.dart';
import '../../../vocab/presentation/widgets/word_lookup_sheet.dart';
import '../controllers/test_taking_controller.dart';
import '../widgets/exam_listening_bar.dart';
import '../widgets/question_group_view.dart';

class TestTakingPage extends ConsumerStatefulWidget {
  const TestTakingPage({super.key, required this.testId, required this.mode, required this.parts});

  final String testId;
  final String mode;

  /// Dạng "1,2,5"; với phiên sổ câu sai là bộ lọc ("all" | "part:5" | "tag:word-form")
  final String parts;

  @override
  ConsumerState<TestTakingPage> createState() => _TestTakingPageState();
}

class _TestTakingPageState extends ConsumerState<TestTakingPage> {
  final _pageController = PageController();
  late final AppLifecycleListener _lifecycle;
  bool _restoredPage = false;

  /// Thi thử: nhóm bắt đầu phát audio liền mạch (chốt 1 lần khi tải xong), null = không phát.
  int? _listeningStart;
  bool _listeningDone = false;

  late final _provider = testTakingProvider(widget.testId, widget.mode, widget.parts);
  bool get _isMistakes => widget.testId == kMistakesSession;

  @override
  void initState() {
    super.initState();
    // App bị đưa xuống nền / tắt → lưu bài làm dở ngay
    _lifecycle = AppLifecycleListener(
      onInactive: () => ref.read(_provider.notifier).saveProgress(force: true),
      onPause: () => ref.read(_provider.notifier).saveProgress(force: true),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int i) => _pageController.animateToPage(
    i,
    duration: AppMotion.of(context, AppMotion.medium),
    curve: AppMotion.standard,
  );

  void _onListeningFinished(List<QuestionGroup> groups) {
    setState(() => _listeningDone = true);
    final reading = groups.indexWhere((g) => g.part >= 5);
    if (reading < 0) {
      showAppSnackBar(
        context,
        'Đã hết phần nghe. Kiểm tra lại đáp án rồi nộp bài.',
        tone: AppTone.info,
      );
      return;
    }
    _goTo(reading);
    showAppSnackBar(context, 'Đã hết phần nghe · chuyển sang Reading', tone: AppTone.info);
  }

  Future<void> _confirmSubmit() async {
    final s = ref.read(_provider).value;
    if (s == null) return;
    final unanswered = s.totalQuestions - s.answers.length;
    final flagged = s.flagged.length;
    final ok = await showAppConfirmDialog(
      context,
      title: 'Nộp bài?',
      message: [
        unanswered > 0
            ? 'Bạn còn $unanswered câu chưa làm.'
            : 'Bạn đã làm hết ${s.totalQuestions} câu.',
        if (flagged > 0) 'Có $flagged câu đang đánh dấu để xem lại.',
      ].join('\n'),
      confirmLabel: 'Nộp bài',
      cancelLabel: 'Làm tiếp',
    );
    if (ok) ref.read(_provider.notifier).submit();
  }

  Future<bool> _confirmExit() async {
    final answered = ref.read(_provider).value?.answers.length ?? 0;
    if (answered == 0) return true;
    if (_isMistakes) {
      return showAppConfirmDialog(
        context,
        title: 'Dừng luyện?',
        message: 'Kết quả lượt luyện này sẽ không được lưu.',
        confirmLabel: 'Dừng',
        cancelLabel: 'Ở lại',
        destructive: true,
      );
    }
    final ok = await showAppConfirmDialog(
      context,
      title: 'Tạm dừng bài làm?',
      message: 'Bài làm được lưu lại, bạn có thể tiếp tục sau ở trang đề thi.',
      confirmLabel: 'Tạm dừng',
      cancelLabel: 'Làm tiếp',
    );
    if (ok) await ref.read(_provider.notifier).saveProgress(force: true);
    return ok;
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
      if (s.mistakeResult case (final correct, final total)?
          when prev?.value?.mistakeResult == null) {
        final messenger = ScaffoldMessenger.of(context);
        context.pop();
        showAppSnackBarOn(
          messenger,
          'Đúng $correct/$total câu · $correct câu đã ra khỏi sổ câu sai',
          tone: correct == total ? AppTone.success : AppTone.info,
        );
      }
      // Khôi phục bài làm dở: nhảy tới câu đang làm + báo cho người dùng
      if (s.resumed && !_restoredPage && prev?.value == null) {
        _restoredPage = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) _pageController.jumpToPage(s.index);
        });
        showAppSnackBar(
          context,
          'Đã khôi phục bài làm dở (${s.answers.length}/${s.totalQuestions} câu)',
          tone: AppTone.info,
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

    final status = ref.watch(_provider.select((s) => s.whenData((_) {})));
    if (!status.hasValue) {
      return Scaffold(
        appBar: AppBar(),
        body: AsyncView(
          value: status,
          loading: (_) => const TestTakingSkeleton(),
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
    if (isExam && !_isMistakes) _listeningStart ??= ref.read(_provider).value!.index;
    final listening =
        _listeningStart != null &&
        !_listeningDone &&
        ExamListeningBar.playableFrom(groups, _listeningStart!).isNotEmpty;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExit() && context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Thoát',
            icon: const Icon(Icons.close_rounded),
            onPressed: () async {
              if (await _confirmExit() && context.mounted) context.pop();
            },
          ),
          titleSpacing: 0,
          title: _AnsweredCounter(provider: _provider),
          actions: [
            _ClockChip(provider: _provider),
            Gaps.h8,
            _SubmitButton(provider: _provider, onPressed: _confirmSubmit),
            Gaps.h12,
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(AppSizes.progressThin),
            child: _ProgressBar(provider: _provider),
          ),
        ),
        body: Column(
          children: [
            if (listening)
              ExamListeningBar(
                groups: groups,
                startIndex: _listeningStart!,
                onGroupStarted: (i) {
                  if (_pageController.hasClients && _pageController.page?.round() != i) _goTo(i);
                },
                onFinished: () => _onListeningFinished(groups),
              ),
            Expanded(
              child: PageView.builder(
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
            ),
          ],
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
    final (group, answers, revealed, flagged) = ref.watch(
      provider.select((s) {
        final v = s.value!;
        return (v.groups[groupIndex], v.answers, v.revealed, v.flagged);
      }),
    );
    return QuestionGroupView(
      group: group,
      answers: answers,
      onSelect: ref.read(provider.notifier).select,
      isRevealed: (q) => revealed.contains(q.id),
      isFlagged: (q) => flagged.contains(q.id),
      onToggleFlag: ref.read(provider.notifier).toggleFlag,
      showTranscript: !isExam,
      // Thi thử: audio phát liền mạch ở ExamListeningBar
      showAudio: !isExam,
      contextMenuBuilder: lookupContextMenu(context),
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
    return Text('Đã làm $answered/$total', style: context.textStyles.titleMedium);
  }
}

class _ClockChip extends ConsumerWidget {
  const _ClockChip({required this.provider});

  final TestTakingProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (clock, isExam) = ref.watch(provider.select((s) => (s.value!.clock, s.value!.isExam)));
    final lowTime = isExam && clock.inMinutes < 5;
    final c = (lowTime ? AppTone.danger : AppTone.info).colorsOf(context);
    return Center(
      child: Semantics(
        label: isExam ? 'Thời gian còn lại ${Fmt.clock(clock)}' : 'Đã làm ${Fmt.clock(clock)}',
        excludeSemantics: true,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s4),
          decoration: BoxDecoration(color: c.container, borderRadius: AppRadius.brFull),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isExam ? Icons.timer_outlined : Icons.schedule_rounded,
                size: AppSizes.iconSm,
                color: c.onContainer,
              ),
              Gaps.h4,
              Text(
                Fmt.clock(clock),
                style: context.textStyles.labelLarge?.copyWith(
                  color: c.onContainer,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
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
    return FilledButton.tonal(
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

    return AppBottomBar(
      child: Row(
        children: [
          IconButton.filledTonal(
            tooltip: 'Câu trước',
            icon: const Icon(Icons.chevron_left),
            onPressed: index > 0 ? () => onPrev(index) : null,
          ),
          // Row co theo nội dung (Center sẽ giãn hết chiều cao trong bottomNavigationBar).
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.grid_view_rounded),
                  label: Text(label),
                  onPressed: onPalette,
                ),
              ],
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
    );
  }
}

/// Bảng chọn câu: lưới số câu (nhảy nhanh) hoặc phiếu tô kiểu OMR (tô thẳng đáp án).
class _QuestionPalette extends ConsumerStatefulWidget {
  const _QuestionPalette({required this.provider, required this.onJump});

  final TestTakingProvider provider;
  final ValueChanged<int> onJump;

  @override
  ConsumerState<_QuestionPalette> createState() => _QuestionPaletteState();
}

class _QuestionPaletteState extends ConsumerState<_QuestionPalette> {
  bool _omr = false;

  @override
  Widget build(BuildContext context) {
    final (groups, answers, index, flagged, revealed) = ref.watch(
      widget.provider.select(
        (s) => (
          s.value!.groups,
          s.value!.answers,
          s.value!.index,
          s.value!.flagged,
          s.value!.revealed,
        ),
      ),
    );
    final entries = [
      for (final (gi, g) in groups.indexed)
        for (final q in g.questions) (gi, q),
    ];
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              0,
              AppSpacing.screen,
              AppSpacing.s12,
            ),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.grid_view_rounded),
                  label: Text('Bảng câu'),
                ),
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.radio_button_checked_rounded),
                  label: Text('Phiếu tô'),
                ),
              ],
              selected: {_omr},
              onSelectionChanged: (v) => setState(() => _omr = v.first),
            ),
          ),
          Expanded(
            child: _omr
                ? ListView.builder(
                    controller: scroll,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      0,
                      AppSpacing.screen,
                      AppSpacing.s24,
                    ),
                    itemCount: entries.length,
                    itemBuilder: (context, i) {
                      final (gi, q) = entries[i];
                      return _OmrRow(
                        question: q,
                        chosen: answers[q.id],
                        locked: revealed.contains(q.id),
                        flagged: flagged.contains(q.id),
                        onJump: () => widget.onJump(gi),
                        onSelect: (letter) => ref.read(widget.provider.notifier).select(q, letter),
                      );
                    },
                  )
                : SingleChildScrollView(
                    controller: scroll,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      0,
                      AppSpacing.screen,
                      AppSpacing.s24,
                    ),
                    child: Wrap(
                      spacing: AppSpacing.s8,
                      runSpacing: AppSpacing.s8,
                      children: [
                        for (final (gi, q) in entries)
                          NumberCell(
                            number: q.number,
                            filled: answers.containsKey(q.id),
                            current: gi == index,
                            flagged: flagged.contains(q.id),
                            semanticLabel:
                                'Câu ${q.number}, '
                                '${answers.containsKey(q.id) ? 'đã trả lời' : 'chưa trả lời'}'
                                '${flagged.contains(q.id) ? ', đã đánh dấu' : ''}',
                            onTap: () => widget.onJump(gi),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Một dòng phiếu tô: số câu (chạm để mở câu) + các ô A–D.
class _OmrRow extends StatelessWidget {
  const _OmrRow({
    required this.question,
    required this.chosen,
    required this.locked,
    required this.flagged,
    required this.onJump,
    required this.onSelect,
  });

  final Question question;
  final String? chosen;

  /// Luyện tập: câu đã hiện đáp án thì không đổi được nữa.
  final bool locked;
  final bool flagged;
  final VoidCallback onJump;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        SizedBox(
          width: AppSizes.touchTarget + AppSpacing.s16,
          child: TextButton(
            onPressed: onJump,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${question.number}', style: context.textStyles.labelLarge),
                if (flagged) ...[
                  Gaps.h4,
                  Icon(
                    Icons.flag_rounded,
                    size: AppSizes.iconXs,
                    color: AppTone.warning.colorsOf(context).main,
                    semanticLabel: 'đã đánh dấu',
                  ),
                ],
              ],
            ),
          ),
        ),
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
                    width: AppSizes.badgeSm,
                    height: AppSizes.badgeSm,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: chosen == letter ? colors.primary : null,
                      border: Border.all(color: chosen == letter ? colors.primary : colors.outline),
                    ),
                    child: Text(
                      letter,
                      style: context.textStyles.labelLarge?.copyWith(
                        color: chosen == letter ? colors.onPrimary : colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
