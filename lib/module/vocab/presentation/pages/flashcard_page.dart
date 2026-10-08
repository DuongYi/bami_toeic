import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../config/theme.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/widgets/async_view.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không lưu được tiến độ: ${AppException.from(error).message}')),
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
            return EmptyView(
              icon: Icons.celebration_outlined,
              message: s.done == 0 ? 'Không có từ nào cần ôn.' : 'Hoàn thành! Đã ôn ${s.done} từ.',
            );
          }
          final notifier = ref.read(provider.notifier);
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LinearProgressIndicator(value: s.total == 0 ? 0 : s.done / s.total),
                  const SizedBox(height: 8),
                  Text('${s.done} / ${s.total}', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: notifier.flip,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _CardFace(
                          key: ValueKey('${card.id}-${s.flipped}'),
                          card: card,
                          flipped: s.flipped,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!s.flipped)
                    FilledButton(
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                      onPressed: notifier.flip,
                      child: const Text('Xem nghĩa'),
                    )
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
    final theme = Theme.of(context);
    final card = widget.card;
    return Card(
      child: SizedBox.expand(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                card.word,
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (card.ipa != null) Text(card.ipa!, style: theme.textTheme.titleMedium),
              if (card.audioUrl != null)
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () => _play(card.audioUrl!),
                ),
              const SizedBox(height: 24),
              if (!widget.flipped)
                Text('Chạm để xem nghĩa', style: TextStyle(color: theme.colorScheme.outline))
              else ...[
                if (card.pos != null) Text('(${card.pos})', style: theme.textTheme.labelLarge),
                Text(
                  card.meaning,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                if (card.example != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    card.example!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
                if (card.exampleMeaning != null)
                  Text(
                    card.exampleMeaning!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final g in ReviewGrade.values)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  padding: EdgeInsets.zero,
                  backgroundColor: switch (g) {
                    ReviewGrade.again => AppTheme.wrong,
                    ReviewGrade.hard => Colors.orange,
                    ReviewGrade.good => AppTheme.correct,
                    ReviewGrade.easy => Theme.of(context).colorScheme.primary,
                  },
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
