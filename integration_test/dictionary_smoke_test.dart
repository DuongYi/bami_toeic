// Smoke test chạy app thật (backend Supabase thật) trên simulator / máy thật:
// từ điển, dịch câu, bôi đen chữ trong đáp án, Part 1/2 không lộ chữ phương án.
//
//   SCREENSHOT_DIR=build/screenshots flutter drive -d <thiết bị> \
//     --driver=test_driver/integration_test.dart --target=integration_test/dictionary_smoke_test.dart \
//     --dart-define-from-file=env.json --dart-define=TOEIC_EMAIL=… --dart-define=TOEIC_PASSWORD=… \
//     --dart-define=SMOKE_TEST_ID=<id đề Mini Test có Part 1–7>
import 'package:bami_toeic/main.dart';
import 'package:bami_toeic/module/test/presentation/widgets/question_group_view.dart';
import 'package:bami_toeic/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

const _email = String.fromEnvironment('TOEIC_EMAIL');
const _password = String.fromEnvironment('TOEIC_PASSWORD');
const _testId = String.fromEnvironment('SMOKE_TEST_ID');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// pumpAndSettle không dùng được (đồng hồ làm bài, vòng tải) → pump tới khi thấy [finder].
  Future<void> waitFor(WidgetTester tester, Finder finder, {int seconds = 30}) async {
    final end = DateTime.now().add(Duration(seconds: seconds));
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 200));
      if (finder.evaluate().isNotEmpty) return;
    }
    await binding.takeScreenshot('zz_timeout');
    throw TestFailure('Không thấy $finder sau $seconds giây');
  }

  Future<void> settle(WidgetTester tester, [int ms = 1200]) async {
    for (var i = 0; i < ms ~/ 100; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> shot(WidgetTester tester, String name) async {
    await settle(tester, 600);
    await binding.takeScreenshot(name);
  }

  testWidgets('từ điển, dịch, bôi đen đáp án, Part 1/2', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BamiToeicApp()));
    await settle(tester, 3000);

    await binding.takeScreenshot('00_start');
    // Đăng nhập nếu máy chưa có phiên.
    if (find.text('Mật khẩu').evaluate().isNotEmpty) {
      await tester.enterText(find.byType(TextFormField).at(0), _email);
      await tester.enterText(find.byType(TextFormField).at(1), _password);
      await tester.tap(find.text('Đăng nhập').last);
    }
    await waitFor(tester, find.byTooltip('Tra từ điển'));
    await shot(tester, '01_home');

    // Sheet tra nhanh: gợi ý → mục từ → Anh–Anh.
    await tester.tap(find.byTooltip('Tra từ điển').first);
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, 'invo');
    // Dòng gợi ý là Text.rich "từ  /IPA/" → khớp theo đầu chuỗi.
    final invoice = find.textContaining(RegExp(r'^invoice\b'), findRichText: true);
    await waitFor(tester, invoice);
    await shot(tester, '02_suggestions');
    await tester.tap(invoice.first);
    await waitFor(tester, find.text('Anh – Việt'));
    await shot(tester, '03_entry_vi');
    await tester.tap(find.text('Anh – Anh'));
    // Anh–Anh là API ngoài: có định nghĩa hoặc báo lỗi kèm Thử lại đều được, miễn không treo.
    await waitFor(
      tester,
      find.byWidgetPredicate(
        (w) => w is Text && ((w.data ?? '').contains(' · noun') || w.data == 'Thử lại'),
      ),
      seconds: 20,
    );
    await shot(tester, '04_entry_en');

    // Dịch câu dài.
    final field = find.descendant(of: find.byType(BottomSheet), matching: find.byType(TextField));
    await tester.tap(field);
    await settle(tester, 300);
    await tester.enterText(
      field,
      'All employees are required to submit their expense reports by the end of the month.',
    );
    await waitFor(tester, find.text('Dịch sang tiếng Việt'));
    await tester.tap(find.text('Dịch sang tiếng Việt'));
    // Google Dịch là API ngoài: có bản dịch hoặc báo lỗi kèm Thử lại đều được, miễn không treo.
    await waitFor(
      tester,
      find.byWidgetPredicate((w) => w is Text && (w.data == 'Tiếng Việt' || w.data == 'Thử lại')),
    );
    await shot(tester, '05_translate');
    await tester.tapAt(const Offset(20, 20)); // đóng sheet
    await settle(tester);

    // Đề luyện tập: Part 1 không hiện chữ phương án.
    final container = ProviderScope.containerOf(tester.element(find.byType(BamiToeicApp)));
    container
        .read(routerProvider)
        .push(Routes.take(_testId, mode: 'practice', parts: [1, 2, 3, 4, 5, 6, 7]));
    await waitFor(tester, find.byTooltip('Câu tiếp'));
    await shot(tester, '06_part1');

    // Tới Part 5 (nhóm thứ 8 của Mini Test 25Q), nhấn giữ chữ trong đáp án.
    for (var i = 0; i < 7; i++) {
      await tester.tap(find.byTooltip('Câu tiếp'));
      await settle(tester, 700);
    }
    await shot(tester, '07_part5');
    final option = find.descendant(
      of: find.byType(AnswerOption),
      matching: find.byType(SelectableText),
    );
    // Nhấn giữ đúng vào chữ (giữa ô là khoảng trống bên phải chữ → không chọn được từ nào).
    await tester.longPressAt(tester.getTopLeft(option.first) + const Offset(24, 12));
    await settle(tester);
    await shot(tester, '08_option_selected');
    if (find.text('Tra từ').evaluate().isNotEmpty) {
      await tester.tap(find.text('Tra từ'));
      await waitFor(tester, find.text('Anh – Việt'), seconds: 20);
      await shot(tester, '09_option_lookup');
    }
  });
}
