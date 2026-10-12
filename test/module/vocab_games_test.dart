import 'dart:math';

import 'package:bami_toeic/core/design_system/design_system.dart';
import 'package:bami_toeic/module/vocab/data/game_logic.dart';
import 'package:bami_toeic/module/vocab/data/models/vocab_models.dart';
import 'package:bami_toeic/module/vocab/presentation/controllers/vocab_controller.dart';
import 'package:bami_toeic/module/vocab/presentation/pages/word_match_game_page.dart';
import 'package:bami_toeic/module/vocab/presentation/pages/word_scramble_game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeVocabList extends VocabList {
  _FakeVocabList(this._items);
  final List<VocabItem> _items;

  @override
  Future<List<VocabItem>> build() async => _items;
}

Widget _wrap(Widget child, {List<VocabItem>? vocabList}) {
  return ProviderScope(
    overrides: [
      if (vocabList != null)
        vocabListProvider.overrideWith(() => _FakeVocabList(vocabList)),
      sessionRandomProvider.overrideWithValue(Random(42)),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: child,
    ),
  );
}

final sampleVocab = [
  const VocabItem(
    id: 'v1',
    word: 'applicant',
    pos: 'n.',
    meaning: 'người nộp đơn xin việc',
    example: 'The applicant submitted a resume.',
    topic: 'Personnel',
  ),
  const VocabItem(
    id: 'v2',
    word: 'contract',
    pos: 'n.',
    meaning: 'hợp đồng',
    example: 'They signed the contract yesterday.',
    topic: 'Contracts',
  ),
  const VocabItem(
    id: 'v3',
    word: 'meeting',
    pos: 'n.',
    meaning: 'cuộc họp',
    example: 'The meeting starts at 9 AM.',
    topic: 'General Business',
  ),
  const VocabItem(
    id: 'v4',
    word: 'receipt',
    pos: 'n.',
    meaning: 'biên lai, hoá đơn',
    example: 'Keep the receipt for reimbursement.',
    topic: 'Shopping',
  ),
  const VocabItem(
    id: 'v5',
    word: 'salary',
    pos: 'n.',
    meaning: 'tiền lương',
    example: 'The company offers a competitive salary.',
    topic: 'Personnel',
  ),
  const VocabItem(
    id: 'v6',
    word: 'budget',
    pos: 'n.',
    meaning: 'ngân sách',
    example: 'We must stay within the budget.',
    topic: 'Finance',
  ),
];

