import 'package:bami_toeic/helper/score.dart';
import 'package:bami_toeic/helper/srs.dart';
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

    test('Part 1-4 là Listening', () {
      expect(ToeicScore.isListening(4), isTrue);
      expect(ToeicScore.isListening(5), isFalse);
    });
  });
}
