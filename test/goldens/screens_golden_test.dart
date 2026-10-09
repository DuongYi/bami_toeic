// Ảnh chụp các màn hình chính với dữ liệu giả.
// Tạo / cập nhật: flutter test --update-goldens test/goldens
import 'dart:math';

import 'package:bami_toeic/main.dart';
import 'package:bami_toeic/module/auth/presentation/controllers/auth_controller.dart';
import 'package:bami_toeic/module/goals/data/goals_repository.dart';
import 'package:bami_toeic/module/leaderboard/data/leaderboard_repository.dart';
import 'package:bami_toeic/module/plan/data/plan_repository.dart';
import 'package:bami_toeic/module/test/data/test_repository.dart';
import 'package:bami_toeic/module/vocab/data/vocab_repository.dart';
import 'package:bami_toeic/module/vocab/presentation/controllers/vocab_controller.dart';
import 'package:bami_toeic/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_data.dart';
import 'golden_utils.dart';

Future<ProviderContainer> _boot(
  WidgetTester tester, {
  Brightness brightness = Brightness.light,
}) async {
  tester.view
    ..physicalSize = const Size(1170, 2532)
    ..devicePixelRatio = 3;
  tester.platformDispatcher.platformBrightnessTestValue = brightness;
  debugDisableShadows = false; // chụp shadow thật (mặc định test vẽ shadow thành viền đen)
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authControllerProvider.overrideWith(FakeAuth.new),
        testRepositoryProvider.overrideWithValue(FakeTestRepository()),
        vocabRepositoryProvider.overrideWithValue(FakeVocabRepository()),
        goalsRepositoryProvider.overrideWithValue(FakeGoalsRepository()),
        leaderboardRepositoryProvider.overrideWithValue(FakeLeaderboardRepository()),
        planRepositoryProvider.overrideWithValue(FakePlanRepository()),
        sessionRandomProvider.overrideWithValue(Random(1)),
      ],
      child: const BamiToeicApp(),
    ),
  );
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(tester.element(find.byType(BamiToeicApp)));
}

Future<void> _go(
  WidgetTester tester,
  ProviderContainer c,
  String location, {
  bool push = false,
}) async {
  final router = c.read(routerProvider);
  push ? router.push(location) : router.go(location);
  await tester.pumpAndSettle();
}

Future<void> _shot(WidgetTester tester, String name) async {
  await expectLater(find.byType(BamiToeicApp), matchesGoldenFile('screens/$name.png'));
}

Future<void> _teardown(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox()); // huỷ Timer của màn làm bài
  await tester.pump(const Duration(seconds: 1));
  debugDisableShadows = true; // trả lại mặc định trước khi test kết thúc
}

void main() {
  setUpAll(loadAppFonts);
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Luyện nghe', (tester) async {
    final c = await _boot(tester);
    await _go(tester, c, Routes.listening, push: true);
    await _shot(tester, '10_listening');
    await _teardown(tester);
  });

  testWidgets('Sổ câu sai', (tester) async {
    final c = await _boot(tester);
    await _go(tester, c, Routes.mistakes, push: true);
    await _shot(tester, '09_mistakes');
    await _teardown(tester);
  });

  testWidgets('Danh sách đề', (tester) async {
    await _boot(tester);
    await _shot(tester, '01_tests');
    await _teardown(tester);
  });

  testWidgets('Chi tiết đề', (tester) async {
    final c = await _boot(tester);
    await _go(tester, c, Routes.testDetail('t3'));
    await _shot(tester, '02_test_detail');
    await _teardown(tester);
  });

  testWidgets('Làm bài – luyện tập, đã chọn đáp án', (tester) async {
    final c = await _boot(tester);
    await _go(tester, c, Routes.take('t3', mode: 'practice', parts: [5, 7]), push: true);
    await tester.tap(find.text('until'));
    await tester.pumpAndSettle();
    await _shot(tester, '03_taking');
    await _teardown(tester);
  });

  testWidgets('Kết quả', (tester) async {
    final c = await _boot(tester);
    await _go(tester, c, Routes.result('a2'), push: true);
    await _shot(tester, '04_result');
    await _teardown(tester);
  });

  testWidgets('Từ vựng', (tester) async {
    final c = await _boot(tester);
    await _go(tester, c, Routes.vocab);
    await _shot(tester, '05_vocab');
    await _teardown(tester);
  });

  testWidgets('Flashcard', (tester) async {
    final c = await _boot(tester);
    await _go(tester, c, Routes.flashcards(), push: true);
    await tester.tap(find.text('Xem nghĩa'));
    await tester.pumpAndSettle();
    await _shot(tester, '06_flashcard');
    await _teardown(tester);
  });

  testWidgets('Tiến độ', (tester) async {
    final c = await _boot(tester);
    await _go(tester, c, Routes.history);
    await _shot(tester, '07_history');
    await _teardown(tester);
  });

  testWidgets('Thương Khung Bảng', (tester) async {
    final c = await _boot(tester);
    await _go(tester, c, Routes.leaderboard);
    await _shot(tester, '09_leaderboard');
    await _teardown(tester);
  });

  testWidgets('Danh sách đề – dark', (tester) async {
    await _boot(tester, brightness: Brightness.dark);
    await _shot(tester, '08_tests_dark');
    await _teardown(tester);
  });
}
