import 'package:bami_toeic/core/design_system/design_system.dart';
import 'package:bami_toeic/core/design_system/gallery/ds_gallery_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(ThemeData theme, {double textScale = 1}) => MaterialApp(
  theme: theme,
  home: MediaQuery(
    data: MediaQueryData(size: const Size(390, 844), textScaler: TextScaler.linear(textScale)),
    child: const DsGalleryPage(),
  ),
);

void main() {
  contrastTests();

  final themes = {
    'light': AppTheme.light(),
    'dark': AppTheme.dark(),
    'lightHC': AppTheme.lightHighContrast(),
    'darkHC': AppTheme.darkHighContrast(),
  };

  for (final MapEntry(key: name, value: theme) in themes.entries) {
    testWidgets('Gallery render không lỗi – $name', (tester) async {
      await tester.pumpWidget(_app(theme));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(theme.extension<AppColors>(), isNotNull);
    });
  }

  testWidgets('Gallery không tràn layout ở cỡ chữ 200%', (tester) async {
    await tester.pumpWidget(_app(AppTheme.light(), textScale: 2));
    // Cuộn hết danh sách để render mọi section.
    await tester.drag(find.byType(ListView), const Offset(0, -6000));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Nút trong theme đạt vùng chạm tối thiểu 48dp', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Center(
            child: TextButton(onPressed: () {}, child: const Text('OK')),
          ),
        ),
      ),
    );
    final size = tester.getSize(find.byType(TextButton));
    expect(size.height, greaterThanOrEqualTo(AppSizes.touchTarget));
  });

  testWidgets('VocabSkeleton render không lỗi và không tràn layout', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: VocabSkeleton()),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tất cả Skeleton loaders render an toàn không lỗi', (tester) async {
    final skeletons = <Widget>[
      const TestListSkeleton(),
      const TestDetailSkeleton(),
      const VocabSkeleton(),
      const ResultSkeleton(),
      const MistakesSkeleton(),
      const TestTakingSkeleton(),
      const HistorySkeleton(),
      const SplashSkeleton(),
      const FlashcardSkeleton(),
    ];

    for (final sk in skeletons) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(body: sk),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    }
  });
}

double _contrast(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  final (hi, lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + 0.05) / (lo + 0.05);
}

void contrastTests() {
  for (final MapEntry(key: name, value: theme) in {
    'light': AppTheme.light(),
    'dark': AppTheme.dark(),
    'lightHC': AppTheme.lightHighContrast(),
    'darkHC': AppTheme.darkHighContrast(),
  }.entries) {
    test('Tương phản AppColors đạt WCAG AA – $name', () {
      final ac = theme.extension<AppColors>()!;
      final surface = theme.colorScheme.surface;
      final pairs = {
        'success / surface': (ac.success, surface),
        'warning / surface': (ac.warning, surface),
        'onSuccess / success': (ac.onSuccess, ac.success),
        'onWarning / warning': (ac.onWarning, ac.warning),
        'onSuccessContainer / successContainer': (ac.onSuccessContainer, ac.successContainer),
        'onWarningContainer / warningContainer': (ac.onWarningContainer, ac.warningContainer),
      };
      for (final MapEntry(key: label, value: (fg, bg)) in pairs.entries) {
        expect(_contrast(fg, bg), greaterThanOrEqualTo(4.5), reason: label);
      }
    });
  }
}
