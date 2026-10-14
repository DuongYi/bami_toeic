import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_controller.dart';
import 'biometric_login_controller.dart';

part 'login_controller.g.dart';

/// Trạng thái gửi form đăng nhập (loading / lỗi).
@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {}

  /// [enableBiometric]: người dùng tick "Đăng nhập bằng Face ID lần sau" → xác thực sinh trắc
  /// trước, đăng nhập thành công mới lưu thông tin (huỷ xác thực thì vẫn đăng nhập bình thường).
  Future<void> submit({
    required String email,
    required String password,
    bool enableBiometric = false,
  }) async {
    state = const AsyncLoading();
    // Notifier keepAlive: vẫn dùng được sau khi trang đăng nhập bị gỡ (điều hướng vào app).
    final biometric = ref.read(biometricLoginProvider.notifier);
    final result = await AsyncValue.guard(() async {
      final confirmed = enableBiometric && await biometric.confirmEnable();
      await ref.read(authControllerProvider.notifier).signIn(email: email, password: password);
      if (confirmed) await biometric.save(email: email, password: password);
    });
    if (ref.mounted) state = result;
  }

  /// Đăng nhập bằng Face ID / vân tay với thông tin đã lưu.
  Future<void> submitBiometric() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => ref.read(biometricLoginProvider.notifier).signIn());
    if (ref.mounted) state = result.whenData((_) {});
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
