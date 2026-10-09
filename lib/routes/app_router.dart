import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/design_system/gallery/ds_gallery_page.dart';
import '../module/auth/presentation/controllers/auth_controller.dart';
import '../module/auth/presentation/pages/login_page.dart';
import '../module/auth/presentation/pages/splash_page.dart';
import '../module/history/presentation/pages/history_page.dart';
import '../module/shell/home_shell.dart';
import '../module/test/presentation/controllers/test_taking_controller.dart';
import '../module/test/presentation/pages/mistakes_page.dart';
import '../module/test/presentation/pages/result_page.dart';
import '../module/test/presentation/pages/test_detail_page.dart';
import '../module/test/presentation/pages/test_list_page.dart';
import '../module/test/presentation/pages/test_taking_page.dart';
import '../module/vocab/presentation/pages/flashcard_page.dart';
import '../module/vocab/presentation/pages/vocab_page.dart';

part 'app_router.g.dart';

abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const tests = '/tests';
  static const vocab = '/vocab';
  static const history = '/history';
  static const designSystem = '/design-system';
  static const mistakes = '/mistakes';

  static String testDetail(String id) => '/tests/$id';
  static String take(String testId, {required String mode, required List<int> parts}) =>
      '/take/$testId?mode=$mode&parts=${parts.join(',')}';

  /// Luyện sổ câu sai; [filter]: "all" | "part:5" | "tag:word-form".
  static String takeMistakes({String filter = 'all'}) =>
      '/take/$kMistakesSession?mode=practice&parts=${Uri.encodeQueryComponent(filter)}';
  static String result(String attemptId) => '/result/$attemptId';
  static String flashcards({String? topic}) =>
      topic == null ? '/flashcards' : '/flashcards?topic=${Uri.encodeQueryComponent(topic)}';
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
      // Đang khôi phục phiên từ secure storage
      if (!auth.hasValue) return loc == Routes.splash ? null : Routes.splash;
      final loggedIn = auth.value != null;
      if (!loggedIn) return loc == Routes.login ? null : Routes.login;
      if (loc == Routes.login || loc == Routes.splash) return Routes.tests;
      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),
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
      GoRoute(
        path: '/result/:attemptId',
        builder: (_, s) => ResultPage(attemptId: s.pathParameters['attemptId']!),
      ),
      if (kDebugMode) GoRoute(path: Routes.designSystem, builder: (_, _) => const DsGalleryPage()),
      GoRoute(
        path: '/flashcards',
        builder: (_, s) => FlashcardPage(topic: s.uri.queryParameters['topic']),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
