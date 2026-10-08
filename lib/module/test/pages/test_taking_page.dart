import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/async_view.dart';
import '../../../routes/app_router.dart';
import '../models.dart';
import '../test_repository.dart';
import '../widgets/question_group_view.dart';

class TestTakingPage extends ConsumerWidget {
  const TestTakingPage({super.key, required this.testId, required this.mode, required this.parts});

  final String testId;
  final String mode;
  final List<int> parts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(testDetailProvider(testId));
    if (detail is! AsyncData<TestDetail>) {
      return Scaffold(
        appBar: AppBar(),
        body: AsyncView(
          value: detail,
          onRetry: () => ref.invalidate(testDetailProvider(testId)),
          data: (_) => const SizedBox(),
        ),
      );
    }
    return _TakingView(detail: detail.value, mode: mode, parts: parts);
  }
}

class _TakingView extends ConsumerStatefulWidget {
  const _TakingView({required this.detail, required this.mode, required this.parts});

  final TestDetail detail;
  final String mode;
  final List<int> parts;

  @override
  ConsumerState<_TakingView> createState() => _TakingViewState();
}

class _TakingViewState extends ConsumerState<_TakingView> {
  late final List<QuestionGroup> _groups = widget.detail.groups
      .where((g) => widget.parts.contains(g.part))
      .toList();
  late final List<Question> _questions = [for (final g in _groups) ...g.questions];

  final _answers = <String, String?>{};
  final _revealed = <String>{};
  final _pageController = PageController();
  final _startedAt = DateTime.now();
  Timer? _timer;
  late Duration _clock;
  int _index = 0;
  bool _submitting = false;

  bool get _isExam => widget.mode == 'exam';

  @override
  void initState() {
    super.initState();
    // Thi thử: 120 phút cho 200 câu, chia theo tỉ lệ số câu đã chọn.
    _clock = _isExam
        ? Duration(seconds: (7200 * _questions.length / 200).round().clamp(300, 7200))
        : Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _clock += Duration(seconds: _isExam ? -1 : 1));
      if (_isExam && _clock <= Duration.zero) {
        _timer?.cancel();
        _submit(force: true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  int get _answeredCount => _answers.values.where((v) => v != null).length;

  void _select(Question q, String letter) {
    setState(() {
      _answers[q.id] = letter;
      if (!_isExam) _revealed.add(q.id);
    });
  }

  void _goTo(int i) {
    _pageController.animateToPage(
      i,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _submit({bool force = false}) async {
    if (_submitting) return;
    if (!force) {
      final unanswered = _questions.length - _answeredCount;
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Nộp bài?'),
          content: Text(
            unanswered > 0
                ? 'Bạn còn $unanswered câu chưa làm.'
                : 'Bạn đã làm hết ${_questions.length} câu.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Làm tiếp')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Nộp bài')),
          ],
        ),
      );
      if (ok != true) return;
    }
    setState(() => _submitting = true);
    try {
      final id = await ref
          .read(testRepositoryProvider)
          .submitAttempt(
            testId: widget.detail.summary.id,
            mode: widget.mode,
            parts: widget.parts,
            startedAt: _startedAt,
            questions: _questions,
            answers: {
              for (final e in _answers.entries)
                if (e.value != null) e.key: e.value!,
            },
          );
      _timer?.cancel();
      ref.invalidate(attemptsProvider);
      ref.invalidate(partStatsProvider);
      if (mounted) context.pushReplacement(Routes.result(id));
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nộp bài thất bại: $e'),
          action: SnackBarAction(label: 'Thử lại', onPressed: () => _submit(force: true)),
        ),
      );
    }
  }

  Future<bool> _confirmExit() async {
    if (_answeredCount == 0) return true;
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
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          builder: (ctx, scroll) => GridView.count(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            crossAxisCount: 6,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              for (final (gi, g) in _groups.indexed)
                for (final q in g.questions)
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.pop(ctx);
                      _goTo(gi);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _answers[q.id] != null
                            ? scheme.primary
                            : scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                        border: gi == _index ? Border.all(color: scheme.tertiary, width: 2) : null,
                      ),
                      child: Text(
                        '${q.number}',
                        style: TextStyle(
                          color: _answers[q.id] != null ? scheme.onPrimary : scheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }

  String _fmtClock(Duration d) {
    final h = d.inHours, m = d.inMinutes.remainder(60), s = d.inSeconds.remainder(60);
    final mm = m.toString().padLeft(2, '0'), ss = s.toString().padLeft(2, '0');
    return h > 0 ? '$h:$mm:$ss' : '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lowTime = _isExam && _clock.inMinutes < 5;
    if (_groups.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Không có câu hỏi.')),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExit() && context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('$_answeredCount/${_questions.length} câu'),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  avatar: Icon(_isExam ? Icons.timer_outlined : Icons.schedule, size: 18),
                  label: Text(
                    _fmtClock(_clock),
                    style: TextStyle(
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: lowTime ? scheme.error : null,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: _submitting ? null : () => _submit(),
              child: _submitting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Nộp bài'),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: LinearProgressIndicator(value: (_index + 1) / _groups.length, minHeight: 3),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _groups.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, i) => QuestionGroupView(
            key: ValueKey(_groups[i].id),
            group: _groups[i],
            answers: _answers,
            onSelect: _select,
            isRevealed: (q) => _revealed.contains(q.id),
            showTranscript: !_isExam,
            autoPlayAudio: _isExam,
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: Row(
              children: [
                IconButton.filledTonal(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _index > 0 ? () => _goTo(_index - 1) : null,
                ),
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.grid_view_rounded),
                    label: Text(
                      'Câu ${_groups[_index].questions.first.number}'
                      '${_groups[_index].questions.length > 1 ? '–${_groups[_index].questions.last.number}' : ''}',
                    ),
                    onPressed: _showPalette,
                  ),
                ),
                _index < _groups.length - 1
                    ? IconButton.filled(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () => _goTo(_index + 1),
                      )
                    : FilledButton(
                        onPressed: _submitting ? null : () => _submit(),
                        child: const Text('Nộp bài'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
