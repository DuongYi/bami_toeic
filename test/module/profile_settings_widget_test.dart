import 'package:bami_toeic/core/design_system/design_system.dart';
import 'package:bami_toeic/module/auth/data/models/session.dart';
import 'package:bami_toeic/module/auth/presentation/controllers/auth_controller.dart';
import 'package:bami_toeic/module/goals/data/study_store.dart';
import 'package:bami_toeic/module/goals/presentation/controllers/study_progress.dart';
import 'package:bami_toeic/module/leaderboard/data/models/leaderboard_models.dart';
import 'package:bami_toeic/module/leaderboard/presentation/controllers/leaderboard_controller.dart';
import 'package:bami_toeic/module/plan/data/models/plan_models.dart';
import 'package:bami_toeic/module/plan/presentation/controllers/plan_controller.dart';
import 'package:bami_toeic/module/profile/presentation/pages/profile_page.dart';
import 'package:bami_toeic/module/settings/presentation/controllers/settings_controller.dart';
import 'package:bami_toeic/module/settings/presentation/pages/settings_page.dart';
import 'package:bami_toeic/module/test/data/models/test_models.dart';
import 'package:bami_toeic/module/test/presentation/controllers/test_providers.dart';
import 'package:bami_toeic/module/vocab/data/models/vocab_models.dart';
import 'package:bami_toeic/module/vocab/data/vocab_decks.dart';
import 'package:bami_toeic/module/vocab/presentation/controllers/vocab_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildWrapper({
  required Widget child,
  ThemeData? theme,
}) {
  return ProviderScope(
    overrides: [
      authControllerProvider.overrideWith(() => _MockAuthController()),
      myPlanProvider.overrideWith(
        (ref) => Future.value(
          MyPlan(
            isPro: true,
            proUntil: DateTime.now().add(const Duration(days: 30)),
          ),
        ),
      ),
      studyProgressProvider.overrideWith(
        (ref) => Future.value(
          StudyProgress(
            streak: 5,
            activeToday: true,
            today: const DayLog(questions: 20, words: 15),
            goals: const GoalSettings(
              targetScore: 750,
              dailyQuestions: 20,
              dailyWords: 15,
              reminderMinutes: 1200,
            ),
            missions: const [],
            prediction: null,
          ),
        ),
      ),
      myLeaderboardProfileProvider.overrideWith(() => _MockLeaderboardProfile()),
      attemptsProvider.overrideWith(() => _MockAttempts()),
      vocabOverviewProvider.overrideWith(
        (ref) => const VocabOverview(
          items: <VocabItem>[],
          deck: null,
          deckStats: DeckStats(
            deck: null,
            total: 300,
            learning: 50,
            mastered: 150,
          ),
          bank: DeckStats(
            deck: null,
            total: 300,
            learning: 50,
            mastered: 150,
          ),
          decks: [],
          dueCount: 10,
          dailyNew: 15,
          newToday: 5,
          newLeft: 10,
          deckFreshLeft: 100,
        ),
      ),
    ],
    child: Consumer(
      builder: (context, ref, _) {
        final mode = ref.watch(appThemeModeProvider);
        return MaterialApp(
          theme: theme ?? AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: theme != null ? ThemeMode.light : mode,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(390, 844)),
            child: child,
          ),
        );
      },
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfilePage Widget Tests', () {
    testWidgets('ProfilePage render đầy đủ thông tin, không lỗi layout', (tester) async {
      await tester.pumpWidget(
        _buildWrapper(child: const ProfilePage()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Trang cá nhân'), findsOneWidget);
      expect(find.text('Đạo Hữu Test'), findsOneWidget);
      expect(find.text('test@bami.edu.vn'), findsOneWidget);
      expect(find.text('Thống kê học tập'), findsOneWidget);

      // Cuộn để render hết danh sách
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.text('Mục tiêu luyện thi'), findsOneWidget);
      expect(find.text('Học tập chuyên sâu'), findsOneWidget);
      expect(find.text('Tài khoản & ứng dụng'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('ProfilePage render mượt mà ở Dark Theme', (tester) async {
      await tester.pumpWidget(
        _buildWrapper(child: const ProfilePage(), theme: AppTheme.dark()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Trang cá nhân'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('SettingsPage Widget Tests', () {
    testWidgets('SettingsPage render đầy đủ các section cấu hình', (tester) async {
      await tester.pumpWidget(
        _buildWrapper(child: const SettingsPage()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cài đặt'), findsOneWidget);
      expect(find.text('Giao diện & hiển thị'), findsOneWidget);
      expect(find.text('Phông chữ ứng dụng'), findsOneWidget);

      // Cuộn để kiểm tra các mục tiếp theo (Nhắc nhở & Âm thanh)
      await tester.drag(find.byType(ListView), const Offset(0, -350));
      await tester.pumpAndSettle();

      expect(find.text('Nhắc nhở học tập'), findsOneWidget);

      // Cuộn tiếp để kiểm tra hồ sơ và dữ liệu
      await tester.drag(find.byType(ListView), const Offset(0, -450));
      await tester.pumpAndSettle();

      expect(find.text('Hồ sơ & bảng xếp hạng'), findsOneWidget);
      expect(find.text('Dữ liệu & bộ nhớ'), findsOneWidget);

      // Cuộn tiếp xuống đáy danh sách
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(find.text('Thông tin ứng dụng'), findsOneWidget);
      expect(find.text('Đăng xuất'), findsOneWidget);
      expect(find.text('Xoá tài khoản'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('SettingsPage cho phép chuyển đổi ThemeMode', (tester) async {
      await tester.pumpWidget(
        _buildWrapper(child: const SettingsPage()),
      );
      await tester.pumpAndSettle();

      // Bấm vào nút 'Tối'
      final darkButton = find.text('Tối');
      expect(darkButton, findsOneWidget);
      await tester.tap(darkButton);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    test('ThemeData.lerp mượt mà giữa Light và Dark Theme, không bị RangeError', () {
      final light = AppTheme.light();
      final dark = AppTheme.dark();
      for (var t = 0.0; t <= 1.0; t += 0.1) {
        final lerped = ThemeData.lerp(light, dark, t);
        expect(lerped, isNotNull);
        final surfaces = lerped.extension<AppSurfaces>();
        expect(surfaces, isNotNull);
        expect(surfaces!.hero, isNotEmpty);
      }
    });

    testWidgets('SettingsPage cho phép chuyển đổi Phông chữ ứng dụng', (tester) async {
      await tester.pumpWidget(
        _buildWrapper(child: const SettingsPage()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Be Vietnam Pro'), findsOneWidget);
      expect(find.text('Manrope'), findsOneWidget);
      expect(find.text('Mặc định hệ thống'), findsOneWidget);

      await tester.tap(find.text('Manrope'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Mặc định hệ thống'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Be Vietnam Pro'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}

class _MockAuthController extends AuthController {
  @override
  Future<Session?> build() async {
    return const Session(
      accessToken: 'dummy-token',
      refreshToken: 'dummy-refresh',
      expiresAt: 9999999999,
      user: AuthUser(id: 'test-user', email: 'test@bami.edu.vn'),
    );
  }
}

class _MockLeaderboardProfile extends MyLeaderboardProfile {
  @override
  Future<LeaderboardProfile> build() async {
    return const LeaderboardProfile(
      displayName: 'Đạo Hữu Test',
      showOnLeaderboard: true,
    );
  }

  @override
  Future<void> save(LeaderboardProfile profile) async {
    state = AsyncData(profile);
  }
}

class _MockAttempts extends Attempts {
  @override
  Future<List<Attempt>> build() async {
    return <Attempt>[];
  }
}
