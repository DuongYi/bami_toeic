// Tạo / cập nhật ảnh: flutter test --update-goldens test/goldens
import 'dart:async';

import 'package:bami_toeic/core/design_system/design_system.dart';
import 'package:bami_toeic/core/network/app_exception.dart';
import 'package:bami_toeic/module/auth/presentation/controllers/login_controller.dart';
import 'package:bami_toeic/module/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_utils.dart';

class _FailedLogin extends LoginController {
  @override
  FutureOr<void> build() => throw const UnauthorizedException('Email hoặc mật khẩu không đúng.');
}

Future<void> _pump(WidgetTester tester, ThemeData theme, {bool failed = false}) async {
  tester.view
    ..physicalSize =
        const Size(1170, 2532) // iPhone 14 (390×844 @3x)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [if (failed) loginControllerProvider.overrideWith(_FailedLogin.new)],
      child: MaterialApp(debugShowCheckedModeBanner: false, theme: theme, home: const LoginPage()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('Login – light', (tester) async {
    await _pump(tester, AppTheme.light());
    await expectLater(find.byType(LoginPage), matchesGoldenFile('login_light.png'));
  });

  testWidgets('Login – dark', (tester) async {
    await _pump(tester, AppTheme.dark());
    await expectLater(find.byType(LoginPage), matchesGoldenFile('login_dark.png'));
  });

  testWidgets('Login – sai mật khẩu', (tester) async {
    await _pump(tester, AppTheme.light(), failed: true);
    await tester.enterText(find.byType(TextFormField).first, 'me@example.com');
    await tester.pumpAndSettle();
    // Sửa form sẽ ẩn lỗi → dựng lại trạng thái lỗi để chụp.
    final container = ProviderScope.containerOf(tester.element(find.byType(LoginPage)));
    container.invalidate(loginControllerProvider);
    await tester.pumpAndSettle();
    await expectLater(find.byType(LoginPage), matchesGoldenFile('login_error.png'));
  });

  testWidgets('Login – validate khi để trống', (tester) async {
    await _pump(tester, AppTheme.light());
    await tester.tap(find.text('Đăng nhập').last);
    await tester.pumpAndSettle();
    expect(find.text('Nhập email của bạn'), findsOneWidget);
    expect(find.text('Nhập mật khẩu'), findsOneWidget);
  });
}
