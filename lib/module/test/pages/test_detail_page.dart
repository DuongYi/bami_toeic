import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/async_view.dart';
import '../../../routes/app_router.dart';
import '../models.dart';
import '../test_repository.dart';
import '../widgets/question_group_view.dart';

class TestDetailPage extends ConsumerWidget {
  const TestDetailPage({super.key, required this.testId});

  final String testId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(testDetailProvider(testId));
    return Scaffold(
      appBar: AppBar(title: Text(detail.value?.summary.title ?? '')),
      body: AsyncView(
        value: detail,
        onRetry: () => ref.invalidate(testDetailProvider(testId)),
        data: (d) => _DetailBody(detail: d),
      ),
    );
  }
}

class _DetailBody extends StatefulWidget {
  const _DetailBody({required this.detail});

  final TestDetail detail;

  @override
  State<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends State<_DetailBody> {
  late final Map<int, int> _perPart = widget.detail.questionsPerPart;
  late Set<int> _selected = _perPart.keys.toSet();
  String _mode = 'practice';

  int get _count => _selected.fold(0, (s, p) => s + (_perPart[p] ?? 0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = widget.detail.summary;
    final parts = _perPart.keys.toList()..sort();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (s.description != null) ...[
          Text(s.description!, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
        ],
        Text('Chế độ', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(
              value: 'practice',
              icon: Icon(Icons.lightbulb_outline),
              label: Text('Luyện tập'),
            ),
            ButtonSegment(value: 'exam', icon: Icon(Icons.timer_outlined), label: Text('Thi thử')),
          ],
          selected: {_mode},
          onSelectionChanged: (v) => setState(() => _mode = v.first),
        ),
        const SizedBox(height: 6),
        Text(
          _mode == 'practice'
              ? 'Hiện đáp án và giải thích ngay sau mỗi câu. Không giới hạn thời gian.'
              : 'Tính giờ như thi thật (120 phút / 200 câu). Chấm điểm khi nộp bài.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: Text('Chọn Part', style: theme.textTheme.titleMedium)),
            TextButton(
              onPressed: () =>
                  setState(() => _selected = _selected.length == parts.length ? {} : parts.toSet()),
              child: Text(_selected.length == parts.length ? 'Bỏ chọn' : 'Chọn tất cả'),
            ),
          ],
        ),
        for (final p in parts)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _selected.contains(p),
            title: Text(partNames[p] ?? 'Part $p'),
            subtitle: Text('${_perPart[p]} câu'),
            onChanged: (v) => setState(() => v! ? _selected.add(p) : _selected.remove(p)),
          ),
        const SizedBox(height: 24),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          icon: const Icon(Icons.play_arrow_rounded),
          label: Text('Bắt đầu · $_count câu'),
          onPressed: _selected.isEmpty
              ? null
              : () =>
                    context.push(Routes.take(s.id, mode: _mode, parts: _selected.toList()..sort())),
        ),
      ],
    );
  }
}
