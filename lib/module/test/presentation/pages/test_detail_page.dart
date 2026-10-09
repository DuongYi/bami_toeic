import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../helper/format.dart';
import '../../../../routes/app_router.dart';
import '../../data/in_progress_store.dart';
import '../../data/models/test_models.dart';
import '../controllers/test_providers.dart';
import '../widgets/question_group_view.dart';

class TestDetailPage extends ConsumerWidget {
  const TestDetailPage({super.key, required this.testId});

  final String testId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(testDetailProvider(testId));
    if (detail.value case final d?) return _DetailBody(detail: d);
    return Scaffold(
      appBar: AppBar(),
      body: AsyncView(
        value: detail,
        onRetry: () => ref.invalidate(testDetailProvider(testId)),
        data: (_) => const SizedBox.shrink(),
      ),
    );
  }
}

class _DetailBody extends ConsumerStatefulWidget {
  const _DetailBody({required this.detail});

  final TestDetail detail;

  @override
  ConsumerState<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends ConsumerState<_DetailBody> {
  late final Map<int, int> _perPart = widget.detail.questionsPerPart;
  late Set<int> _selected = _perPart.keys.toSet();
  String _mode = 'practice';

  int get _count => _selected.fold(0, (s, p) => s + (_perPart[p] ?? 0));

  @override
  Widget build(BuildContext context) {
    final s = widget.detail.summary;
    final parts = _perPart.keys.toList()..sort();
    final allSelected = _selected.length == parts.length;
    final muted = context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant);

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.s24),
        children: [
          // Thông tin đề
          Row(
            children: [
              const IconBadge(icon: Icons.menu_book_rounded, size: AppSizes.badgeLg),
              Gaps.h16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(s.title, style: context.textStyles.headlineSmall),
                    ),
                    Text(
                      [
                        if (s.source != null) s.source!,
                        '${s.questionCount} câu',
                        '${parts.length} Part',
                      ].join(' · '),
                      style: muted,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (s.description != null) ...[Gaps.v12, Text(s.description!, style: muted)],
          if (ref.watch(inProgressProvider(s.id)).value case final snap?) ...[
            Gaps.v16,
            _ResumeCard(snapshot: snap),
          ],
          Gaps.v24,
          const SectionHeader(title: 'Chế độ'),
          ChoiceCard(
            icon: Icons.lightbulb_outline_rounded,
            title: 'Luyện tập',
            subtitle: 'Hiện đáp án và giải thích ngay. Không giới hạn thời gian.',
            selected: _mode == 'practice',
            onTap: () => setState(() => _mode = 'practice'),
          ),
          Gaps.v8,
          ChoiceCard(
            icon: Icons.timer_outlined,
            title: 'Thi thử',
            subtitle: 'Tính giờ như thi thật (120 phút / 200 câu), chấm khi nộp.',
            selected: _mode == 'exam',
            onTap: () => setState(() => _mode = 'exam'),
          ),
          Gaps.v24,
          SectionHeader(
            title: 'Chọn Part',
            subtitle: 'Đã chọn $_count câu',
            trailing: TextButton(
              onPressed: () => setState(() => _selected = allSelected ? {} : parts.toSet()),
              child: Text(allSelected ? 'Bỏ chọn' : 'Chọn tất cả'),
            ),
          ),
          for (final p in parts) ...[
            ChoiceCard(
              multiSelect: true,
              icon: p <= 4 ? Icons.headphones_rounded : Icons.chrome_reader_mode_outlined,
              title: partNames[p] ?? 'Part $p',
              subtitle: '${_perPart[p]} câu · ${p <= 4 ? 'Listening' : 'Reading'}',
              selected: _selected.contains(p),
              onTap: () =>
                  setState(() => _selected.contains(p) ? _selected.remove(p) : _selected.add(p)),
            ),
            Gaps.v8,
          ],
        ],
      ),
      bottomNavigationBar: AppBottomBar(
        child: AppPrimaryButton(
          icon: Icons.play_arrow_rounded,
          label: _selected.isEmpty ? 'Chọn ít nhất 1 Part' : 'Bắt đầu · $_count câu',
          onPressed: _selected.isEmpty
              ? null
              : () =>
                    context.push(Routes.take(s.id, mode: _mode, parts: _selected.toList()..sort())),
        ),
      ),
    );
  }
}

/// Bài làm dở của đề: tiếp tục đúng chế độ/Part đã chọn, hoặc bỏ để làm lại.
class _ResumeCard extends ConsumerWidget {
  const _ResumeCard({required this.snapshot});

  final TakingSnapshot snapshot;

  Future<void> _discard(BuildContext context, WidgetRef ref) async {
    final ok = await showAppConfirmDialog(
      context,
      title: 'Bỏ bài làm dở?',
      message: 'Các câu đã làm trong lượt này sẽ bị xoá.',
      confirmLabel: 'Bỏ bài',
      cancelLabel: 'Giữ lại',
      destructive: true,
    );
    if (ok) await ref.read(inProgressStoreProvider).discard(snapshot.testId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snap = snapshot;
    final muted = context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant);
    final clock = Fmt.clock(Duration(seconds: snap.clockSeconds));
    return AppCard(
      tone: AppTone.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadge(
                icon: snap.isExam ? Icons.timer_outlined : Icons.lightbulb_outline_rounded,
                size: AppSizes.badgeMd,
              ),
              Gaps.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Đang làm dở', style: context.textStyles.titleMedium),
                    Text(
                      [
                        snap.isExam ? 'Thi thử · còn $clock' : 'Luyện tập · $clock',
                        'Part ${snap.parts.join(', ')}',
                        'Lưu ${Fmt.dateTime(snap.savedAt.toLocal())}',
                      ].join(' · '),
                      style: muted,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gaps.v12,
          LabeledProgress(
            label: 'Đã làm',
            value: snap.totalQuestions == 0 ? 0 : snap.answers.length / snap.totalQuestions,
            trailing: '${snap.answers.length}/${snap.totalQuestions}',
          ),
          Gaps.v12,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _discard(context, ref),
                  child: const Text('Làm lại từ đầu'),
                ),
              ),
              Gaps.h8,
              Expanded(
                child: FilledButton.tonalIcon(
                  icon: const Icon(Icons.play_arrow_rounded),
                  onPressed: () =>
                      context.push(Routes.take(snap.testId, mode: snap.mode, parts: snap.parts)),
                  label: const Text('Tiếp tục'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
