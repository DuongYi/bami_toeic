import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/supabase.dart';
import '../module/auth/login_page.dart';
import '../module/history/history_page.dart';
import '../module/shell/home_shell.dart';
import '../module/test/pages/result_page.dart';
import '../module/test/pages/test_detail_page.dart';
import '../module/test/pages/test_list_page.dart';
import '../module/test/pages/test_taking_page.dart';
import '../module/vocab/pages/flashcard_page.dart';
import '../module/vocab/pages/vocab_page.dart';

class Routes {
  static const login = '/login';
  static const tests = '/tests';
  static const vocab = '/vocab';
  static const history = '/history';

  static String testDetail(String id) => '/tests/$id';
  static String take(String testId, {required String mode, required List<int> parts}) =>
      '/take/$testId?mode=$mode&parts=${parts.join(',')}';
  static String result(String attemptId) => '/result/$attemptId';
  static String flashcards({String? topic}) =>
      topic == null ? '/flashcards' : '/flashcards?topic=${Uri.encodeQueryComponent(topic)}';
}

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(supabaseProvider).auth;
  final refresh = _StreamListenable(auth.onAuthStateChange);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: Routes.tests,
    refreshListenable: refresh,
    redirect: (context, state) {
      final loggedIn = auth.currentSession != null;
      final atLogin = state.matchedLocation == Routes.login;
      if (!loggedIn) return atLogin ? null : Routes.login;
      if (atLogin) return Routes.tests;
      return null;
    },
    routes: [
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
          parts: (s.uri.queryParameters['parts'] ?? '1,2,3,4,5,6,7')
              .split(',')
              .map(int.parse)
              .toList(),
        ),
      ),
      GoRoute(
        path: '/result/:attemptId',
        builder: (_, s) => ResultPage(attemptId: s.pathParameters['attemptId']!),
      ),
      GoRoute(
        path: '/flashcards',
        builder: (_, s) => FlashcardPage(topic: s.uri.queryParameters['topic']),
      ),
    ],
  );
});

class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
