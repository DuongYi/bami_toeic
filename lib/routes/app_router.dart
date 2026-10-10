import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/design_system/gallery/ds_gallery_page.dart';
import '../module/auth/presentation/controllers/auth_controller.dart';
import '../module/auth/presentation/pages/forgot_password_page.dart';
import '../module/auth/presentation/pages/login_page.dart';
import '../module/auth/presentation/pages/splash_page.dart';
import '../module/debug/presentation/pages/log_viewer_page.dart';
import '../module/history/presentation/pages/history_page.dart';
import '../module/leaderboard/presentation/pages/leaderboard_page.dart';
import '../module/listening/presentation/pages/dictation_page.dart';
import '../module/listening/presentation/pages/listening_home_page.dart';
import '../module/plan/presentation/pages/admin_users_page.dart';
import '../module/profile/presentation/pages/profile_page.dart';
import '../module/settings/presentation/pages/settings_page.dart';
import '../module/shell/home_shell.dart';
import '../module/test/presentation/controllers/test_taking_controller.dart';
import '../module/test/presentation/pages/mistakes_page.dart';
import '../module/test/presentation/pages/result_page.dart';
import '../module/test/presentation/pages/test_detail_page.dart';
import '../module/test/presentation/pages/test_list_page.dart';
import '../module/test/presentation/pages/test_taking_page.dart';
import '../module/vocab/data/practice.dart';
import '../module/vocab/presentation/pages/flashcard_page.dart';
import '../module/vocab/presentation/pages/practice_page.dart';
import '../module/vocab/presentation/pages/vocab_words_page.dart';
import '../module/vocab/presentation/pages/vocab_page.dart';

part 'app_router.g.dart';

abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const forgotPasswordPath = '/forgot-password';
  static const tests = '/tests';
  static const vocab = '/vocab';
  static const history = '/history';
  static const leaderboard = '/leaderboard';
  static const adminUsers = '/admin/users';
  static const designSystem = '/design-system';
  static const mistakes = '/mistakes';
  static const listening = '/listening';
  static const debugLogs = '/debug/logs';
  static const profile = '/profile';
  static const settings = '/settings';

  static String forgotPassword({String? email}) => email == null || email.isEmpty
      ? forgotPasswordPath
      : '$forgotPasswordPath?email=${Uri.encodeQueryComponent(email)}';
  static String testDetail(String id) => '/tests/$id';
  static String take(String testId, {required String mode, required List<int> parts}) =>
      '/take/$testId?mode=$mode&parts=${parts.join(',')}';

  /// Luyện sổ câu sai; [filter]: "all" | "part:5" | "tag:word-form".
  static String takeMistakes({String filter = 'all'}) =>
      '/take/$kMistakesSession?mode=practice&parts=${Uri.encodeQueryComponent(filter)}';
  static String dictation(String testId, {required int part}) => '/listening/$testId?part=$part';
  static String result(String attemptId) => '/result/$attemptId';
  /// Bỏ "?" thừa khi không có tham số.
  static String _path(String path, Map<String, String> query) =>
      Uri(path: path, queryParameters: query.isEmpty ? null : query).toString();

  static String flashcards({String? deck, int extra = 0}) =>
      _path('/flashcards', {'deck': ?deck, if (extra > 0) 'extra': '$extra'});

  /// Danh sách từ của bộ [deck] ("topic:Office" / "test:3"); null = cả kho.
  static String vocabWords({String? deck}) => _path('/vocab-words', {'deck': ?deck});

  /// Luyện chủ động; [retry]: id các từ sai cần luyện lại (cách nhau dấu phẩy).
  static String vocabPractice(String mode, {String? retry}) =>
      _path('/vocab-practice', {'mode': mode, 'retry': ?retry});
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // Báo go_router chạy lại redirect mỗi khi trạng thái đăng nhập đổi.
  final authChanged = ValueNotifier(0);
  ref
    ..listen(authControllerProvider, (_, _) => authChanged.value++)
    ..onDispose(authChanged.dispose);

  final router = GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: authChanged,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final loc = state.matchedLocation;
      // Xem log được cả khi chưa đăng nhập (vd. lỗi đăng nhập)
      if (loc == Routes.debugLogs) return null;
      // Đang khôi phục phiên từ secure storage
      if (!auth.hasValue) return loc == Routes.splash ? null : Routes.splash;
      final loggedIn = auth.value != null;
      final authPage = loc == Routes.login || loc == Routes.forgotPasswordPath;
      if (!loggedIn) return authPage ? null : Routes.login;
      // Đăng nhập / đặt lại mật khẩu xong → vào app
      if (authPage || loc == Routes.splash) return Routes.tests;
      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),
      GoRoute(
        path: Routes.forgotPasswordPath,
        builder: (_, s) => ForgotPasswordPage(initialEmail: s.uri.queryParameters['email']),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.tests,
                builder: (_, _) => const TestListPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (_, s) => TestDetailPage(testId: s.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.vocab, builder: (_, _) => const VocabPage())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.history, builder: (_, _) => const HistoryPage())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.leaderboard, builder: (_, _) => const LeaderboardPage())],
          ),
        ],
      ),
      GoRoute(
        path: '/take/:testId',
        builder: (_, s) => TestTakingPage(
          testId: s.pathParameters['testId']!,
          mode: s.uri.queryParameters['mode'] ?? 'practice',
          parts: s.uri.queryParameters['parts'] ?? '1,2,3,4,5,6,7',
        ),
      ),
      GoRoute(path: Routes.mistakes, builder: (_, _) => const MistakesPage()),
      GoRoute(path: Routes.profile, builder: (_, _) => const ProfilePage()),
      GoRoute(path: Routes.settings, builder: (_, _) => const SettingsPage()),
      GoRoute(path: Routes.adminUsers, builder: (_, _) => const AdminUsersPage()),
      // Có cả ở bản release (không có nút nổi) để vẫn lấy được log khi cần.
      GoRoute(path: Routes.debugLogs, builder: (_, _) => const LogViewerPage()),
      GoRoute(
        path: Routes.listening,
        builder: (_, _) => const ListeningHomePage(),
        routes: [
          GoRoute(
            path: ':testId',
            builder: (_, s) => DictationPage(
              testId: s.pathParameters['testId']!,
              part: int.tryParse(s.uri.queryParameters['part'] ?? '') ?? 2,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/result/:attemptId',
        builder: (_, s) => ResultPage(attemptId: s.pathParameters['attemptId']!),
      ),
      if (kDebugMode) GoRoute(path: Routes.designSystem, builder: (_, _) => const DsGalleryPage()),
      GoRoute(
        path: '/flashcards',
        builder: (_, s) => FlashcardPage(
          deckKey: s.uri.queryParameters['deck'],
          extraNew: int.tryParse(s.uri.queryParameters['extra'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/vocab-words',
        builder: (_, s) => VocabWordsPage(deckKey: s.uri.queryParameters['deck']),
      ),
      GoRoute(
        path: '/vocab-practice',
        builder: (_, s) => PracticePage(
          mode: PracticeMode.values.asNameMap()[s.uri.queryParameters['mode']] ??
              PracticeMode.meaning,
          retryIds: s.uri.queryParameters['retry'] ?? '',
        ),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
