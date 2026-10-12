import 'vocab_models.dart';

/// Trạng thái của thẻ trong mini-game Ghép cặp (Word Match).
enum MatchCardState {
  idle,
  selected,
  matched,
  error,
}

/// Thẻ bài trong mini-game Ghép cặp.
class MatchCard {
  const MatchCard({
    required this.id,
    required this.vocabId,
    required this.text,
    required this.isEnglish,
    required this.item,
    this.state = MatchCardState.idle,
  });

  final String id;
  final String vocabId;
  final String text;
  final bool isEnglish;
  final VocabItem item;
  final MatchCardState state;

  MatchCard copyWith({MatchCardState? state}) => MatchCard(
        id: id,
        vocabId: vocabId,
        text: text,
        isEnglish: isEnglish,
        item: item,
        state: state ?? this.state,
      );
}

/// Một ký tự trong mini-game Xếp chữ (Word Scramble).
class ScrambleLetter {
  const ScrambleLetter({
    required this.id,
    required this.char,
  });

  final int id;
  final String char;
}

/// Câu hỏi trong mini-game Xếp chữ.
class ScrambleQuestion {
  const ScrambleQuestion({
    required this.item,
    required this.targetWord,
    required this.scrambledLetters,
  });

  final VocabItem item;
  final String targetWord;
  final List<ScrambleLetter> scrambledLetters;
}
