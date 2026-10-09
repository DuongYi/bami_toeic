import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/tts/tts_service.dart';
import '../../../../helper/srs.dart';
import '../../data/models/vocab_models.dart';
import '../../data/vocab_decks.dart';
import '../controllers/flashcard_controller.dart';

class FlashcardPage extends ConsumerWidget {
  const FlashcardPage({super.key, this.deckKey, this.extraNew = 0});

  /// Bộ lấy từ mới (null = bộ đang học).
  final String? deckKey;

  /// > 0: "Học thêm" đúng chừng ấy từ mới.
  final int extraNew;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = flashcardSessionProvider(deckKey, extraNew);

    ref.listen(provider.select((s) => s.value?.saveError), (_, error) {
      if (error == null) return;
      showAppSnackBar(
        context,
        'Không lưu được tiến độ: ${AppException.from(error).message}',
        tone: AppTone.danger,
      );
    });

    final session = ref.watch(provider);
    final s = session.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(extraNew > 0 ? 'Học thêm từ mới' : 'Học từ vựng'),
        actions: [
          if (s != null && s.current != null)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.screen),
              child: Center(
                child: StatusBadge(label: '${s.done}/${s.total}', tone: AppTone.info),
              ),
            ),
        ],
        bottom: s == null || s.current == null
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(AppSizes.progressThin),
                child: LinearProgressIndicator(value: s.total == 0 ? 0 : s.done / s.total),
              ),
      ),
      body: AsyncView(
        value: session,
        loading: (_) => const FlashcardSkeleton(),
        onRetry: () => ref.invalidate(provider),
        data: (s) {
          final card = s.current;
          if (card == null) {
            return AppEmptyView(
              icon: Icons.celebration_outlined,
              message: s.done == 0
                  ? 'Không có thẻ nào lúc này.\nĐã ôn hết và đủ chỉ tiêu từ mới hôm nay.'
                  : 'Hoàn thành! Bạn đã ôn ${s.done} từ.',
              action: FilledButton.tonal(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('Xong'),
              ),
            );
          }
          final notifier = ref.read(provider.notifier);
          return Padding(
            padding: AppInsets.screen,
            child: GestureDetector(
              onTap: notifier.flip,
              child: AnimatedSwitcher(
                duration: AppMotion.of(context, AppMotion.medium),
                child: _CardFace(
                  key: ValueKey('${card.id}-${s.flipped}'),
                  card: card,
                  flipped: s.flipped,
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: s?.current == null
          ? null
          : AppBottomBar(
              child: s!.flipped
                  ? _GradeButtons(
                      current: s.current!.srs ?? const SrsState(),
                      onGrade: ref.read(provider.notifier).grade,
                    )
                  : AppPrimaryButton(
                      icon: Icons.flip_rounded,
                      label: 'Xem nghĩa',
                      onPressed: ref.read(provider.notifier).flip,
                    ),
            ),
    );
  }
}

class _CardFace extends ConsumerWidget {
  const _CardFace({super.key, required this.card, required this.flipped});

  final VocabItem card;
  final bool flipped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tts = ref.read(ttsServiceProvider);
    final muted = context.colors.onSurfaceVariant;

    return Card(
      child: SizedBox.expand(
        child: Stack(
          children: [
            Positioned(
              top: AppSpacing.s16,
              left: AppSpacing.s16,
              child: StatusBadge(
                label: card.isNew ? 'Từ mới · ${topicLabel(card.topic)}' : topicLabel(card.topic),
                tone: card.isNew ? AppTone.info : AppTone.neutral,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s24,
                  vertical: AppSpacing.s48,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      card.word,
                      textAlign: TextAlign.center,
                      style: context.textStyles.displaySmall,
                    ),
                    if (card.ipa != null) ...[
                      Gaps.v4,
                      Text(
                        card.ipa!,
                        style: context.textStyles.titleMedium?.copyWith(color: muted),
                      ),
                    ],
                    Gaps.v8,
                    IconButton.filledTonal(
                      tooltip: 'Nghe phát âm',
                      icon: const Icon(Icons.volume_up_rounded),
                      onPressed: () => tts.speak(card.word),
                    ),
                    Gaps.v32,
                    if (!flipped)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.touch_app_outlined, size: AppSizes.iconSm, color: muted),
                          Gaps.h8,
                          Text('Chạm thẻ để lật', style: TextStyle(color: muted)),
                        ],
                      )
                    else ...[
                      if (card.pos != null) StatusBadge(label: card.pos!, tone: AppTone.info),
                      Gaps.v8,
                      Text(
                        card.meaning,
                        textAlign: TextAlign.center,
                        style: context.textStyles.headlineSmall,
                      ),
                      if (card.example != null) ...[
                        Gaps.v24,
                        Container(
                          width: double.infinity,
                          padding: AppInsets.card,
                          decoration: BoxDecoration(
                            color: context.colors.surfaceContainerHighest.withValues(alpha: 0.5),
                            borderRadius: AppRadius.brMd,
                          ),
                          child: Column(
                            children: [
                              Text(
                                card.example!,
                                textAlign: TextAlign.center,
                                style: context.textStyles.bodyLarge?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              if (card.exampleMeaning != null) ...[
                                Gaps.v4,
                                Text(
                                  card.exampleMeaning!,
                                  textAlign: TextAlign.center,
                                  style: context.textStyles.bodyMedium?.copyWith(color: muted),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 4 nút chấm (Quên/Khó/Nhớ/Dễ) kèm khoảng thời gian sẽ ôn lại.
class _GradeButtons extends StatelessWidget {
  const _GradeButtons({required this.current, required this.onGrade});

  final SrsState current;
  final ValueChanged<ReviewGrade> onGrade;

  static AppTone _tone(ReviewGrade g) => switch (g) {
    ReviewGrade.again => AppTone.danger,
    ReviewGrade.hard => AppTone.warning,
    ReviewGrade.good => AppTone.success,
    ReviewGrade.easy => AppTone.info,
  };

  static String _nextLabel(SrsState next) =>
      next.intervalDays == 0 ? '10 phút' : '${next.intervalDays} ngày';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (i, g) in ReviewGrade.values.indexed) ...[
          if (i > 0) Gaps.h8,
          Expanded(
            child: _GradeButton(
              grade: g,
              tone: _tone(g),
              next: _nextLabel(current.review(g)),
              onTap: () => onGrade(g),
            ),
          ),
        ],
      ],
    );
  }
}

class _GradeButton extends StatelessWidget {
  const _GradeButton({
    required this.grade,
    required this.tone,
    required this.next,
    required this.onTap,
  });

  final ReviewGrade grade;
  final AppTone tone;
  final String next;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = tone.colorsOf(context);
    return Semantics(
      button: true,
      label: '${grade.label}, ôn lại sau $next',
      excludeSemantics: true,
      child: Material(
        color: c.container,
        borderRadius: AppRadius.brMd,
        child: InkWell(
          borderRadius: AppRadius.brMd,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.buttonLarge),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    grade.label,
                    style: context.textStyles.labelLarge?.copyWith(color: c.onContainer),
                  ),
                  Text(next, style: context.textStyles.labelSmall?.copyWith(color: c.onContainer)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
