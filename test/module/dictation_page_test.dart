import 'package:bami_toeic/core/design_system/design_system.dart';
import 'package:bami_toeic/core/handwriting/handwriting_recognizer.dart';
import 'package:bami_toeic/module/listening/presentation/controllers/dictation_providers.dart';
import 'package:bami_toeic/module/listening/presentation/pages/dictation_page.dart';
import 'package:bami_toeic/module/test/data/models/test_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sampleGroup = QuestionGroup(
    id: 'g1',
    testId: 'test1',
    part: 2,
    orderNo: 1,
    transcript: 'Where is the meeting room?\n(A) Down the hall.',
    audioUrl: 'https://example.com/audio/sample.mp3',
    questions: const [
      Question(
        id: 'q1',
        part: 2,
        number: 7,
        content: 'Where is the meeting room?',
        options: ['Down the hall', 'At 2 PM', 'Yes, I did'],
        answer: 'A',
      ),
    ],
  );

  Widget wrapWithScope(Widget child, {Size size = const Size(390, 844)}) {
    return ProviderScope(
      overrides: [
        dictationClipsProvider('test1', 2).overrideWith((ref) => Future.value([sampleGroup])),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: child,
        ),
      ),
    );
  }

  group('DictationPage Tests', () {
    testWidgets('Render DictationPage, điều khiển tốc độ và gõ kiểm tra', (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await tester.pumpWidget(
        wrapWithScope(
          const DictationPage(testId: 'test1', part: 2),
        ),
      );
      await tester.pumpAndSettle();

      // Kiểm tra Header
      expect(find.text('Part 2'), findsOneWidget);
      expect(find.text('Câu 7'), findsOneWidget);

      // Kiểm tra các mức tốc độ âm thanh
      expect(find.text('0.75x'), findsOneWidget);
      expect(find.text('1.0x'), findsOneWidget);
      expect(find.text('1.25x'), findsOneWidget);

      // Chạm đổi tốc độ sang 0.75x
      await tester.tap(find.text('0.75x'));
      await tester.pump();

      // Kiểm tra nút tua lùi 3s
      expect(find.text('3s'), findsOneWidget);

      // Nhập bài chép chính tả
      final inputField = find.byType(TextField);
      expect(inputField, findsOneWidget);
      await tester.enterText(inputField, 'Where is the meeting room Down the hall');
      await tester.pump();

      // Kiểm tra bộ đếm từ tự động cập nhật
      expect(find.text('8 từ đã gõ'), findsOneWidget);

      // Bấm Kiểm tra
      final checkButton = find.widgetWithText(AppPrimaryButton, 'Kiểm tra');
      expect(checkButton, findsOneWidget);
      await tester.tap(checkButton);
      await tester.pumpAndSettle();

      // Nút chuyển thành Hoàn thành (vì là đoạn cuối)
      expect(find.widgetWithText(AppPrimaryButton, 'Hoàn thành'), findsOneWidget);

      // Cuộn để kiểm tra Card kết quả và Shadowing
      await tester.scrollUntilVisible(
        find.text('Luyện nói theo (Shadowing)'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Độ chính xác'), findsOneWidget);
      expect(find.text('Luyện nói theo (Shadowing)'), findsOneWidget);
    });

    testWidgets('Chuyển đổi sang chế độ Viết tay (Pencil) và hiển thị Vở Scribble lẫn Canvas', (tester) async {
      await tester.pumpWidget(
        wrapWithScope(
          const DictationPage(testId: 'test1', part: 2),
        ),
      );
      await tester.pumpAndSettle();

      // Mặc định ở chế độ Gõ phím
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(HandwritingPad), findsNothing);

      // Chạm chọn Viết tay (Pencil)
      await tester.tap(find.text('Viết tay (Pencil)'));
      await tester.pumpAndSettle();

      // Kiểm tra Vở Scribble hiển thị với TextField hỗ trợ Apple Pencil
      expect(find.text('Vở viết Scribble (Apple Pencil)'), findsWidgets);
      expect(find.byType(TextField), findsOneWidget);

      // Chuyển sang Bảng vẽ nét (Canvas)
      await tester.tap(find.text('Bảng vẽ nét (Canvas)'));
      await tester.pumpAndSettle();

      // Kiểm tra ô viết tay HandwritingPad xuất hiện
      expect(find.byType(HandwritingPad), findsOneWidget);
      expect(find.text('Chuyển nét vẽ thành văn bản (A→Text)'), findsOneWidget);
    });

    testWidgets('Giao diện iPad ngang kích hoạt 2 cột tối ưu', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        wrapWithScope(
          const DictationPage(testId: 'test1', part: 2),
          size: const Size(1024, 768),
        ),
      );
      await tester.pumpAndSettle();

      // Kiểm tra trình phát và ô nhập đồng thời hiển thị
      expect(find.text('Part 2'), findsOneWidget);
      expect(find.text('0.75x'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });

  group('Viết tay trên bảng vẽ', () {
    Future<void> openCanvas(WidgetTester tester, _FakeRecognizer fake) async {
      tester.view.physicalSize = const Size(1170, 3200);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dictationClipsProvider('test1', 2).overrideWith((ref) => Future.value([sampleGroup])),
            handwritingRecognizerProvider.overrideWithValue(fake),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const DictationPage(testId: 'test1', part: 2),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Viết tay (Pencil)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bảng vẽ nét (Canvas)'));
      await tester.pumpAndSettle();
      // Vẽ 1 nét và 1 chấm (chạm không di chuyển) – cả hai phải được ghi.
      final pad = find.byType(HandwritingPad);
      await tester.ensureVisible(pad);
      final center = tester.getCenter(pad);
      await tester.dragFrom(center, const Offset(60, 4));
      await tester.tapAt(center + const Offset(90, -20));
      await tester.pumpAndSettle();
    }

    testWidgets('chữ nhận dạng được đưa vào ô trả lời, không chép đáp án', (tester) async {
      final fake = _FakeRecognizer('hall way');
      await openCanvas(tester, fake);
      await tester.tap(find.text('Chuyển nét vẽ thành văn bản (A→Text)'));
      await tester.pumpAndSettle();

      expect(fake.lastStrokes, 2, reason: 'nét kéo + dấu chấm đều phải được ghi');
      expect(find.text('Chữ đã nhận dạng (sửa nếu sai)'), findsOneWidget);
      expect(find.text('hall way'), findsOneWidget);
      expect(find.textContaining('Where is the meeting room'), findsNothing);
    });

    testWidgets('không đọc được chữ → báo, ô trả lời vẫn trống', (tester) async {
      await openCanvas(tester, _FakeRecognizer(''));
      await tester.tap(find.text('Chuyển nét vẽ thành văn bản (A→Text)'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Chưa đọc được chữ'), findsOneWidget);
      expect(find.text('Chữ đã nhận dạng (sửa nếu sai)'), findsNothing);
    });
  });

  test('dựng ảnh PNG từ nét vẽ để gửi nhận dạng', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final png = await HandwritingRecognizer.renderStrokes(const [
      DrawStroke(points: [Offset(0, 0), Offset(40, 30)], color: Color(0xFF000000)),
      DrawStroke(points: [Offset(60, 10)], color: Color(0xFF000000)),
    ]);
    expect(png, isNotNull);
    expect(png!.sublist(1, 4), 'PNG'.codeUnits);
    expect(await HandwritingRecognizer.renderStrokes(const []), isNull);
  });
}

class _FakeRecognizer extends HandwritingRecognizer {
  _FakeRecognizer(this.result);

  final String result;
  int? lastStrokes;

  @override
  bool get isSupported => true;

  @override
  Future<String> recognize(List<DrawStroke> strokes) async {
    lastStrokes = strokes.length;
    return result;
  }
}
