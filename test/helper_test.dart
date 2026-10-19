import 'package:bami_toeic/helper/format.dart';
import 'package:bami_toeic/helper/pacing.dart';
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

    test('khó → chỉ giãn nhẹ, ngắn hơn nhớ', () {
      const s = SrsState(repetitions: 2, intervalDays: 6);
      expect(s.review(ReviewGrade.hard, now: now).intervalDays, 7);
      expect(s.review(ReviewGrade.good, now: now).intervalDays, 15);
      expect(const SrsState().review(ReviewGrade.hard, now: now).intervalDays, 1);
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

  group('Pacing', () {
    TimedAnswer a(int part, int n, int? sec, {bool ok = true}) => TimedAnswer(
      questionId: 'q$n',
      part: part,
      number: n,
      ms: sec == null ? null : sec * 1000,
      correct: ok,
    );

    test('trung bình theo Part, bỏ Listening, câu chậm sắp lâu nhất trước', () {
      final r = Pacing.of([
        a(2, 10, 300),
        a(5, 101, 20),
        a(5, 102, 60, ok: false),
        a(7, 147, 150, ok: false),
        a(7, 148, 90),
      ])!;
      expect([for (final p in r.parts) p.part], [5, 7]);
      expect(r.parts.first.avgSeconds, 40);
      expect(r.parts.last.ratio, 2);
      expect([for (final s in r.slow) s.number], [147, 102]);
      expect(r.slowWrongCount, 2);
    });

    test('ghi được dưới nửa số câu Reading → không báo cáo', () {
      expect(Pacing.of([a(5, 101, 20), a(5, 102, null), a(5, 103, null)]), isNull);
    });
  });

  group('ContextSentence', () {
    const text = 'M: Please send the invoices by Friday. W: Sure, I will do it today!';
    test('lấy câu chứa đoạn bôi đen, bỏ nhãn người nói', () {
      final i = text.indexOf('invoices');
      expect(
        ContextSentence.around(text, i, i + 'invoices'.length),
        'Please send the invoices by Friday.',
      );
      final j = text.indexOf('today');
      expect(ContextSentence.around(text, j, j + 5), 'Sure, I will do it today!');
    });
    test('xuống dòng là ranh giới câu', () {
      const t = '(A) At the front desk\n(B) Next Monday';
      final i = t.indexOf('Monday');
      expect(ContextSentence.around(t, i, i + 6), 'Next Monday');
    });
    test('contains khớp cả dạng biến đổi và cụm từ', () {
      expect(ContextSentence.contains('Please send the invoices.', 'invoice'), isTrue);
      expect(ContextSentence.contains('We shipped it.', 'ship'), isTrue);
      expect(ContextSentence.contains('Fill out the form.', 'fill out'), isTrue);
      expect(ContextSentence.contains('Please send the invoices.', 'budget'), isFalse);
    });
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

  test('Fmt.bytes', () {
    expect(Fmt.bytes(0), '0 KB');
    expect(Fmt.bytes(340 * 1024), '340 KB');
    expect(Fmt.bytes((12.3 * 1024 * 1024).round()), '12,3 MB');
    expect(Fmt.bytes((1.2 * 1024 * 1024 * 1024).round()), '1,2 GB');
  });

  group('Stamina', () {
    TimedAnswer a(int n, bool ok, {bool skipped = false}) => TimedAnswer(
      questionId: 'q$n',
      part: n <= 130 ? 5 : 7,
      number: n,
      ms: null,
      correct: ok,
      skipped: skipped,
    );

    test('đề ngắn hoặc chỉ có Listening thì không đánh giá', () {
      expect(Stamina.of([for (var n = 101; n <= 115; n++) a(n, true)]), isNull);
    });

    test('tụt ở nửa sau → cảnh báo, đếm câu bỏ trống', () {
      final s = Stamina.of([
        for (var n = 101; n <= 150; n++) a(n, n % 10 != 0), // 45/50
        for (var n = 151; n <= 200; n++) a(n, n < 180, skipped: n >= 195), // 29/50
      ])!;
      expect(s.first.from, 101);
      expect(s.last.to, 200);
      expect(s.first.correct, 45);
      expect(s.last.correct, 29);
      expect(s.last.skipped, 6);
      expect(s.dropped, isTrue);
    });
  });
}
