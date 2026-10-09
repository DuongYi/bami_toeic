import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/tts/tts_service.dart';
import '../../../../routes/app_router.dart';
import '../../data/practice.dart';
import '../controllers/practice_controller.dart';
import '../controllers/vocab_controller.dart';

/// 1 lượt luyện chủ động ([practiceLength] câu). [retryIds]: luyện lại các từ đã sai.
class PracticePage extends ConsumerStatefulWidget {
  const PracticePage({super.key, required this.mode, this.retryIds = ''});

  final PracticeMode mode;
  final String retryIds;

  @override
  ConsumerState<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends ConsumerState<PracticePage> {
  final _typed = TextEditingController();
  final _focus = FocusNode();

  PracticeSessionProvider get _provider => practiceSessionProvider(widget.mode, widget.retryIds);

  @override
  void dispose() {
    _typed.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _speakCurrent() {
    final q = ref.read(_provider).value?.current;
    if (q != null) ref.read(ttsServiceProvider).speak(q.item.word);
  }

  void _next() {
    _typed.clear();
    ref.read(_provider.notifier).next();
    // Dạng nghe: tự phát âm câu tiếp theo.
    if (widget.mode == PracticeMode.listen) _speakCurrent();
    if (widget.mode == PracticeMode.spell) _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(_provider);
    final s = session.value;

    // Dạng nghe: phát âm ngay khi lượt luyện sẵn sàng.
    ref.listen(_provider, (prev, next) {
      if (widget.mode == PracticeMode.listen && prev?.value == null && next.value != null) {
        _speakCurrent();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode.label),
        bottom: s == null || s.finished || s.questions.isEmpty
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(AppSizes.progressThin),
                child: LinearProgressIndicator(value: s.index / s.questions.length),
              ),
      ),
      body: AsyncView(
        value: session,
        onRetry: () => ref.invalidate(_provider),
        data: (s) {
          if (s.questions.isEmpty) {
            return AppEmptyView(
              icon: Icons.style_outlined,
              message: widget.mode == PracticeMode.cloze
                  ? 'Chưa đủ từ có câu ví dụ để luyện.\nHọc thêm vài từ bằng flashcard trước nhé.'
                  : 'Chưa có từ để luyện.\nHọc vài từ bằng flashcard trước nhé.',
              action: FilledButton.tonal(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('Đóng'),
              ),
            );
          }
          if (s.finished) return _Summary(state: s, mode: widget.mode);
          return ListView(
            padding: AppInsets.screen,
            children: [
              Text(
                'Câu ${s.index + 1}/${s.questions.length}',
                style: context.textStyles.labelLarge?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              Gaps.v8,
              _Prompt(question: s.current!, revealed: s.answered, onSpeak: _speakCurrent),
              Gaps.v16,
              if (s.current!.mode.hasOptions)
                for (final (i, option) in s.current!.options.indexed) ...[
                  _OptionTile(
                    text: option,
                    state: !s.answered
                        ? _OptionState.idle
                        : i == s.current!.answerIndex
                        ? _OptionState.right
                        : i == s.picked
                        ? _OptionState.wrong
                        : _OptionState.dimmed,
                    onTap: () => ref.read(_provider.notifier).choose(i),
                  ),
                  Gaps.v8,
                ]
              else
                TextField(
                  controller: _typed,
                  focusNode: _focus,
                  autofocus: true,
                  enabled: !s.answered,
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(labelText: 'Gõ từ tiếng Anh'),
                  onSubmitted: ref.read(_provider.notifier).submitSpelling,
                ),
              if (s.answered) ...[
                Gaps.v8,
                _Feedback(state: s),
              ],
            ],
          );
        },
      ),
      bottomNavigationBar: s == null || s.finished || s.questions.isEmpty
          ? null
          : AppBottomBar(
              child: s.answered
                  ? AppPrimaryButton(
                      label: s.index + 1 == s.questions.length ? 'Xem kết quả' : 'Tiếp tục',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: _next,
                    )
                  : s.current!.mode.hasOptions
                  ? const SizedBox.shrink()
                  : AppPrimaryButton(
                      label: 'Kiểm tra',
                      onPressed: () => ref.read(_provider.notifier).submitSpelling(_typed.text),
                    ),
            ),
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({required this.question, required this.revealed, required this.onSpeak});

  final PracticeQuestion question;
  final bool revealed;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final v = question.item;
    final muted = context.textStyles.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant);
    final (hint, body) = switch (question.mode) {
      PracticeMode.meaning => (
        'Chọn nghĩa đúng của từ',
        Column(
          children: [
            Text(v.word, textAlign: TextAlign.center, style: context.textStyles.headlineSmall),
            if (v.ipa case final ipa? when ipa.isNotEmpty) Text(ipa, style: muted),
          ],
        ),
      ),
      PracticeMode.listen => (
        'Nghe và chọn từ vừa đọc',
        IconButton.filledTonal(
          iconSize: AppSizes.iconLg,
          tooltip: 'Nghe lại',
          icon: const Icon(Icons.volume_up_rounded),
          onPressed: onSpeak,
        ),
      ),
      PracticeMode.cloze => (
        'Chọn từ phù hợp với chỗ trống',
        Column(
          children: [
            Text(
              question.cloze ?? '',
              textAlign: TextAlign.center,
              style: context.textStyles.bodyLarge,
            ),
            if (revealed && v.exampleMeaning != null) ...[
              Gaps.v8,
              Text(v.exampleMeaning!, textAlign: TextAlign.center, style: muted),
            ],
          ],
        ),
      ),
      PracticeMode.spell => (
        'Gõ từ tiếng Anh có nghĩa',
        Column(
          children: [
            Text(v.meaning, textAlign: TextAlign.center, style: context.textStyles.titleLarge),
            Gaps.v4,
            Text(
              [
                if (v.pos case final pos? when pos.isNotEmpty) pos,
                '${v.word.length} ký tự',
                'bắt đầu bằng "${v.word[0]}"',
              ].join(' · '),
              style: muted,
            ),
          ],
        ),
      ),
    };
    return AppCard(
      padding: AppInsets.cardLarge,
      child: Column(
        children: [
          Text(hint, style: muted),
          Gaps.v12,
          body,
        ],
      ),
    );
  }
}

enum _OptionState { idle, right, wrong, dimmed }

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.text, required this.state, required this.onTap});

  final String text;
  final _OptionState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = switch (state) {
      _OptionState.right => AppTone.success,
      _OptionState.wrong => AppTone.danger,
      _ => null,
    };
    final c = tone?.colorsOf(context);
    return Semantics(
      button: true,
      label: switch (state) {
        _OptionState.right => '$text, đáp án đúng',
        _OptionState.wrong => '$text, sai',
        _ => text,
      },
      excludeSemantics: true,
      child: Material(
        color: c?.container ?? context.surfaces.raised,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brMd,
          side: BorderSide(color: c?.main ?? context.colors.outlineVariant),
        ),
        child: InkWell(
          borderRadius: AppRadius.brMd,
          onTap: state == _OptionState.idle ? onTap : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.touchTarget),
            child: Padding(
              padding: AppInsets.card,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: context.textStyles.bodyLarge?.copyWith(
                        color: state == _OptionState.dimmed
                            ? context.colors.onSurfaceVariant
                            : c?.onContainer,
                      ),
                    ),
                  ),
                  if (tone != null) Icon(tone.icon, color: c!.main, size: AppSizes.iconSm),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Đúng / sai + đáp án + nghĩa và ví dụ để nhớ lại.
