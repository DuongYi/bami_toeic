import 'dart:math';

import 'models/game_models.dart';
import 'models/vocab_models.dart';

/// Tạo danh sách thẻ cho game Ghép cặp (Word Match).
List<MatchCard> buildMatchCards({
  required List<VocabItem> items,
  required Random random,
  int pairCount = 6,
}) {
  if (items.isEmpty) return const [];

  final validItems = items.where((v) => v.word.trim().isNotEmpty && v.meaning.trim().isNotEmpty).toList();
  if (validItems.isEmpty) return const [];

  // Lấy ngẫu nhiên [pairCount] từ
  final shuffledItems = List<VocabItem>.from(validItems)..shuffle(random);
  final chosen = shuffledItems.take(pairCount).toList();

  final cards = <MatchCard>[];
  for (final item in chosen) {
    cards.add(
      MatchCard(
        id: '${item.id}_en',
        vocabId: item.id,
        text: item.word,
        isEnglish: true,
        item: item,
      ),
    );
    // Cắt bớt nếu nghĩa quá dài để vừa vặn với thẻ grid
    final shortMeaning = item.meaning.split(RegExp(r'[;,]')).first.trim();
    cards.add(
      MatchCard(
        id: '${item.id}_vi',
        vocabId: item.id,
        text: shortMeaning.isNotEmpty ? shortMeaning : item.meaning,
        isEnglish: false,
        item: item,
      ),
    );
  }

  return cards..shuffle(random);
}

/// Tạo danh sách câu hỏi cho game Xếp chữ (Word Scramble).
List<ScrambleQuestion> buildScrambleQuestions({
  required List<VocabItem> items,
  required Random random,
  int count = 8,
}) {
  if (items.isEmpty) return const [];

  // Lọc các từ thích hợp để xếp chữ:
  // - Độ dài từ 3 đến 10 chữ cái
  // - Không chứa ký tự đặc biệt lạ (chỉ A-Z)
  final validItems = items.where((v) {
    final clean = v.word.trim();
    if (clean.length < 3 || clean.length > 10) return false;
    return RegExp(r'^[a-zA-Z]+$').hasMatch(clean);
  }).toList();

  if (validItems.isEmpty) {
    // Fallback: chấp nhận cả từ có dấu cách nếu không có từ đơn
    final fallback = items.where((v) => v.word.trim().isNotEmpty).toList();
    if (fallback.isEmpty) return const [];
    validItems.addAll(fallback);
  }

  final shuffledItems = List<VocabItem>.from(validItems)..shuffle(random);
  final chosen = shuffledItems.take(count).toList();

  final questions = <ScrambleQuestion>[];
  for (final item in chosen) {
    final cleanWord = item.word.trim().toUpperCase();
    final letters = cleanWord.split('');

    // Xáo trộn các chữ cái, đảm bảo không trùng 100% với từ gốc (nếu độ dài > 2)
    var scrambled = List<String>.from(letters)..shuffle(random);
    var attempts = 0;
    while (scrambled.join() == cleanWord && attempts < 10) {
      scrambled.shuffle(random);
      attempts++;
    }

    final scrambleLetters = [
      for (final (i, char) in scrambled.indexed)
        ScrambleLetter(id: i, char: char),
    ];

    questions.add(
      ScrambleQuestion(
        item: item,
        targetWord: cleanWord,
        scrambledLetters: scrambleLetters,
      ),
    );
  }

  return questions;
}
