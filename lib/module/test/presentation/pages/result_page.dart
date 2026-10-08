import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme.dart';
import '../../../../core/widgets/async_view.dart';
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
    final theme = Theme.of(context);
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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(a.testTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  '${a.correct}/${questions.length}',
                  style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text('câu đúng · $pct%'),
                if (listeningTotal == 100 || readingTotal == 100) ...[
                  const Divider(height: 32),
                  Row(
                    children: [
                      if (listeningTotal == 100)
                        _ScoreBox(
                          label: 'Listening',
                          score: ToeicScore.listening(a.listeningCorrect),
                        ),
                      if (readingTotal == 100)
                        _ScoreBox(label: 'Reading', score: ToeicScore.reading(a.readingCorrect)),
                      if (listeningTotal == 100 && readingTotal == 100)
                        _ScoreBox(
                          label: 'Tổng',
                          score:
                              ToeicScore.listening(a.listeningCorrect) +
                              ToeicScore.reading(a.readingCorrect),
                          highlight: true,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Điểm quy đổi ước tính', style: theme.textTheme.bodySmall),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Theo Part', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final p in byPart.keys.toList()..sort())
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _PartBar(part: p, correct: byPart[p]!.$1, total: byPart[p]!.$2),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: Text('Đáp án', style: theme.textTheme.titleMedium)),
            FilterChip(
              label: const Text('Chỉ câu sai'),
              selected: _wrongOnly,
              onSelected: (v) => setState(() => _wrongOnly = v),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (gi, g) in widget.data.groups.indexed)
              for (final q in g.questions)
                if (!_wrongOnly || !_isCorrect(q))
                  _AnswerChip(
                    number: q.number,
                    correct: _isCorrect(q),
                    skipped: widget.data.answers[q.id] == null,
                    onTap: () => _openReview(gi),
                  ),
          ],
        ),
        const SizedBox(height: 24),
        FilledButton.tonalIcon(
          icon: const Icon(Icons.menu_book_outlined),
          label: const Text('Xem lại toàn bộ'),
          onPressed: widget.data.groups.isEmpty ? null : () => _openReview(0),
        ),
      ],
    );
  }
}

class _ScoreBox extends StatelessWidget {
  const _ScoreBox({required this.label, required this.score, this.highlight = false});

  final String label;
  final int score;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(
            '$score',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: highlight ? theme.colorScheme.primary : null,
            ),
          ),
          Text(label, style: theme.textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _PartBar extends StatelessWidget {
  const _PartBar({required this.part, required this.correct, required this.total});

  final int part;
  final int correct;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : correct / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(partNames[part] ?? 'Part $part')),
            Text('$correct/$total', style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            color: ratio >= 0.7
                ? AppTheme.correct
                : ratio >= 0.5
                ? Colors.orange
                : AppTheme.wrong,
          ),
        ),
      ],
    );
  }
}

class _AnswerChip extends StatelessWidget {
  const _AnswerChip({
    required this.number,
    required this.correct,
    required this.skipped,
    required this.onTap,
  });

  final int number;
  final bool correct;
  final bool skipped;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = correct
        ? AppTheme.correct
        : skipped
        ? Theme.of(context).colorScheme.outline
        : AppTheme.wrong;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 48,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '$number',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
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
