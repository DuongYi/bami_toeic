import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../helper/format.dart';
import '../../../../helper/score.dart';
import '../../../../routes/app_router.dart';
import '../../../test/data/models/test_models.dart';
import '../../../test/presentation/controllers/test_providers.dart';
import '../../../test/presentation/widgets/question_group_view.dart';

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
              ? const ScrollableFill(
                  child: AppEmptyView(
                    icon: Icons.insights_outlined,
                    message: 'Chưa có bài làm nào.\nLàm một đề để bắt đầu theo dõi tiến độ.',
                  ),
                )
              : ListView(
                  padding: AppInsets.screen,
                  children: [
                    _Overview(attempts: list),
                    Gaps.v16,
                    if (stats.value case final s? when s.isNotEmpty) ...[
                      _PartAccuracy(stats: s),
                      Gaps.v24,
                    ],
                    const SectionHeader(title: 'Lịch sử làm bài'),
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

    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24, horizontal: AppSpacing.s8),
      child: Row(
        children: [
          StatTile(value: '${attempts.length}', label: 'Lượt làm'),
          StatTile(value: '$totalQ', label: 'Câu đã làm'),
          StatTile(value: totalQ == 0 ? '-' : Fmt.percent(totalC / totalQ), label: 'Tỉ lệ đúng'),
          StatTile(
            value: best?.toString() ?? '-',
            label: 'Điểm cao nhất\n(full test)',
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _PartAccuracy extends StatelessWidget {
  const _PartAccuracy({required this.stats});

  final List<PartStat> stats;

  @override
  Widget build(BuildContext context) {
    final weakest = [...stats]..sort((a, b) => a.accuracy.compareTo(b.accuracy));
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Độ chính xác theo Part',
            subtitle: 'Yếu nhất: ${partNames[weakest.first.part]}',
          ),
          Gaps.v4,
          for (final s in stats)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s12),
              child: LabeledProgress(
                label: partNames[s.part] ?? 'Part ${s.part}',
                value: s.accuracy,
                trailing: Fmt.percent(s.accuracy),
              ),
            ),
        ],
      ),
    );
  }
}

class _AttemptTile extends ConsumerWidget {
  const _AttemptTile({required this.attempt});

  final Attempt attempt;

  Future<bool> _confirmDelete(BuildContext context) => showAppConfirmDialog(
    context,
    title: 'Xoá bài làm này?',
    message: 'Kết quả và đáp án của lượt làm sẽ bị xoá vĩnh viễn.',
    confirmLabel: 'Xoá',
    destructive: true,
  );

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    // Tile bị gỡ khỏi cây ngay (xoá lạc quan) nên lấy messenger trước khi await.
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(attemptsProvider.notifier).delete(attempt.id);
    } catch (e) {
      showAppSnackBarOn(
        messenger,
        'Xoá thất bại: ${AppException.from(e).message}',
        tone: AppTone.danger,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = attempt;
    final score = a.isFullTest
        ? '${ToeicScore.listening(a.listeningCorrect) + ToeicScore.reading(a.readingCorrect)}'
        : '${a.correct}/${a.totalQuestions}';

    return Semantics(
      // Thay thế cho thao tác vuốt (WCAG 2.5.7).
      customSemanticsActions: {
        const CustomSemanticsAction(label: 'Xoá'): () async {
          if (await _confirmDelete(context) && context.mounted) _delete(context, ref);
        },
      },
      child: Dismissible(
        key: ValueKey(a.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSpacing.s24),
          color: context.colors.errorContainer,
          child: Icon(Icons.delete_outline, color: context.colors.onErrorContainer),
        ),
        confirmDismiss: (_) => _confirmDelete(context),
        onDismissed: (_) => _delete(context, ref),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            child: Icon(a.isExam ? Icons.timer_outlined : Icons.lightbulb_outline),
          ),
          title: Text(a.testTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            '${Fmt.dateTime(a.finishedAt)} · Part ${a.parts.join(',')} · '
            '${a.duration.inMinutes} phút',
          ),
          trailing: Text(score, style: context.textStyles.titleMedium),
          onTap: () => context.push(Routes.result(a.id)),
          onLongPress: () async {
            if (await _confirmDelete(context) && context.mounted) _delete(context, ref);
          },
        ),
      ),
    );
  }
}
