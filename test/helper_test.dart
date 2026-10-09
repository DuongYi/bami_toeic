import 'package:bami_toeic/helper/dictation.dart';
import 'package:bami_toeic/helper/score.dart';
import 'package:bami_toeic/helper/srs.dart';
import 'package:bami_toeic/helper/word_match.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SrsState', () {
    final now = DateTime(2026, 1, 1, 8);

    test('quên → học lại sau 10 phút, reset repetitions', () {
      final s = const SrsState(
        repetitions: 3,
        intervalDays: 10,
      ).review(ReviewGrade.again, now: now);
      expect(s.repetitions, 0);
      expect(s.dueAt, now.add(const Duration(minutes: 10)));
    });

    test('nhớ liên tục → 1, 6, rồi nhân ease', () {
      var s = const SrsState();
      s = s.review(ReviewGrade.good, now: now);
      expect(s.intervalDays, 1);
      s = s.review(ReviewGrade.good, now: now);
      expect(s.intervalDays, 6);
      s = s.review(ReviewGrade.good, now: now);
      expect(s.intervalDays, 15);
    });

    test('ease không xuống dưới 1.3', () {
      var s = const SrsState();
      for (var i = 0; i < 10; i++) {
        s = s.review(ReviewGrade.again, now: now);
      }
      expect(s.ease, 1.3);
    });
  });

  group('ToeicScore', () {
    test('giới hạn 5..495', () {
      expect(ToeicScore.listening(0), 5);
      expect(ToeicScore.listening(100), 495);
      expect(ToeicScore.reading(100), 485);
    });

    test('dùng bảng quy đổi của đề khi có, lấy điểm giữa khoảng', () {
      final t = ScoreTable.tryParse({
        'listening': [
          [0, 50, 5, 200],
          [51, 100, 205, 495],
        ],
        'reading': [
          [0, 100, 300, 300],
        ],
      });
      expect(t, isNotNull);
      expect(ToeicScore.listening(96, t), 350); // (205+495)/2
      expect(ToeicScore.reading(10, t), 300);
    });

    test('bảng sai định dạng → quay về ước tính', () {
      expect(ScoreTable.tryParse({'listening': 'x'}), isNull);
      expect(ToeicScore.listening(100, ScoreTable.tryParse(null)), 495);
    });

    test('Part 1-4 là Listening', () {
      expect(ToeicScore.isListening(4), isTrue);
      expect(ToeicScore.isListening(5), isFalse);
    });
  });

  group('WordMatch', () {
    final words = ['ship', 'comply with', 'apply', 'deliver', 'shipment', 'be eligible for'];
    List<String> find(String q) => WordMatch.find(words, q, (w) => w);

    test('tìm dạng gốc', () {
      expect(find('Shipping,'), ['ship']);
      expect(find('applied'), ['apply']);
      expect(find('delivered.'), ['deliver']);
    });

    test('cụm từ chứa từ', () {
      expect(find('complies'), ['comply with']);
      expect(find('eligible'), ['be eligible for']);
    });

    test('không khớp', () => expect(find('xyz'), isEmpty));
  });

  group('Dictation', () {
    test('bỏ nhãn đầu dòng', () {
      expect(Dictation.lines('Where is it?\n(A) At the hotel.\nW: Hi.'), [
        'Where is it?',
        'At the hotel.',
        'Hi.',
      ]);
    });

    test('chấm theo từ, bỏ dấu câu và hoa/thường', () {
      final r = Dictation.check(
        'Where is the conference being held?',
        'where is conference bein held',
      );
      expect(r.total, 6);
      expect(r.correct, 4);
      expect(r.tokens.where((t) => !t.$2).map((t) => t.$1), ['the', 'being']);
    });
  });
}
