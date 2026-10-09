import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/auth_repository.dart';
import 'auth_controller.dart';

part 'password_reset_controller.g.dart';

/// Trạng thái gửi mã / đặt lại mật khẩu (loading / lỗi) của màn Quên mật khẩu.
@riverpod
class PasswordResetController extends _$PasswordResetController {
  @override
  FutureOr<void> build() {}

  /// true = đã gửi email chứa mã.
  Future<bool> sendCode(String email) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).requestPasswordReset(email),
    );
    if (ref.mounted) state = result;
    return !result.hasError;
  }

  /// Thành công → AuthController có phiên mới, router tự chuyển vào app.
  Future<void> reset({
    required String email,
    required String code,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref
          .read(authControllerProvider.notifier)
          .resetPassword(email: email, code: code, password: password),
    );
    if (ref.mounted) state = result;
  }

  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}
