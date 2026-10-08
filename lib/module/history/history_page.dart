import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
import '../../core/widgets/async_view.dart';
import '../../helper/score.dart';
import '../../routes/app_router.dart';
import '../test/models.dart';
import '../test/test_repository.dart';
import '../test/widgets/question_group_view.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  Future<void> _refresh(WidgetRef ref) {
    ref.invalidate(partStatsProvider);
    return ref.refresh(attemptsProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attempts = ref.watch(attemptsProvider);
    final stats = ref.watch(partStatsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Tiến độ')),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: AsyncView(
          value: attempts,
          onRetry: () => _refresh(ref),
          data: (list) => list.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 120),
                    EmptyView(icon: Icons.insights_outlined, message: 'Chưa có bài làm nào.'),
                  ],
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _Overview(attempts: list),
                    const SizedBox(height: 16),
                    if (stats.value case final s? when s.isNotEmpty) ...[
                      _PartAccuracy(stats: s),
                      const SizedBox(height: 16),
                    ],
                    Text('Lịch sử làm bài', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    for (final a in list) _AttemptTile(attempt: a),
                  ],
                ),
        ),
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.attempts});

  final List<Attempt> attempts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final full = attempts.where((a) => a.isFullTest).toList();
    final best = full.isEmpty
        ? null
        : full
              .map(
                (a) =>
                    ToeicScore.listening(a.listeningCorrect) + ToeicScore.reading(a.readingCorrect),
              )
              .reduce((x, y) => x > y ? x : y);
    final totalQ = attempts.fold(0, (s, a) => s + a.totalQuestions);
    final totalC = attempts.fold(0, (s, a) => s + a.correct);

    Widget stat(String value, String label) => Expanded(
      child: Column(
        children: [
          Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          Text(label, style: theme.textTheme.labelMedium, textAlign: TextAlign.center),
        ],
      ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Row(
          children: [
            stat('${attempts.length}', 'Lượt làm'),
            stat('$totalQ', 'Câu đã làm'),
            stat(totalQ == 0 ? '-' : '${(totalC * 100 / totalQ).round()}%', 'Tỉ lệ đúng'),
            stat(best?.toString() ?? '-', 'Điểm cao nhất\n(full test)'),
          ],
        ),
      ),
    );
  }
}

class _PartAccuracy extends StatelessWidget {
  const _PartAccuracy({required this.stats});

  final List<PartStat> stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weakest = [...stats]..sort((a, b) => a.accuracy.compareTo(b.accuracy));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Độ chính xác theo Part', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Yếu nhất: ${partNames[weakest.first.part]}',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
            ),
            const SizedBox(height: 12),
            for (final s in stats)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(width: 56, child: Text('Part ${s.part}')),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: s.accuracy,
                          minHeight: 10,
                          color: s.accuracy >= 0.7
                              ? AppTheme.correct
                              : s.accuracy >= 0.5
                              ? Colors.orange
                              : AppTheme.wrong,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      child: Text('${(s.accuracy * 100).round()}%', textAlign: TextAlign.end),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AttemptTile extends ConsumerWidget {
  const _AttemptTile({required this.attempt});

  final Attempt attempt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = attempt;
    final d = a.finishedAt;
    final date = '${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
    final score = a.isFullTest
        ? '${ToeicScore.listening(a.listeningCorrect) + ToeicScore.reading(a.readingCorrect)}'
        : '${a.correct}/${a.totalQuestions}';

    return Dismissible(
      key: ValueKey(a.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).colorScheme.errorContainer,
        child: const Icon(Icons.delete_outline),
      ),
      confirmDismiss: (_) async =>
          await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Xoá bài làm này?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Huỷ')),
                TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Xoá')),
              ],
            ),
          ) ??
          false,
      onDismissed: (_) async {
        await ref.read(testRepositoryProvider).deleteAttempt(a.id);
        ref.invalidate(attemptsProvider);
        ref.invalidate(partStatsProvider);
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          child: Icon(a.mode == 'exam' ? Icons.timer_outlined : Icons.lightbulb_outline),
        ),
        title: Text(a.testTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('$date · Part ${a.parts.join(',')} · ${a.duration.inMinutes} phút'),
        trailing: Text(
          score,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        onTap: () => context.push(Routes.result(a.id)),
      ),
    );
  }
}
