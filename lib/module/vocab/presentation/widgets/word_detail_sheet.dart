import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/tts/tts_service.dart';
import '../../../../helper/format.dart';
import '../../../plan/presentation/controllers/plan_controller.dart';
import '../../data/models/vocab_models.dart';
import '../../data/vocab_decks.dart';
import '../controllers/vocab_controller.dart';
import '../pages/vocab_form_sheet.dart';

/// Xem 1 từ: phát âm, nghĩa, ví dụ, trạng thái học. Admin có thêm Sửa / Xoá.
Future<void> showWordDetail(BuildContext context, VocabItem item) =>
    showAppBottomSheet<void>(context, builder: (_) => WordDetailSheet(vocabId: item.id));

class WordDetailSheet extends ConsumerStatefulWidget {
  const WordDetailSheet({super.key, required this.vocabId});

  final String vocabId;

  @override
  ConsumerState<WordDetailSheet> createState() => _WordDetailSheetState();
}

class _WordDetailSheetState extends ConsumerState<WordDetailSheet> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action, String done) async {
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) showAppSnackBar(context, done, tone: AppTone.success);
    } catch (e) {
      if (mounted) showAppSnackBar(context, AppException.from(e).message, tone: AppTone.danger);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reset(VocabItem v) async {
    final ok = await showAppConfirmDialog(
      context,
      title: 'Học lại "${v.word}"?',
      message: 'Tiến độ ôn của từ này bị xoá, từ quay về trạng thái chưa học.',
      confirmLabel: 'Học lại',
    );
    if (!ok || !mounted) return;
    await _run(
      () => ref.read(vocabListProvider.notifier).resetWord(v.id),
      'Đã đưa "${v.word}" về chưa học',
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(vocabListProvider).value;
    final v = items?.where((x) => x.id == widget.vocabId).firstOrNull;
    if (v == null) return const SizedBox(height: AppSizes.ringLg, child: AppLoadingView());
    final isAdmin = ref.watch(myPlanProvider).value?.isAdmin ?? false;
    final tts = ref.read(ttsServiceProvider);
    final muted = context.textStyles.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant);
    final now = DateTime.now();

    final (statusLabel, statusTone) = switch (v) {
      _ when v.isKnown => ('Đã biết', AppTone.success),
      _ when v.isMastered => ('Đã thuộc', AppTone.success),
      _ when v.isDue(now) => ('Cần ôn', AppTone.warning),
      _ when v.isLearning => (
        'Ôn lại ${Fmt.date(v.review!.dueAt.toLocal())}',
        AppTone.info,
      ),
      _ => ('Chưa học', AppTone.neutral),
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(v.word, style: context.textStyles.headlineSmall),
                      if (v.ipa case final ipa? when ipa.isNotEmpty) Text(ipa, style: muted),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Nghe phát âm',
                  icon: const Icon(Icons.volume_up_rounded),
                  onPressed: () => tts.speak(v.word),
                ),
              ],
            ),
            Gaps.v12,
            Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s4,
              children: [
                StatusBadge(label: statusLabel, tone: statusTone, icon: statusTone.icon),
                if (v.pos case final pos? when pos.isNotEmpty) StatusBadge(label: pos),
                StatusBadge(label: topicLabel(v.topic)),
                if (v.sourceTest case final t?)
                  StatusBadge(
                    label: v.sourceQuestion == null ? 'Test $t' : 'Test $t · câu ${v.sourceQuestion}',
                    icon: Icons.quiz_outlined,
                  ),
              ],
            ),
            Gaps.v16,
            Text(v.meaning, style: context.textStyles.titleLarge),
            if (v.example case final ex? when ex.isNotEmpty) ...[
              Gaps.v16,
              AppCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ex,
                            style: context.textStyles.bodyLarge?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          if (v.exampleMeaning case final vi? when vi.isNotEmpty) ...[
                            Gaps.v4,
                            Text(vi, style: muted),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Nghe câu ví dụ',
                      icon: const Icon(Icons.volume_up_outlined),
                      onPressed: () => tts.speak(ex),
                    ),
                  ],
                ),
              ),
            ],
            Gaps.v16,
            if (v.isNew || v.isLearning)
              FilledButton.tonalIcon(
                onPressed: _busy
                    ? null
                    : () => _run(
                        () => ref.read(vocabListProvider.notifier).markKnown(v),
                        'Đã đánh dấu "${v.word}" là đã biết',
                      ),
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('Đã biết từ này, bỏ qua'),
              )
            else
              OutlinedButton.icon(
                onPressed: _busy ? null : () => _reset(v),
                icon: const Icon(Icons.restart_alt_rounded),
                label: const Text('Học lại từ đầu'),
              ),
            if (isAdmin) ...[
              Gaps.v8,
              TextButton.icon(
                onPressed: _busy
                    ? null
                    : () {
                        Navigator.pop(context);
                        showVocabForm(context, item: v);
                      },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Sửa từ (admin)'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