class _Feedback extends ConsumerWidget {
  const _Feedback({required this.state});

  final PracticeState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = state.current!;
    final v = q.item;
    final ok = state.lastCorrect;
    return AppBanner(
      tone: ok ? AppTone.success : AppTone.danger,
      icon: ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
      message: [
        if (ok) 'Chính xác!' else 'Chưa đúng.',
        if (q.mode == PracticeMode.spell && !ok) 'Bạn gõ "${state.typed}".',
        '${v.word}${v.pos == null ? '' : ' (${v.pos})'}: ${v.meaning}',
        if (q.mode != PracticeMode.cloze && v.example != null) v.example!,
      ].join('\n'),
    );
  }
}

class _Summary extends ConsumerWidget {
  const _Summary({required this.state, required this.mode});

  final PracticeState state;
  final PracticeMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = state.questions.length;
    final ratio = total == 0 ? 0.0 : state.correct / total;
    return ListView(
      padding: AppInsets.screen,
      children: [
        Center(
          child: ScoreRing(
            value: ratio,
            semanticLabel: 'Đúng ${state.correct} trên $total',
            child: Text('${state.correct}/$total', style: context.textStyles.headlineSmall),
          ),
        ),
        Gaps.v16,
        Text(
          ratio >= 0.8
              ? 'Rất tốt!'
              : ratio >= 0.5
              ? 'Khá ổn, ôn lại vài từ nữa nhé'
              : 'Cần ôn thêm',
          textAlign: TextAlign.center,
          style: context.textStyles.titleLarge,
        ),
        if (state.wrong.isNotEmpty) ...[
          Gaps.v24,
          SectionHeader(
            title: 'Từ trả lời sai',
            subtitle: 'Đã đưa vào lịch ôn sớm (với từ đã học)',
          ),
          AppListGroup(
            children: [
              for (final q in state.wrong)
                ListTile(
                  title: Text(q.item.word),
                  subtitle: Text(q.item.meaning),
                  trailing: IconButton(
                    tooltip: 'Nghe phát âm',
                    icon: const Icon(Icons.volume_up_outlined),
                    onPressed: () => ref.read(ttsServiceProvider).speak(q.item.word),
                  ),
                ),
            ],
          ),
          Gaps.v16,
          FilledButton.tonal(
            onPressed: () => context.pushReplacement(
              Routes.vocabPractice(mode.name, retry: state.wrong.map((q) => q.item.id).join(',')),
            ),
            child: const Text('Luyện lại các từ sai'),
          ),
        ],
        Gaps.v8,
        OutlinedButton(
          onPressed: () {
            ref.invalidate(vocabListProvider);
            Navigator.of(context).maybePop();
          },
          child: const Text('Xong'),
        ),
      ],
    );
  }
}