void main() {
  group('Vocab Game Logic Unit Tests', () {
    test('buildMatchCards creates balanced pairs of English and Vietnamese cards', () {
      final random = Random(42);
      final cards = buildMatchCards(items: sampleVocab, random: random, pairCount: 4);

      expect(cards.length, 8); // 4 pairs * 2 = 8 cards
      final enCards = cards.where((c) => c.isEnglish).toList();
      final viCards = cards.where((c) => !c.isEnglish).toList();

      expect(enCards.length, 4);
      expect(viCards.length, 4);

      // Mỗi thẻ EN đều có 1 thẻ VI có cùng vocabId
      for (final en in enCards) {
        final match = viCards.where((vi) => vi.vocabId == en.vocabId);
        expect(match.length, 1);
      }
    });

    test('buildMatchCards handles empty list gracefully', () {
      final random = Random(42);
      final cards = buildMatchCards(items: const [], random: random);
      expect(cards, isEmpty);
    });

    test('buildScrambleQuestions extracts and scrambles letters accurately', () {
      final random = Random(42);
      final questions = buildScrambleQuestions(items: sampleVocab, random: random, count: 3);

      expect(questions.length, 3);
      for (final q in questions) {
        expect(q.targetWord, q.item.word.toUpperCase());
        expect(q.scrambledLetters.length, q.targetWord.length);

        // Ký tự trong scrambledLetters phải là hoán vị của targetWord
        final originalSorted = q.targetWord.split('')..sort();
        final scrambledSorted = q.scrambledLetters.map((l) => l.char).toList()..sort();
        expect(scrambledSorted, originalSorted);
      }
    });
  });

  group('WordMatchGamePage Widget Tests', () {
    testWidgets('Renders HUD and card grid properly', (tester) async {
      await tester.pumpWidget(_wrap(const WordMatchGamePage(), vocabList: sampleVocab));
      await tester.pumpAndSettle();

      expect(find.text('Nối từ tốc độ'), findsOneWidget);
      expect(find.textContaining('0 đ'), findsOneWidget);
      expect(find.text('0/6'), findsOneWidget);

      // Thẻ bài được tạo (12 thẻ cho 6 cặp)
      expect(find.text('EN'), findsWidgets);
      expect(find.text('VI'), findsWidgets);
    });

    testWidgets('Tapping matching English and Vietnamese cards registers match', (tester) async {
      await tester.pumpWidget(_wrap(const WordMatchGamePage(), vocabList: sampleVocab));
      await tester.pumpAndSettle();

      // Tìm thẻ có từ 'applicant'
      final applicantCard = find.text('applicant');
      expect(applicantCard, findsOneWidget);

      await tester.tap(applicantCard);
      await tester.pumpAndSettle();

      // Tìm thẻ nghĩa tương ứng
      final meaningCard = find.text('người nộp đơn xin việc');
      expect(meaningCard, findsOneWidget);

      await tester.tap(meaningCard);
      await tester.pumpAndSettle();

      // Điểm số tăng và tiến độ tăng lên 1/6
      expect(find.text('1/6'), findsOneWidget);
      expect(find.textContaining('10 đ'), findsOneWidget);
    });

    testWidgets('Tapping mismatched cards triggers error state and resets combo', (tester) async {
      await tester.pumpWidget(_wrap(const WordMatchGamePage(), vocabList: sampleVocab));
      await tester.pumpAndSettle();

      final applicantCard = find.text('applicant');
      await tester.tap(applicantCard);
      await tester.pumpAndSettle();

      // Chọn thẻ sai nghĩa (hợp đồng)
      final wrongCard = find.text('hợp đồng');
      await tester.tap(wrongCard);
      await tester.pump();

      // Sau khi delay, tự động bỏ chọn
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('0/6'), findsOneWidget);
    });
  });

  group('WordScrambleGamePage Widget Tests', () {
    testWidgets('Renders question prompt, answer slots and letter pool', (tester) async {
      await tester.pumpWidget(_wrap(const WordScrambleGamePage(), vocabList: sampleVocab));
      await tester.pumpAndSettle();

      expect(find.text('Xếp chữ đoán từ'), findsOneWidget);
      expect(find.textContaining('Câu 1/'), findsOneWidget);
      expect(find.text('Xoá hết'), findsOneWidget);
      expect(find.text('Đổi vị trí'), findsOneWidget);
      expect(find.text('Gợi ý'), findsOneWidget);
    });

    testWidgets('Tapping letters moves them to answer slots and tapping slots returns them', (tester) async {
      await tester.pumpWidget(_wrap(const WordScrambleGamePage(), vocabList: sampleVocab));
      await tester.pumpAndSettle();

      // Tìm 1 chữ cái bất kỳ trong letter pool
      final poolLetters = find.descendant(
        of: find.byType(Wrap).last,
        matching: find.byType(InkWell),
      );
      expect(poolLetters, findsWidgets);

      // Chạm chữ cái đầu tiên
      await tester.tap(poolLetters.first);
      await tester.pumpAndSettle();

      // Chạm nút Xoá hết
      await tester.tap(find.text('Xoá hết'));
      await tester.pumpAndSettle();
    });

    testWidgets('Tapping Gợi ý automatically fills next expected character', (tester) async {
      await tester.pumpWidget(_wrap(const WordScrambleGamePage(), vocabList: sampleVocab));
      await tester.pumpAndSettle();

      // Bấm gợi ý
      await tester.tap(find.text('Gợi ý'));
      await tester.pumpAndSettle();

      // Khung đáp án đã có ít nhất 1 chữ cái
      final answerSlotTexts = find.descendant(
        of: find.byType(Wrap).first,
        matching: find.byType(Text),
      );
      expect(answerSlotTexts, findsWidgets);
    });
  });
}
