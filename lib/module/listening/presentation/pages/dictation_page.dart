import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../helper/dictation.dart';
import '../../../../helper/format.dart';
import '../../../goals/data/study_store.dart';
import '../../../test/data/models/test_models.dart';
import '../../../test/presentation/widgets/audio_bar.dart';
import '../controllers/dictation_providers.dart';

/// Chép chính tả từng đoạn audio: nghe → gõ → kiểm tra → xem transcript & nói theo.
class DictationPage extends ConsumerWidget {
  const DictationPage({super.key, required this.testId, required this.part});

  final String testId;
  final int part;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clips = ref.watch(dictationClipsProvider(testId, part));
    if (clips.value case final list?) {
      return list.isEmpty
          ? Scaffold(
              appBar: AppBar(),
              body: const AppEmptyView(
                icon: Icons.subtitles_off_outlined,
                message: 'Part này của đề chưa có transcript.\nHãy chọn Part hoặc đề khác.',
              ),
            )
          : _DictationSession(clips: list, part: part);
    }
    return Scaffold(
      appBar: AppBar(),
      body: AsyncView(
        value: clips,
        onRetry: () => ref.invalidate(dictationClipsProvider(testId, part)),
        data: (_) => const SizedBox.shrink(),
      ),
    );
  }
}

class _DictationSession extends ConsumerStatefulWidget {
  const _DictationSession({required this.clips, required this.part});

  final List<QuestionGroup> clips;
  final int part;

  @override
  ConsumerState<_DictationSession> createState() => _DictationSessionState();
}

class _DictationSessionState extends ConsumerState<_DictationSession> {
  final _input = TextEditingController();
  int _index = 0;
  DictationResult? _result;
  bool _showTranscript = false;

  /// Điểm từng đoạn đã chấm (index → tỉ lệ đúng).
  final _scores = <int, double>{};

  QuestionGroup get _clip => widget.clips[_index];

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _check() {
    final target = Dictation.lines(_clip.transcript!).join(' ');
    final r = Dictation.check(target, _input.text);
    if (!_scores.containsKey(_index)) ref.read(studyStoreProvider).record(StudyEvent.dictations);
    setState(() {
      _result = r;
      _scores[_index] = r.ratio;
      _showTranscript = true;
    });
  }

  void _go(int i) => setState(() {
    _index = i;
    _input.clear();
    _result = null;
    _showTranscript = false;
  });

  @override
  Widget build(BuildContext context) {
    final clip = _clip;
    final r = _result;
    final last = _index == widget.clips.length - 1;
    final avg = _scores.isEmpty ? null : _scores.values.reduce((a, b) => a + b) / _scores.length;
    final first = clip.questions.first.number, lastQ = clip.questions.last.number;

    return Scaffold(
      appBar: AppBar(
        title: Text('Đoạn ${_index + 1}/${widget.clips.length}'),
        actions: [
          if (avg != null)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.s16),
              child: Center(
                child: StatusBadge(label: 'TB ${Fmt.percent(avg)}', tone: AppTone.fromRatio(avg)),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: AppInsets.screen,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Text(
            first == lastQ ? 'Câu $first' : 'Câu $first–$lastQ',
            style: context.textStyles.titleMedium,
          ),
          Gaps.v8,
          AudioBar(key: ValueKey(clip.id), url: clip.audioUrl!),
          Gaps.v16,
          TextField(
            controller: _input,
            minLines: 4,
            maxLines: 10,
            enabled: r == null,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Gõ lại những gì bạn nghe được',
              alignLabelWithHint: true,
            ),
          ),
          if (r != null) ...[Gaps.v16, _ResultCard(result: r)],
          if (_showTranscript) ...[
            Gaps.v16,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const IconBadge(
                        icon: Icons.record_voice_over_outlined,
                        tone: AppTone.success,
                      ),
                      Gaps.h12,
                      Expanded(
                        child: Text(
                          'Nói theo: phát lại ở tốc độ 0.75x, đọc to từng câu',
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gaps.v12,
                  SelectableText(clip.transcript!, style: context.textStyles.bodyLarge),
                ],
              ),
            ),
          ] else if (r == null) ...[
            Gaps.v8,
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('Bỏ qua, xem transcript'),
                onPressed: () => setState(() => _showTranscript = true),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: AppBottomBar(
        child: Row(
          children: [
            IconButton(
              tooltip: 'Đoạn trước',
              onPressed: _index == 0 ? null : () => _go(_index - 1),
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Gaps.h8,
            Expanded(
              child: r == null
                  ? AppPrimaryButton(
                      icon: Icons.spellcheck_rounded,
                      label: 'Kiểm tra',
                      onPressed: _check,
                    )
                  : AppPrimaryButton(
                      icon: last ? Icons.check_rounded : Icons.arrow_forward_rounded,
                      label: last ? 'Hoàn thành' : 'Đoạn tiếp theo',
                      onPressed: last
                          ? () => Navigator.of(context).maybePop()
                          : () => _go(_index + 1),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});

  final DictationResult result;

  @override
  Widget build(BuildContext context) {
    final tone = AppTone.fromRatio(result.ratio);
    final danger = AppTone.danger.colorsOf(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledProgress(
            label: 'Nghe đúng',
            value: result.ratio,
            trailing: '${result.correct}/${result.total} từ · ${Fmt.percent(result.ratio)}',
          ),
          Gaps.v12,
          Text.rich(
            TextSpan(
              children: [
                for (final (word, ok) in result.tokens)
                  TextSpan(
                    text: '$word ',
                    style: ok
                        ? null
                        : TextStyle(
                            color: danger.main,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                  ),
              ],
            ),
            style: context.textStyles.bodyLarge,
          ),
          Gaps.v8,
          Row(
            children: [
              Icon(tone.icon, size: AppSizes.iconSm, color: tone.colorsOf(context).main),
              Gaps.h4,
              Expanded(
                child: Text(
                  'Từ gạch chân màu đỏ là từ bạn nghe sai hoặc bỏ sót.',
                  style: context.textStyles.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
