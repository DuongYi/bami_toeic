import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../config/theme.dart';
import '../../../core/widgets/async_view.dart';
import '../../../helper/srs.dart';
import '../vocab_repository.dart';

/// Số từ mới tối đa mỗi phiên.
const newPerSession = 20;

/// Phiên học = các từ đến hạn + tối đa [newPerSession] từ mới, xáo trộn.
List<VocabItem> buildSession(List<VocabItem> items, DateTime now) {
  final due = items.where((v) => v.isDue(now)).toList();
  final fresh = items.where((v) => v.isNew).take(newPerSession).toList();
  return [...due, ...fresh]..shuffle(Random());
}

class FlashcardPage extends ConsumerWidget {
  const FlashcardPage({super.key, this.topic});

  final String? topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocab = ref.watch(vocabListProvider);
    return Scaffold(
      appBar: AppBar(title: Text(topic ?? 'Flashcard')),
      body: AsyncView(
        value: vocab,
        data: (all) {
          final items = topic == null ? all : all.where((v) => v.topic == topic).toList();
          return _Session(cards: buildSession(items, DateTime.now()));
        },
      ),
    );
  }
}

class _Session extends ConsumerStatefulWidget {
  const _Session({required this.cards});

  final List<VocabItem> cards;

  @override
  ConsumerState<_Session> createState() => _SessionState();
}

class _SessionState extends ConsumerState<_Session> {
  late final List<VocabItem> _queue = [...widget.cards];
  final _player = AudioPlayer();
  int _done = 0;
  bool _flipped = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _grade(ReviewGrade grade) async {
    final card = _queue.first;
    final next = (card.review ?? const SrsState()).review(grade);
    setState(() {
      _queue.removeAt(0);
      if (grade == ReviewGrade.again) {
        _queue.add(card); // học lại cuối phiên
      } else {
        _done++;
      }
      _flipped = false;
    });
    try {
      await ref.read(vocabRepositoryProvider).saveReview(card.id, next);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Không lưu được tiến độ: $e')));
      }
    }
  }

  Future<void> _play(String url) async {
    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_queue.isEmpty) {
      return EmptyView(
        icon: Icons.celebration_outlined,
        message: _done == 0 ? 'Không có từ nào cần ôn.' : 'Hoàn thành! Đã ôn $_done từ.',
      );
    }
    final card = _queue.first;
    final total = _done + _queue.length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(value: total == 0 ? 0 : _done / total),
            const SizedBox(height: 8),
            Text('$_done / $total', style: theme.textTheme.labelMedium),
            const SizedBox(height: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _flipped = !_flipped),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Card(
                    key: ValueKey('${card.id}-$_flipped'),
                    child: SizedBox.expand(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),
                              Text(
                                card.word,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (card.ipa != null)
                                Text(card.ipa!, style: theme.textTheme.titleMedium),
                              if (card.audioUrl != null)
                                IconButton(
                                  icon: const Icon(Icons.volume_up),
                                  onPressed: () => _play(card.audioUrl!),
                                ),
                              const SizedBox(height: 24),
                              if (!_flipped)
                                Text(
                                  'Chạm để xem nghĩa',
                                  style: TextStyle(color: theme.colorScheme.outline),
                                )
                              else ...[
                                if (card.pos != null)
                                  Text('(${card.pos})', style: theme.textTheme.labelLarge),
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
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontStyle: FontStyle.italic,
                                    ),
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
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (!_flipped)
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                onPressed: () => setState(() => _flipped = true),
                child: const Text('Xem nghĩa'),
              )
            else
              Row(
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
                              ReviewGrade.easy => theme.colorScheme.primary,
                            },
                          ),
                          onPressed: () => _grade(g),
                          child: Text(g.label),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
