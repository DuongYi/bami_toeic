import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/tts/tts_service.dart';
import '../../data/game_logic.dart';
import '../../data/models/game_models.dart';
import '../../data/models/vocab_models.dart';
import '../../data/practice.dart';
import '../../data/vocab_decks.dart';
import '../controllers/vocab_controller.dart';

/// Mini-game Xếp chữ đoán từ (Word Scramble): Các chữ cái bị xáo trộn, chạm để ghép thành từ hoàn chỉnh.
class WordScrambleGamePage extends ConsumerStatefulWidget {
  const WordScrambleGamePage({super.key, this.deckKey});

  final String? deckKey;

  @override
  ConsumerState<WordScrambleGamePage> createState() => _WordScrambleGamePageState();
}

class _WordScrambleGamePageState extends ConsumerState<WordScrambleGamePage> {
  List<ScrambleQuestion> _questions = [];
  int _currentIndex = 0;
  List<ScrambleLetter> _availableLetters = [];
  List<ScrambleLetter> _selectedLetters = [];
  bool? _isCorrect;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  int _totalCorrect = 0;
  bool _initialized = false;
  List<VocabItem> _allVocab = [];

  static const int _questionCount = 8;

  void _initGame(List<VocabItem> items) {
    _allVocab = items;
    final random = ref.read(sessionRandomProvider);
    final deck = widget.deckKey != null ? VocabDeck.parse(widget.deckKey) : null;
    final filtered = filterWords(items, deck: deck);
    final pool = filtered.length >= _questionCount ? filtered : items;

    final questions = buildScrambleQuestions(items: pool, random: random, count: _questionCount);

    setState(() {
      _questions = questions;
      _currentIndex = 0;
      _score = 0;
      _streak = 0;
      _maxStreak = 0;
      _totalCorrect = 0;
      _initialized = true;
      _loadQuestion(0);
    });
  }

  void _loadQuestion(int index) {
    if (index >= _questions.length) return;
    final q = _questions[index];
    setState(() {
      _currentIndex = index;
      _availableLetters = List.from(q.scrambledLetters);
      _selectedLetters = [];
      _isCorrect = null;
    });

    // Phát âm câu hỏi mới qua TTS
    ref.read(ttsServiceProvider).speak(q.item.word);
  }

  void _selectLetter(ScrambleLetter letter) {
    if (_isCorrect == true) return;

    HapticFeedback.lightImpact();

    setState(() {
      _availableLetters.removeWhere((l) => l.id == letter.id);
      _selectedLetters.add(letter);
      _isCorrect = null;
    });

    // Khi đã xếp đủ số lượng chữ cái của từ
    final currentQ = _questions[_currentIndex];
    if (_selectedLetters.length == currentQ.targetWord.length) {
      _checkAnswer();
    }
  }

  void _unselectLetter(ScrambleLetter letter) {
    if (_isCorrect == true) return;

    HapticFeedback.selectionClick();

    setState(() {
      _selectedLetters.removeWhere((l) => l.id == letter.id);
      _availableLetters.add(letter);
      _isCorrect = null;
    });
  }

  void _checkAnswer() {
    final currentQ = _questions[_currentIndex];
    final typedWord = _selectedLetters.map((l) => l.char).join().toUpperCase();
    final isRight = typedWord == currentQ.targetWord;

    if (isRight) {
      // ĐÚNG
      HapticFeedback.mediumImpact();
      final newStreak = _streak + 1;
      final addedScore = 15 + (newStreak * 5);

      ref.read(ttsServiceProvider).speak(currentQ.item.word);

      setState(() {
        _isCorrect = true;
        _streak = newStreak;
        if (_streak > _maxStreak) _maxStreak = _streak;
        _totalCorrect++;
        _score += addedScore;
      });

      // Tự động chuyển câu tiếp theo sau hiệu ứng
      Future<void>.delayed(AppMotion.long, () {
        if (!mounted) return;
        if (_currentIndex + 1 < _questions.length) {
          _loadQuestion(_currentIndex + 1);
        } else {
          // Hoàn thành toàn bộ câu hỏi
          setState(() => _currentIndex = _questions.length);
        }
      });
    } else {
      // SAI
      HapticFeedback.heavyImpact();
      setState(() {
        _isCorrect = false;
        _streak = 0;
      });
    }
  }

  void _shuffleAvailable() {
    HapticFeedback.selectionClick();
    final random = ref.read(sessionRandomProvider);
    setState(() {
      _availableLetters.shuffle(random);
    });
  }

