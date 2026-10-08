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
}
