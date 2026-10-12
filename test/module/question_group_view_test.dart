import 'package:bami_toeic/core/design_system/design_system.dart';
import 'package:bami_toeic/module/test/data/models/test_models.dart';
import 'package:bami_toeic/module/test/presentation/widgets/question_group_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {Size size = const Size(390, 844)}) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  final sampleQuestions = [
    const Question(
      id: 'q1',
      part: 3,
      number: 1,
      content: 'Where does this conversation take place?',
      options: ['In a hospital', 'At an airport', 'In a restaurant', 'At a bank'],
      answer: 'B',
      explanation: 'The speakers mention flight 302 and boarding gate 4.',
    ),
    const Question(
      id: 'q2',
      part: 3,
      number: 2,
      content: 'What will the man do next?',
      options: ['Call the manager', 'Board the plane', 'Order food', 'Exchange money'],
      answer: 'B',
      explanation: 'He will go to gate 4 directly.',
    ),
  ];

  final sampleGroup = QuestionGroup(
    id: 'g1',
    part: 3,
    orderNo: 1,
    passage: 'M: Attention passengers on Flight 302 to Tokyo...\nW: We will be boarding soon.',
    audioUrl: 'https://example.com/audio/sample.mp3',
    transcript: 'Full transcript of the conversation.',
    questions: sampleQuestions,
  );

  group('QuestionGroupView Portrait Test', () {
    testWidgets('Render Sticky Audio Bar và Danh sách câu hỏi ở màn hình dọc', (tester) async {
      final answers = <String, String?>{'q1': 'A'};
      String? selectedAnswer;

      await tester.pumpWidget(
        _wrap(
          QuestionGroupView(
            group: sampleGroup,
            answers: answers,
            showAudio: true,
            onSelect: (q, letter) => selectedAnswer = letter,
          ),
          size: const Size(390, 844),
        ),
      );
      await tester.pump();

      // Kiểm tra StatusBadge
      expect(find.text('Part 3 · Hội thoại'), findsOneWidget);

      // Kiểm tra Passage
      expect(find.textContaining('Flight 302'), findsOneWidget);

      // Kiểm tra câu hỏi 1 và 2
      expect(find.textContaining('Where does this conversation take place?'), findsOneWidget);
      expect(find.textContaining('What will the man do next?'), findsOneWidget);

      // Chạm chọn đáp án
      final optionB = find.text('At an airport');
      expect(optionB, findsOneWidget);
      await tester.tap(optionB);
      expect(selectedAnswer, 'B');
    });
  });

  group('QuestionGroupView iPad Landscape Split 2/3 - 1/3 Test', () {
    testWidgets('Xoay ngang iPad (1024x768): Kích hoạt chia cột 2/3 và 1/3 (Phiếu đáp án)', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final answers = <String, String?>{'q1': 'B'};
      Question? selectedQ;
      String? selectedLetter;

      await tester.pumpWidget(
        _wrap(
          QuestionGroupView(
            group: sampleGroup,
            allGroups: [sampleGroup],
            currentGroupIndex: 0,
            onJumpToGroup: (i) {},
            answers: answers,
            showAudio: true,
            onSelect: (q, letter) {
              selectedQ = q;
              selectedLetter = letter;
            },
          ),
          size: const Size(1024, 768),
        ),
      );
      await tester.pump();

      // Kiểm tra bên 1/3 xuất hiện "Phiếu đáp án"
      expect(find.text('Phiếu đáp án'), findsOneWidget);
      expect(find.text('1/2 câu đã trả lời'), findsOneWidget);

      // Kiểm tra bên 2/3 vẫn có bài đọc và audio
      expect(find.textContaining('Flight 302'), findsOneWidget);

      // Chạm chọn đáp án ở Cột 1/3 cho câu 2
      final optionBList = find.text('Board the plane');
      expect(optionBList, findsWidgets); // Xuất hiện cả ở đề và phiếu đáp án
      await tester.tap(optionBList.last);
      expect(selectedQ?.id, 'q2');
      expect(selectedLetter, 'B');

      // Chuyển đổi sang "Phiếu toàn bài thi"
      final toggleAllOmr = find.byTooltip('Xem phiếu toàn bài');
      expect(toggleAllOmr, findsOneWidget);
      await tester.tap(toggleAllOmr);
      await tester.pump();

      expect(find.text('Phiếu toàn bài thi'), findsOneWidget);
    });
  });
}
