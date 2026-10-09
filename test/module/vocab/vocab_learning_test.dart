import 'dart:math';

import 'package:bami_toeic/module/vocab/data/models/vocab_models.dart';
import 'package:bami_toeic/module/vocab/data/practice.dart';
import 'package:bami_toeic/module/vocab/data/vocab_decks.dart';
import 'package:bami_toeic/module/vocab/presentation/controllers/vocab_controller.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 10, 9, 20);

VocabItem _w(
  String id, {
  String word = 'word',
  String topic = 'Office',
  String? source,
  String? example,
  String pos = 'n',
  VocabReview? review,
}) => VocabItem(
  id: id,
  word: word,
  meaning: 'nghĩa $id',
  topic: topic,
  pos: pos,
  source: source,
  example: example,
  reviews: review == null ? const [] : [review],
);

VocabReview _r({
  int interval = 1,
  Duration dueIn = const Duration(days: 1),
  bool known = false,
  DateTime? learnedAt,
}) => VocabReview(
  ease: 2.5,
  intervalDays: interval,
  repetitions: 1,
  dueAt: _now.add(dueIn),
  known: known,
  learnedAt: learnedAt,
);

void main() {
  group('VocabItem', () {
    test('đọc Test N / câu N từ nguồn', () {
      final v = _w('a', source: 'ETS 2026 Test 3 · câu 147-150');
      expect(v.sourceTest, 3);
      expect(v.sourceQuestion, 147);
      expect(_w('b').sourceTest, isNull);
    });

    test('trạng thái mới / đang học / đã thuộc / đã biết', () {
      expect(_w('a').isNew, isTrue);
      expect(_w('b', review: _r()).isLearning, isTrue);
      expect(_w('c', review: _r(interval: masteredDays)).isMastered, isTrue);
      final known = _w('d', review: _r(known: true, dueIn: const Duration(days: -1)));
      expect(known.isMastered, isTrue);
      expect(known.isDue(_now), isFalse, reason: 'từ đã biết không bao giờ đến hạn');
    });
  });

  group('Bộ từ', () {
    test('khoá lưu / đọc lại', () {
      expect(VocabDeck.parse('topic:Real Estate'), const VocabDeck.topic('Real Estate'));
      expect(VocabDeck.parse('test:7'), const VocabDeck.test(7));
      expect(VocabDeck.parse('test:x'), isNull);
      expect(VocabDeck.parse(null), isNull);
      expect(const VocabDeck.topic('Office').label, 'Văn phòng');
    });

    test('thống kê theo bộ đề', () {
      final items = [
        _w('a', source: 'ETS 2026 Test 1 · câu 2', review: _r(interval: 30)),
        _w('b', source: 'ETS 2026 Test 1 · câu 9', review: _r()),
        _w('c', source: 'ETS 2026 Test 1 · câu 5'),
        _w('d', source: 'ETS 2026 Test 2 · câu 1'),
      ];
      final s = DeckStats.of(const VocabDeck.test(1), items);
      expect((s.total, s.mastered, s.learning, s.fresh), (3, 1, 1, 1));
      expect(allDecks(items).where((d) => d.deck!.kind == DeckKind.test).length, 2);
    });
  });

  group('Phiên học', () {
    test('từ mới theo thứ tự câu trong đề, giới hạn theo chỉ tiêu', () {
      final items = [
        _w('late', source: 'ETS 2026 Test 1 · câu 150'),
        _w('early', source: 'ETS 2026 Test 1 · câu 3'),
        _w('other', source: 'ETS 2026 Test 2 · câu 1'),
        _w('nosrc'),
      ];
      final s = buildSession(items, _now, deck: const VocabDeck.test(1), newLimit: 5);
      expect(s.map((v) => v.id), ['early', 'late']);
      expect(buildSession(items, _now, newLimit: 1).map((v) => v.id), ['early']);
    });

    test('ôn từ đến hạn trước, rồi mới tới từ mới; bỏ từ đã biết', () {
      final items = [
        _w('new'),
        _w('due', review: _r(dueIn: const Duration(hours: -1))),
        _w('known', review: _r(known: true, dueIn: const Duration(hours: -1))),
        _w('later', review: _r()),
      ];
      expect(buildSession(items, _now, newLimit: 10).map((v) => v.id), ['due', 'new']);
    });

    test('chỉ tiêu từ mới trừ số từ đã bắt đầu học hôm nay', () {
      final items = [
        _w('a', review: _r(learnedAt: _now.subtract(const Duration(hours: 1)))),
        _w('b', review: _r(learnedAt: _now.subtract(const Duration(days: 1)))),
        _w('c', review: _r(learnedAt: _now, known: true)),
      ];
      expect(newQuotaLeft(items, _now, 15), 14);
      expect(newQuotaLeft(items, _now, 1), 0);
    });

    test('lọc danh sách theo trạng thái và từ khoá', () {
      final items = [
        _w('a', word: 'budget'),
        _w('b', word: 'invoice', review: _r(dueIn: const Duration(hours: -1))),
      ];
      expect(filterWords(items, filter: WordFilter.due, now: _now).single.id, 'b');
      expect(filterWords(items, query: 'BUD', now: _now).single.id, 'a');
      expect(filterWords(items, query: 'nghĩa b', now: _now).single.id, 'b');
    });
  });

  group('Luyện chủ động', () {
    test('che từ đã chia trong câu ví dụ', () {
      expect(
        clozeOf(_w('a', word: 'reimburse', example: 'The company reimbursed my travel costs.')),
        'The company _____ my travel costs.',
      );
      expect(
        clozeOf(_w('b', word: 'look over', example: 'Could you look over this report?')),
        'Could you _____ this report?',
      );
      expect(
        clozeOf(_w('c', word: 'be committed to', example: 'We are committed to quality.')),
        'We _____ quality.',
      );
      expect(
        clozeOf(_w('d', word: 'pride oneself on', example: 'They pride themselves on service.')),
        'They _____ service.',
      );
      expect(clozeOf(_w('e', word: 'budget', example: 'No match here.')), isNull);
    });

    test('mỗi câu có 4 đáp án khác nhau, đúng 1 đáp án đúng', () {
      final bank = [for (var i = 0; i < 8; i++) _w('w$i', word: 'word$i')];
      final qs = buildPractice(
        pool: bank.take(3).toList(),
        bank: bank,
        mode: PracticeMode.listen,
        random: Random(1),
      );
      expect(qs, hasLength(3));
      for (final q in qs) {
        expect(q.options.toSet(), hasLength(4));
        expect(q.options[q.answerIndex], q.item.word);
      }
    });

    test('gõ từ không phân biệt hoa thường, khoảng trắng, gạch nối', () {
      final q = PracticeQuestion(item: _w('a', word: 'fund-raising'), mode: PracticeMode.spell);
      expect(q.checkSpelling(' Fund raising '), isTrue);
      expect(q.checkSpelling('fundraiser'), isFalse);
    });

    test('ít hơn 4 từ đã học → luyện bằng từ trong bộ', () {
      final deck = [for (var i = 0; i < 5; i++) _w('d$i')];
      final pool = practicePool(deck, deck, PracticeMode.meaning, _now, Random(1));
      expect(pool, hasLength(5));
    });
  });
}
