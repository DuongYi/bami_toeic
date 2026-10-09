import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../goals/data/study_store.dart';
import '../../data/auth_repository.dart';
import '../../data/models/session.dart';

part 'auth_controller.g.dart';

/// Nguồn sự thật duy nhất về trạng thái đăng nhập. `null` = chưa đăng nhập.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<Session?> build() async {
    try {
      return await ref.read(authRepositoryProvider).currentSession();
    } catch (_) {
      return null;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    final session = await ref.read(authRepositoryProvider).signIn(email: email, password: password);
    state = AsyncData(session);
  }

  /// true = đã đăng nhập luôn; false = cần xác nhận email rồi đăng nhập.
  Future<bool> signUp({required String email, required String password}) async {
    final session = await ref.read(authRepositoryProvider).signUp(email: email, password: password);
    if (session == null) return false;
    state = AsyncData(session);
    return true;
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    final session = await ref
        .read(authRepositoryProvider)
        .resetPassword(email: email, code: code, password: password);
    state = AsyncData(session);
  }

  Future<void> deleteAccount() async {
    await ref.read(authRepositoryProvider).deleteAccount();
    await ref.read(studyStoreProvider).onSignOut();
    state = const AsyncData(null);
  }

  Future<void> signOut() async {
    await ref.read(studyStoreProvider).onSignOut();
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }

  /// Gọi từ AuthInterceptor khi refresh token hết hạn.
  void onSessionExpired() => state = const AsyncData(null);
}

/// id user hiện tại (dùng khi ghi dữ liệu có cột user_id).
@riverpod
String? currentUserId(Ref ref) => ref.watch(authControllerProvider).value?.user.id;
