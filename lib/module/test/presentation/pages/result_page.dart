import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../helper/score.dart';
import '../../../../routes/app_router.dart';
import '../../data/models/test_models.dart';
import '../controllers/test_providers.dart';
import '../widgets/question_group_view.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key, required this.attemptId});

  final String attemptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(attemptResultProvider(attemptId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.canPop() ? context.pop() : context.go(Routes.tests),
        ),
      ),
      body: AsyncView(
        value: data,
        onRetry: () => ref.invalidate(attemptResultProvider(attemptId)),
        data: (d) => _ResultBody(data: d),
      ),
    );
  }
}

class _ResultBody extends StatefulWidget {
  const _ResultBody({required this.data});

  final AttemptResult data;

  @override
  State<_ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<_ResultBody> {
  bool _wrongOnly = false;

  bool _isCorrect(Question q) => widget.data.isCorrect(q);

  void _openReview(int groupIndex) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _ReviewPager(
          groups: widget.data.groups,
          answers: widget.data.answers,
          initial: groupIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.data.attempt;
    final questions = widget.data.questions;

    final byPart = <int, (int, int)>{};
    for (final q in questions) {
      final (c, t) = byPart[q.part] ?? (0, 0);
      byPart[q.part] = (c + (_isCorrect(q) ? 1 : 0), t + 1);
    }
    final listeningTotal = questions.where((q) => ToeicScore.isListening(q.part)).length;
    final readingTotal = questions.length - listeningTotal;
    final pct = questions.isEmpty ? 0 : (a.correct * 100 / questions.length).round();
    final listening = ToeicScore.listening(a.listeningCorrect);
    final reading = ToeicScore.reading(a.readingCorrect);

    return ListView(
      padding: AppInsets.screen,
      children: [
        Text(a.testTitle, style: context.textStyles.titleMedium),
        Gaps.v12,
        AppCard(
          padding: AppInsets.cardLarge,
          child: Column(
            children: [
              Text('${a.correct}/${questions.length}', style: context.textStyles.displaySmall),
              Text('câu đúng · $pct%'),
              if (listeningTotal == 100 || readingTotal == 100) ...[
                const Divider(),
                Row(
                  children: [
                    if (listeningTotal == 100) StatTile(value: '$listening', label: 'Listening'),
                    if (readingTotal == 100) StatTile(value: '$reading', label: 'Reading'),
                    if (listeningTotal == 100 && readingTotal == 100)
                      StatTile(value: '${listening + reading}', label: 'Tổng', highlight: true),
                  ],
                ),
                Gaps.v8,
                Text('Điểm quy đổi ước tính', style: context.textStyles.bodySmall),
              ],
            ],
          ),
        ),
        Gaps.v24,
        const SectionHeader(title: 'Theo Part'),
        for (final p in byPart.keys.toList()..sort())
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s12),
            child: LabeledProgress(
              label: partNames[p] ?? 'Part $p',
              value: byPart[p]!.$2 == 0 ? 0 : byPart[p]!.$1 / byPart[p]!.$2,
              trailing: '${byPart[p]!.$1}/${byPart[p]!.$2}',
            ),
          ),
        Gaps.v12,
        SectionHeader(
          title: 'Đáp án',
          trailing: FilterChip(
            label: const Text('Chỉ câu sai'),
            selected: _wrongOnly,
            onSelected: (v) => setState(() => _wrongOnly = v),
          ),
        ),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            for (final (gi, g) in widget.data.groups.indexed)
              for (final q in g.questions)
                if (!_wrongOnly || !_isCorrect(q)) _answerCell(q, () => _openReview(gi)),
          ],
        ),
        Gaps.v24,
        FilledButton.tonalIcon(
          icon: const Icon(Icons.menu_book_outlined),
          label: const Text('Xem lại toàn bộ'),
          onPressed: widget.data.groups.isEmpty ? null : () => _openReview(0),
        ),
      ],
    );
  }

  Widget _answerCell(Question q, VoidCallback onTap) {
    final skipped = widget.data.answers[q.id] == null;
    final (tone, status) = _isCorrect(q)
        ? (AppTone.success, 'đúng')
        : skipped
        ? (AppTone.neutral, 'bỏ trống')
        : (AppTone.danger, 'sai');
    return NumberCell(
      number: q.number,
      tone: tone,
      semanticLabel: 'Câu ${q.number}, $status',
      onTap: onTap,
    );
  }
}

class _ReviewPager extends StatefulWidget {
  const _ReviewPager({required this.groups, required this.answers, required this.initial});

  final List<QuestionGroup> groups;
  final Map<String, String?> answers;
  final int initial;

  @override
  State<_ReviewPager> createState() => _ReviewPagerState();
}

class _ReviewPagerState extends State<_ReviewPager> {
  late final _controller = PageController(initialPage: widget.initial);
  late int _index = widget.initial;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Xem lại · ${_index + 1}/${widget.groups.length}')),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.groups.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (_, i) => QuestionGroupView(
          key: ValueKey(widget.groups[i].id),
          group: widget.groups[i],
          answers: widget.answers,
          isRevealed: (_) => true,
          showTranscript: true,
        ),
      ),
    );
  }
}