  void _clearSelected() {
    if (_selectedLetters.isEmpty || _isCorrect == true) return;
    HapticFeedback.lightImpact();
    setState(() {
      _availableLetters.addAll(_selectedLetters);
      _selectedLetters.clear();
      _isCorrect = null;
    });
  }

  void _useHint() {
    if (_isCorrect == true) return;
    final currentQ = _questions[_currentIndex];
    final target = currentQ.targetWord;

    // Tìm index ký tự tiếp theo cần gợi ý
    final nextIndex = _selectedLetters.length;
    if (nextIndex >= target.length) return;

    final expectedChar = target[nextIndex];
    // Tìm ký tự này trong available
    final match = _availableLetters.cast<ScrambleLetter?>().firstWhere(
          (l) => l?.char == expectedChar,
          orElse: () => null,
        );

    if (match != null) {
      HapticFeedback.mediumImpact();
      setState(() {
        _availableLetters.removeWhere((l) => l.id == match.id);
        _selectedLetters.add(match);
      });

      if (_selectedLetters.length == target.length) {
        _checkAnswer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vocabAsync = ref.watch(vocabListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xếp chữ đoán từ'),
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
              icon: Icons.spellcheck_rounded,
              message: 'Cần ít nhất 4 từ vựng trong kho để bắt đầu trò chơi xếp chữ.',
              action: FilledButton.tonal(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('Quay lại'),
              ),
            );
          }

          if (_questions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final isFinished = _currentIndex >= _questions.length;

          return SafeArea(
            child: isFinished
                ? _buildSummaryView(context)
                : _buildPlayView(context),
          );
        },
      ),
    );
  }

  Widget _buildPlayView(BuildContext context) {
    final currentQ = _questions[_currentIndex];
    final warningTone = AppTone.warning.colorsOf(context);
    final clozeText = clozeOf(currentQ.item);

    return Column(
      children: [
        // Thanh tiến độ & Điểm số
        _buildHudHeader(context),
        Expanded(
          child: SingleChildScrollView(
            padding: AppInsets.screen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Thẻ thông tin gợi ý (Nghĩa, Loại từ, Câu ví dụ, Loa)
                AppCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (currentQ.item.pos != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.s8,
                                vertical: AppSpacing.s2,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.primary.withValues(alpha: 0.12),
                                borderRadius: AppRadius.brSm,
                              ),
                              child: Text(
                                currentQ.item.pos!,
                                style: context.textStyles.labelMedium?.copyWith(
                                  color: context.colors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Gaps.h8,
                          ],
                          IconButton.filledTonal(
                            tooltip: 'Nghe phát âm',
                            icon: const Icon(Icons.volume_up_rounded),
                            onPressed: () => ref.read(ttsServiceProvider).speak(currentQ.item.word),
                          ),
                        ],
                      ),
                      Gaps.v12,
                      Text(
                        currentQ.item.meaning,
                        style: context.textStyles.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (clozeText != null) ...[
                        Gaps.v12,
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.s12),
                          decoration: BoxDecoration(
                            color: context.surfaces.raised,
                            borderRadius: AppRadius.brMd,
                          ),
                          child: Text(
                            clozeText,
                            style: context.textStyles.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: context.colors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Gaps.v24,

                // Khung đáp án (Answer Slots)
                _buildAnswerSlots(context, currentQ),
                Gaps.v24,

                // Nút hành động nhanh: Xoá, Xáo trộn, Gợi ý
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.backspace_outlined, size: AppSizes.iconSm),
                      label: const Text('Xoá hết'),
                      onPressed: _selectedLetters.isNotEmpty ? _clearSelected : null,
                    ),
                    Gaps.h12,
                    TextButton.icon(
                      icon: const Icon(Icons.shuffle_rounded, size: AppSizes.iconSm),
                      label: const Text('Đổi vị trí'),
                      onPressed: _availableLetters.length > 1 ? _shuffleAvailable : null,
                    ),
                    Gaps.h12,
                    TextButton.icon(
                      icon: Icon(Icons.lightbulb_outline_rounded, size: AppSizes.iconSm, color: warningTone.main),
                      label: Text('Gợi ý', style: TextStyle(color: warningTone.main)),
                      onPressed: _availableLetters.isNotEmpty ? _useHint : null,
                    ),
                  ],
                ),
                Gaps.v16,

                // Ngân hàng chữ cái (Letter Pool)
                _buildLetterPool(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHudHeader(BuildContext context) {
    final warningTone = AppTone.warning.colorsOf(context);

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _questions.length,
          minHeight: AppSizes.progressThin,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screen,
            vertical: AppSpacing.s8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Câu ${_currentIndex + 1}/${_questions.length}',
                style: context.textStyles.labelLarge?.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  if (_streak > 1) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s8,
                        vertical: AppSpacing.s2,
                      ),
                      decoration: BoxDecoration(
                        color: warningTone.container,
                        borderRadius: AppRadius.brSm,
                      ),
                      child: Text(
                        'Streak x$_streak 🔥',
                        style: context.textStyles.labelSmall?.copyWith(
                          color: warningTone.onContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Gaps.h8,
                  ],
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerSlots(BuildContext context, ScrambleQuestion currentQ) {
    final targetLen = currentQ.targetWord.length;
    final successTone = AppTone.success.colorsOf(context);
    final dangerTone = AppTone.danger.colorsOf(context);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: [
        for (var i = 0; i < targetLen; i++)
          () {
            final hasLetter = i < _selectedLetters.length;
            final letter = hasLetter ? _selectedLetters[i] : null;

            Color bgColor = context.surfaces.raised;
            Color borderColor = context.colors.outlineVariant;
            Color textColor = context.colors.onSurface;

            if (_isCorrect == true) {
              bgColor = successTone.container;
              borderColor = successTone.main;
              textColor = successTone.onContainer;
            } else if (_isCorrect == false) {
              bgColor = dangerTone.container;
              borderColor = dangerTone.main;
              textColor = dangerTone.onContainer;
            } else if (hasLetter) {
              bgColor = context.colors.primaryContainer;
              borderColor = context.colors.primary;
              textColor = context.colors.onPrimaryContainer;
            }

            return Material(
              color: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.brMd,
                side: BorderSide(color: borderColor, width: hasLetter ? 2 : 1),
              ),
              child: InkWell(
                borderRadius: AppRadius.brMd,
                onTap: letter != null ? () => _unselectLetter(letter) : null,
                child: SizedBox(
                  width: AppSizes.touchTarget,
                  height: AppSizes.touchTarget,
                  child: Center(
                    child: Text(
                      letter?.char ?? '',
                      style: context.textStyles.titleLarge?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }(),
      ],
    );
  }

  Widget _buildLetterPool(BuildContext context) {
    if (_availableLetters.isEmpty) {
      return const SizedBox(height: AppSizes.touchTarget);
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.s12,
      runSpacing: AppSpacing.s12,
      children: [
        for (final letter in _availableLetters)
          Material(
            color: context.colors.surface,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.brMd,
              side: BorderSide(color: context.colors.outlineVariant, width: 1.5),
            ),
            child: InkWell(
              borderRadius: AppRadius.brMd,
              onTap: () => _selectLetter(letter),
              child: SizedBox(
                width: AppSizes.touchTarget,
                height: AppSizes.touchTarget,
                child: Center(
                  child: Text(
                    letter.char,
                    style: context.textStyles.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSummaryView(BuildContext context) {
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
                Icons.military_tech_rounded,
                size: AppSizes.iconHero,
                color: warningTone.main,
              ),
            ),
            Gaps.v24,
            Text(
              'Hoàn thành thử thách!',
              style: context.textStyles.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.v8,
            Text(
              'Bạn đã giải thành công $_totalCorrect/${_questions.length} từ vựng.',
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
                      value: '$_score',
                      label: 'Tổng điểm',
                      highlight: true,
                    ),
                    StatTile(
                      value: '$_totalCorrect/${_questions.length}',
                      label: 'Chính xác',
                    ),
                    StatTile(
                      value: 'x$_maxStreak',
                      label: 'Streak dài nhất',
                    ),
                  ],
                ),
              ),
            ),
            Gaps.v24,
            // Danh sách các từ vừa học
            SectionHeader(
              title: 'Các từ trong ván',
              subtitle: 'Chạm biểu tượng loa để nghe lại phát âm',
            ),
            AppListGroup(
              children: [
                for (final q in _questions)
                  ListTile(
                    title: Text(q.item.word, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(q.item.meaning),
                    trailing: IconButton(
                      icon: const Icon(Icons.volume_up_rounded),
                      onPressed: () => ref.read(ttsServiceProvider).speak(q.item.word),
                    ),
                  ),
              ],
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
