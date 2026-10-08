import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../helper/srs.dart';
import '../../data/models/vocab_models.dart';
import '../controllers/flashcard_controller.dart';

class FlashcardPage extends ConsumerWidget {
  const FlashcardPage({super.key, this.topic});

  final String? topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = flashcardSessionProvider(topic);

    ref.listen(provider.select((s) => s.value?.saveError), (_, error) {
      if (error == null) return;
      showAppSnackBar(
        context,
        'Không lưu được tiến độ: ${AppException.from(error).message}',
        tone: AppTone.danger,
      );
    });

    final session = ref.watch(provider);
    return Scaffold(
      appBar: AppBar(title: Text(topic ?? 'Flashcard')),
      body: AsyncView(
        value: session,
        onRetry: () => ref.invalidate(provider),
        data: (s) {
          final card = s.current;
          if (card == null) {
            return AppEmptyView(
              icon: Icons.celebration_outlined,
              message: s.done == 0 ? 'Không có từ nào cần ôn.' : 'Hoàn thành! Đã ôn ${s.done} từ.',
            );
          }
          final notifier = ref.read(provider.notifier);
          return SafeArea(
            child: Padding(
              padding: AppInsets.screen,
              child: Column(
                children: [
                  LinearProgressIndicator(value: s.total == 0 ? 0 : s.done / s.total),
                  Gaps.v8,
                  Text('${s.done} / ${s.total}', style: context.textStyles.labelMedium),
                  Gaps.v16,
                  Expanded(
                    child: GestureDetector(
                      onTap: notifier.flip,
                      child: AnimatedSwitcher(
                        duration: AppMotion.of(context, AppMotion.short),
                        child: _CardFace(
                          key: ValueKey('${card.id}-${s.flipped}'),
                          card: card,
                          flipped: s.flipped,
                        ),
                      ),
                    ),
                  ),
                  Gaps.v16,
                  if (!s.flipped)
                    AppPrimaryButton(label: 'Xem nghĩa', onPressed: notifier.flip)
                  else
                    _GradeButtons(onGrade: notifier.grade),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CardFace extends StatefulWidget {
  const _CardFace({super.key, required this.card, required this.flipped});

  final VocabItem card;
  final bool flipped;

  @override
  State<_CardFace> createState() => _CardFaceState();
}

class _CardFaceState extends State<_CardFace> {
  AudioPlayer? _player;

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  Future<void> _play(String url) async {
    try {
      final player = _player ??= AudioPlayer();
      await player.setUrl(url);
      await player.play();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    return Card(
      child: SizedBox.expand(
        child: SingleChildScrollView(
          padding: AppInsets.cardLarge,
          child: Column(
            children: [
              Gaps.v32,
              Text(card.word, textAlign: TextAlign.center, style: context.textStyles.displaySmall),
              if (card.ipa != null) Text(card.ipa!, style: context.textStyles.titleMedium),
              if (card.audioUrl != null)
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () => _play(card.audioUrl!),
                ),
              Gaps.v24,
              if (!widget.flipped)
                Text('Chạm để xem nghĩa', style: TextStyle(color: context.colors.onSurfaceVariant))
              else ...[
                if (card.pos != null) Text('(${card.pos})', style: context.textStyles.labelLarge),
                Text(
                  card.meaning,
                  textAlign: TextAlign.center,
                  style: context.textStyles.headlineSmall,
                ),
                if (card.example != null) ...[
                  Gaps.v24,
                  Text(
                    card.example!,
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
                if (card.exampleMeaning != null)
                  Text(
                    card.exampleMeaning!,
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GradeButtons extends StatelessWidget {
  const _GradeButtons({required this.onGrade});

  final ValueChanged<ReviewGrade> onGrade;

  static AppTone _tone(ReviewGrade g) => switch (g) {
    ReviewGrade.again => AppTone.danger,
    ReviewGrade.hard => AppTone.warning,
    ReviewGrade.good => AppTone.success,
    ReviewGrade.easy => AppTone.info,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final g in ReviewGrade.values)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(AppSizes.buttonLarge),
                  padding: EdgeInsets.zero,
                  backgroundColor: _tone(g).colorsOf(context).main,
                  foregroundColor: _tone(g).colorsOf(context).onMain,
                ),
                onPressed: () => onGrade(g),
                child: Text(g.label),
              ),
            ),
          ),
      ],
    );
  }
}
