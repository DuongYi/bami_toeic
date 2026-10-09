import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_controller.dart';

part 'login_controller.g.dart';

/// Trạng thái gửi form đăng nhập (loading / lỗi).
@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {}

  Future<void> submit({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authControllerProvider.notifier).signIn(email: email, password: password),
    );
    if (ref.mounted) state = result;
  }

  /// true = cần mở email xác nhận rồi đăng nhập.
  Future<bool> register({required String email, required String password}) async {
    state = const AsyncLoading();
    var needsConfirm = false;
    final result = await AsyncValue.guard(() async {
      final signedIn = await ref
          .read(authControllerProvider.notifier)
          .signUp(email: email, password: password);
      needsConfirm = !signedIn;
    });
    if (ref.mounted) state = result;
    return !result.hasError && needsConfirm;
  }

  /// Ẩn thông báo lỗi khi người dùng sửa lại thông tin.
  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}
