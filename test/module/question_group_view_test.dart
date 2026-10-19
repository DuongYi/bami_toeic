import 'package:bami_toeic/core/design_system/design_system.dart';
import 'package:bami_toeic/module/test/data/models/test_models.dart';
import 'package:bami_toeic/module/test/presentation/controllers/test_providers.dart';
import 'package:bami_toeic/module/test/presentation/widgets/question_group_view.dart';
import 'package:bami_toeic/module/vocab/presentation/widgets/word_lookup_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _NoSaved extends SavedQuestions {
  @override
  Future<List<SavedQuestion>> build() async => const [];
}

Widget _wrap(Widget child, {Size size = const Size(390, 844)}) {
  return ProviderScope(
    overrides: [savedQuestionsProvider.overrideWith(_NoSaved.new)],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: Scaffold(body: child),
      ),
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

      // Thử lọc chỉ câu đánh dấu khi chưa có câu nào gắn cờ
      final filterFlagged = find.byTooltip('Chỉ xem câu đánh dấu');
      expect(filterFlagged, findsOneWidget);
      await tester.tap(filterFlagged);
      await tester.pump();

      expect(find.text('Chưa có câu nào được đánh dấu cờ.'), findsOneWidget);
    });
  });

  group('QuestionGroupView Apple Pencil Annotation Overlay Test', () {
    testWidgets('Hiển thị thanh bút nổi Apple Pencil và cho phép gập mở công cụ vẽ', (tester) async {
      await tester.pumpWidget(
        _wrap(
          QuestionGroupView(
            group: sampleGroup,
            answers: const {},
            showAudio: false,
            onSelect: (q, letter) {},
          ),
          size: const Size(1024, 768),
        ),
      );
      await tester.pump();

      // Kiểm tra có AnnotationOverlay
      expect(find.byType(AnnotationOverlay), findsOneWidget);

      // Nút mở bút vẽ nổi
      final openPencilBtn = find.byTooltip('Mở bút viết Apple Pencil');
      expect(openPencilBtn, findsOneWidget);

      // Chạm mở thanh công cụ bút
      await tester.tap(openPencilBtn);
      await tester.pumpAndSettle();

      // Kiểm tra các công cụ vẽ xuất hiện
      expect(find.byTooltip('Chạm chọn & cuộn'), findsOneWidget);
      expect(find.byTooltip('Bút mực'), findsOneWidget);
      expect(find.byTooltip('Bút dạ quang (Highlight)'), findsOneWidget);
      expect(find.byTooltip('Tẩy nét vẽ'), findsOneWidget);
      expect(find.byTooltip('Hoàn tác (Undo)'), findsOneWidget);
      expect(find.byTooltip('Xoá tất cả nét vẽ'), findsOneWidget);

      // Khi mở thanh bút, mặc định chuyển sang Bút mực và khoá cuộn màn hình
      expect(find.text('Đã khoá cuộn'), findsOneWidget);

      // Chạm chọn bút dạ quang
      await tester.tap(find.byTooltip('Bút dạ quang (Highlight)'));
      await tester.pump();
      expect(find.text('Đã khoá cuộn'), findsOneWidget);

      // Chạm chọn lại chế độ Chạm & cuộn
      await tester.tap(find.byTooltip('Chạm chọn & cuộn'));
      await tester.pump();
      expect(find.text('Đã khoá cuộn'), findsNothing);

      // Thu gọn thanh công cụ bút
      final closePencilBtn = find.byTooltip('Thu nhỏ bút');
      expect(closePencilBtn, findsOneWidget);
      await tester.tap(closePencilBtn);
      await tester.pumpAndSettle();

      expect(find.byTooltip('Bút dạ quang (Highlight)'), findsNothing);
    });
  });

  group('Text Highlighting Tests', () {
    const highlightStyle = TextStyle(
      backgroundColor: Color(0xFFFEF08A),
      color: Color(0xFF854D0E),
      fontWeight: FontWeight.w600,
    );

    test('buildHighlightedSpans splits and highlights keywords accurately', () {
      const text = 'Where is the announcement being made?';
      final spans = buildHighlightedSpans(
        text,
        {'being'},
        highlightStyle: highlightStyle,
      );

      expect(spans.length, 3);
      expect((spans[0] as TextSpan).text, 'Where is the announcement ');
      expect((spans[0] as TextSpan).style?.backgroundColor, isNull);

      expect((spans[1] as TextSpan).text, 'being');
      expect((spans[1] as TextSpan).style?.backgroundColor, const Color(0xFFFEF08A));

      expect((spans[2] as TextSpan).text, ' made?');
      expect((spans[2] as TextSpan).style?.backgroundColor, isNull);
    });

    test('buildHighlightedSpans preserves bold prefix for question numbers', () {
      const text = '71. Where is the announcement being made?';
      final spans = buildHighlightedSpans(
        text,
        {'being'},
        highlightStyle: highlightStyle,
        boldPrefixLength: 4, // '71. '
      );

      expect(spans.length, 4);
      expect((spans[0] as TextSpan).text, '71. ');
      expect((spans[0] as TextSpan).style?.fontWeight, FontWeight.bold);

      expect((spans[1] as TextSpan).text, 'Where is the announcement ');
      expect((spans[2] as TextSpan).text, 'being');
      expect((spans[2] as TextSpan).style?.backgroundColor, const Color(0xFFFEF08A));
      expect((spans[3] as TextSpan).text, ' made?');
    });

    test('buildHighlightedSpans prioritizes longer phrases to prevent overlap fragmentation', () {
      const text = 'Flight 302 to Tokyo';
      final spans = buildHighlightedSpans(
        text,
        {'Flight', 'Flight 302'},
        highlightStyle: highlightStyle,
      );

      expect(spans.length, 2);
      expect((spans[0] as TextSpan).text, 'Flight 302');
      expect((spans[0] as TextSpan).style?.backgroundColor, const Color(0xFFFEF08A));
      expect((spans[1] as TextSpan).text, ' to Tokyo');
    });

    testWidgets('QuestionGroupView manages static highlights per group', (tester) async {
      QuestionGroupView.clearHighlights();

      await tester.pumpWidget(
        _wrap(
          QuestionGroupView(
            group: sampleGroup,
            answers: const {},
            showAudio: false,
          ),
        ),
      );
      await tester.pump();

      // Ban đầu chưa có highlight
      expect(QuestionGroupView.getHighlights('g1', 'passage'), isEmpty);

      // Thêm highlight cho passage
      QuestionGroupView.clearHighlights();
      expect(QuestionGroupView.getHighlights('g1', 'passage'), isEmpty);
    });

    testWidgets('lookupContextMenu provides Highlight and Tra từ in button items', (tester) async {
      String? toggled;
      bool isHl = false;

      final controller = TextEditingController(text: 'Where is the announcement being made?');
      controller.selection = const TextSelection(baseOffset: 26, extentOffset: 31); // 'being'

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) {
                return TextField(
                  controller: controller,
                  contextMenuBuilder: lookupContextMenu(
                    ctx,
                    isHighlighted: (text) => isHl,
                    onToggleHighlight: (text) => toggled = text,
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();

      // Long press / tap to show context menu toolbar
      final textField = find.byType(TextField);
      await tester.longPress(textField);
      await tester.pumpAndSettle();

      expect(find.text('Tra từ'), findsOneWidget);
      expect(find.text('Highlight'), findsOneWidget);

      // Tap Highlight
      await tester.tap(find.text('Highlight'));
      await tester.pumpAndSettle();
      expect(toggled, 'announcement');

      // Khi từ đã highlight, context menu hiển thị "Bỏ highlight"
      isHl = true;
      await tester.longPress(textField);
      await tester.pumpAndSettle();
      expect(find.text('Bỏ highlight'), findsOneWidget);
    });
  });

  group('Part 1/2 chỉ nghe', () {
    const leaky = Question(
      id: 'p2',
      part: 2,
      number: 7,
      content: 'Where is the meeting?',
      options: ['In room 5.', 'Yes, I did.', 'At noon.'],
      answer: 'A',
    );
    final group = QuestionGroup(
      id: 'g2',
      part: 2,
      orderNo: 7,
      audioUrl: 'https://example.com/a07.m4a',
      questions: const [leaky],
    );

    testWidgets('chưa xem đáp án → không hiện chữ câu hỏi / phương án dù dữ liệu có', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(QuestionGroupView(group: group, answers: const {}, onSelect: (_, _) {})),
      );
      await tester.pump();
      expect(find.textContaining('Where is the meeting?'), findsNothing);
      expect(find.text('In room 5.'), findsNothing);
      expect(find.text('A'), findsOneWidget); // vẫn có nút chọn A/B/C
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('đã xem đáp án → hiện lại chữ để đối chiếu', (tester) async {
      await tester.pumpWidget(
        _wrap(QuestionGroupView(group: group, answers: const {'p2': 'B'}, isRevealed: (_) => true)),
      );
      await tester.pump();
      expect(find.text('In room 5.'), findsOneWidget);
    });
  });
}
