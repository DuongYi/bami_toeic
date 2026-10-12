import 'package:bami_toeic/module/test/data/models/test_models.dart';
import 'package:bami_toeic/module/test/presentation/controllers/test_taking_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('examDuration', () {
    test('không có thời gian riêng → 120 phút / 200 câu', () {
      expect(examDuration(200), const Duration(minutes: 120));
      expect(examDuration(25), const Duration(minutes: 15));
      expect(examDuration(4), const Duration(minutes: 5)); // tối thiểu 5 phút
    });

    test('có thời gian riêng → chia theo tỉ lệ số câu của cả đề', () {
      expect(examDuration(15, limitMinutes: 15, testTotal: 15), const Duration(minutes: 15));
      expect(examDuration(8, limitMinutes: 15, testTotal: 15), const Duration(minutes: 8));
    });
  });

  test('TestSummary.examMinutes khớp examDuration khi làm cả đề', () {
    const quick = TestSummary(id: 'q', title: 'Quick', questionCount: 15, timeLimitMinutes: 15);
    const mini = TestSummary(id: 'm', title: 'Mini', questionCount: 25);
    const full = TestSummary(id: 'f', title: 'Full', questionCount: 200);
    expect(quick.examMinutes, 15);
    expect(mini.examMinutes, 15);
    expect(full.examMinutes, 120);
  });
}
