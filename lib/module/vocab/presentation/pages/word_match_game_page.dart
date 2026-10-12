import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/tts/tts_service.dart';
import '../../../../helper/format.dart';
import '../../data/game_logic.dart';
import '../../data/models/game_models.dart';
import '../../data/models/vocab_models.dart';
import '../../data/vocab_decks.dart';
import '../controllers/vocab_controller.dart';

/// Mini-game Ghép cặp từ vựng: Nối thẻ tiếng Anh với nghĩa tiếng Việt tương ứng.
class WordMatchGamePage extends ConsumerStatefulWidget {
  const WordMatchGamePage({super.key, this.deckKey});

  final String? deckKey;

  @override
  ConsumerState<WordMatchGamePage> createState() => _WordMatchGamePageState();
}

class _WordMatchGamePageState extends ConsumerState<WordMatchGamePage> {
  List<MatchCard> _cards = [];
  MatchCard? _firstSelected;
  bool _isProcessing = false;
  int _matchedPairs = 0;
  int _score = 0;
  int _combo = 0;
  int _maxCombo = 0;
  int _elapsedSeconds = 0;
  Timer? _timer;
  bool _initialized = false;
  List<VocabItem> _allVocab = [];

  static const int _targetPairs = 6;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _elapsedSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _elapsedSeconds++);
      }
    });
  }

  void _initGame(List<VocabItem> items) {
    _allVocab = items;
    final random = ref.read(sessionRandomProvider);
    final deck = widget.deckKey != null ? VocabDeck.parse(widget.deckKey) : null;
    final filtered = filterWords(items, deck: deck);
    final pool = filtered.length >= _targetPairs ? filtered : items;

    setState(() {
      _cards = buildMatchCards(items: pool, random: random, pairCount: _targetPairs);
      _firstSelected = null;
      _isProcessing = false;
      _matchedPairs = 0;
      _score = 0;
      _combo = 0;
      _maxCombo = 0;
      _initialized = true;
    });
    _startTimer();
  }

  void _onCardTap(MatchCard card) {
    if (_isProcessing || card.state == MatchCardState.matched || card.state == MatchCardState.selected) {
      return;
    }

    HapticFeedback.lightImpact();

    // Chưa chọn thẻ đầu tiên
    if (_firstSelected == null) {
      setState(() {
        _firstSelected = card;
        _cards = [
          for (final c in _cards)
            if (c.id == card.id) c.copyWith(state: MatchCardState.selected) else c,
        ];
      });
      return;
    }

    final first = _firstSelected!;

    // Chạm cùng 1 loại thẻ (cùng tiếng Anh hoặc cùng tiếng Việt) → chuyển sang chọn thẻ mới
    if (first.isEnglish == card.isEnglish) {
      setState(() {
        _firstSelected = card;
        _cards = [
          for (final c in _cards)
            if (c.id == card.id)
              c.copyWith(state: MatchCardState.selected)
            else if (c.id == first.id)
              c.copyWith(state: MatchCardState.idle)
            else
              c,
        ];
      });
      return;
    }

    // Chọn 2 thẻ khác loại (1 Anh, 1 Việt) → Kiểm tra cặp
    final isMatch = first.vocabId == card.vocabId;

    if (isMatch) {
      // GHÉP ĐÚNG
      HapticFeedback.mediumImpact();
      final newCombo = _combo + 1;
      final addedScore = 10 * newCombo;

      // Phát âm từ tiếng Anh
      final enWord = first.isEnglish ? first.text : card.text;
      ref.read(ttsServiceProvider).speak(enWord);

      setState(() {
        _combo = newCombo;
        if (_combo > _maxCombo) _maxCombo = _combo;
        _score += addedScore;
        _matchedPairs++;
        _firstSelected = null;
        _cards = [
          for (final c in _cards)
            if (c.id == first.id || c.id == card.id)
              c.copyWith(state: MatchCardState.matched)
            else
              c,
        ];
      });

      // Kiểm tra hoàn thành ván
      if (_matchedPairs >= _cards.length ~/ 2) {
        _timer?.cancel();
        HapticFeedback.heavyImpact();
      }
    } else {
      // GHÉP SAI
      HapticFeedback.heavyImpact();
      setState(() {
        _combo = 0;
        _isProcessing = true;
        _cards = [
          for (final c in _cards)
            if (c.id == first.id || c.id == card.id)
              c.copyWith(state: MatchCardState.error)
            else
              c,
        ];
      });

      Future<void>.delayed(AppMotion.medium, () {
        if (!mounted) return;
        setState(() {
          _firstSelected = null;
          _isProcessing = false;
          _cards = [
            for (final c in _cards)
              if (c.id == first.id || c.id == card.id)
                c.copyWith(state: MatchCardState.idle)
              else
                c,
          ];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vocabAsync = ref.watch(vocabListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nối từ tốc độ'),
        actions: [
          IconButton(
            tooltip: 'Chơi ván mới',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _allVocab.isNotEmpty ? () => _initGame(_allVocab) : null,
          ),
        ],
      ),
      body: AsyncView(
        value: vocabAsync,
        onRetry: () => ref.invalidate(vocabListProvider),
        data: (items) {
          if (!_initialized && items.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _initGame(items));
          }

          if (items.length < 4) {
            return AppEmptyView(
              icon: Icons.dashboard_customize_outlined,
              message: 'Cần ít nhất 4 từ vựng trong kho để bắt đầu mini-game nối từ.',
              action: FilledButton.tonal(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('Quay lại'),
              ),
            );
          }

          final isFinished = _matchedPairs > 0 && _matchedPairs == _cards.length ~/ 2;

          return SafeArea(
            child: isFinished
                ? _buildVictoryView(context)
                : _buildGameView(context),
          );
        },
      ),
    );
  }

  Widget _buildGameView(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    final isTabletLandscape = media.width > media.height && media.width >= 700;
    final crossAxisCount = isTabletLandscape ? 4 : 2;

    return Column(
      children: [
        // HUD Header: Thời gian, Điểm số, Combo, Cặp
        _buildHudHeader(context),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppSpacing.s12,
                mainAxisSpacing: AppSpacing.s12,
                childAspectRatio: isTabletLandscape ? 2.2 : 1.7,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return _MatchCardTile(
                  card: card,
                  onTap: () => _onCardTap(card),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHudHeader(BuildContext context) {
    final warningTone = AppTone.warning.colorsOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
        vertical: AppSpacing.s12,
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.s8),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(
          bottom: BorderSide(
            color: context.colors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Thời gian
          Row(
            children: [
              Icon(Icons.timer_outlined, size: AppSizes.iconSm, color: context.colors.primary),
              Gaps.h4,
              Text(
                Fmt.clock(Duration(seconds: _elapsedSeconds)),
                style: context.textStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          // Điểm
          Row(
            children: [
              Icon(Icons.stars_rounded, size: AppSizes.iconSm, color: warningTone.main),
              Gaps.h4,
              Text(
                '$_score đ',
                style: context.textStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Combo
          if (_combo > 1)
            AnimatedContainer(
              duration: AppMotion.short,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s8,
                vertical: AppSpacing.s2,
              ),
              decoration: BoxDecoration(
                color: warningTone.container,
                borderRadius: AppRadius.brSm,
              ),
              child: Text(
                'Combo x$_combo 🔥',
                style: context.textStyles.labelSmall?.copyWith(
                  color: warningTone.onContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          // Tiến độ
          Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, size: AppSizes.iconSm, color: context.colors.outline),
              Gaps.h4,
              Text(
                '$_matchedPairs/${_cards.length ~/ 2}',
                style: context.textStyles.labelLarge?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVictoryView(BuildContext context) {
    final warningTone = AppTone.warning.colorsOf(context);

    return Center(
      child: SingleChildScrollView(
        padding: AppInsets.screen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppSizes.brandMark,
              height: AppSizes.brandMark,
              decoration: BoxDecoration(
                color: warningTone.container,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_events_rounded,
                size: AppSizes.iconHero,
                color: warningTone.main,
              ),
            ),
            Gaps.v24,
            Text(
              'Xuất sắc hoàn thành!',
              style: context.textStyles.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.v8,
            Text(
              'Bạn đã ghép nối chuẩn xác tất cả các cặp từ vựng.',
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            Gaps.v24,
            AppCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
                child: Row(
                  children: [
                    StatTile(
                      value: Fmt.clock(Duration(seconds: _elapsedSeconds)),
                      label: 'Thời gian',
                      highlight: true,
                    ),
                    StatTile(
                      value: '$_score',
                      label: 'Tổng điểm',
                    ),
                    StatTile(
                      value: 'x$_maxCombo',
                      label: 'Combo cao nhất',
                    ),
                  ],
                ),
              ),
            ),
            Gaps.v32,
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonLarge,
              child: FilledButton.icon(
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Chơi ván mới'),
                onPressed: () => _initGame(_allVocab),
              ),
            ),
            Gaps.v12,
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('Quay lại danh sách từ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchCardTile extends StatelessWidget {
  const _MatchCardTile({
    required this.card,
    required this.onTap,
  });

  final MatchCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surfaces = context.surfaces;
    final successTone = AppTone.success.colorsOf(context);
    final dangerTone = AppTone.danger.colorsOf(context);

    // Xác định màu nền, viền và chữ theo trạng thái
    final (bgColor, borderColor, textColor, borderWidth) = switch (card.state) {
      MatchCardState.idle => (
          surfaces.raised,
          colors.outlineVariant,
          colors.onSurface,
          1.0,
        ),
      MatchCardState.selected => (
          colors.primaryContainer,
          colors.primary,
          colors.onPrimaryContainer,
          2.0,
        ),
      MatchCardState.matched => (
          successTone.container.withValues(alpha: 0.6),
          successTone.main.withValues(alpha: 0.7),
          successTone.onContainer,
          1.5,
        ),
      MatchCardState.error => (
          dangerTone.container,
          dangerTone.main,
          dangerTone.onContainer,
          2.0,
        ),
    };

    final isMatched = card.state == MatchCardState.matched;

    return AnimatedOpacity(
      duration: AppMotion.short,
      opacity: isMatched ? 0.65 : 1.0,
      child: Material(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brLg,
          side: BorderSide(color: borderColor, width: borderWidth),
        ),
        child: InkWell(
          borderRadius: AppRadius.brLg,
          onTap: isMatched ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s4,
                      vertical: AppSpacing.s2,
                    ),
                    decoration: BoxDecoration(
                      color: card.isEnglish
                          ? colors.primary.withValues(alpha: 0.12)
                          : colors.outlineVariant.withValues(alpha: 0.5),
                      borderRadius: AppRadius.brXs,
                    ),
                    child: Text(
                      card.isEnglish ? 'EN' : 'VI',
                      style: context.textStyles.labelSmall?.copyWith(
                        color: card.isEnglish ? colors.primary : colors.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      card.text,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: (card.isEnglish
                              ? context.textStyles.titleMedium
                              : context.textStyles.bodyMedium)
                          ?.copyWith(
                        color: textColor,
                        fontWeight: card.isEnglish ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
