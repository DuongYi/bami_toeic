import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/biometric/biometric_auth.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/storage/credential_storage.dart';
import 'auth_controller.dart';

part 'biometric_login_controller.g.dart';

/// Trạng thái đăng nhập bằng sinh trắc trên máy này.
class BiometricStatus {
  const BiometricStatus({this.kind, this.email, this.hasHardware = false});

  /// Loại sinh trắc có trên máy; null = không dùng được (ẩn mọi lối vào).
  final BiometricKind? kind;

  /// Email đã lưu để đăng nhập nhanh; null = chưa bật.
  final String? email;

  /// Máy có Face ID / vân tay nhưng có thể chưa đăng ký → Cài đặt hiện công tắc bị khoá kèm hướng dẫn.
  final bool hasHardware;

  /// Có phần cứng nhưng chưa đăng ký khuôn mặt / vân tay trong Cài đặt của máy.
  bool get needsEnrollment => hasHardware && !available;

  bool get available => kind != null;
  bool get enabled => available && email != null;

  /// "Face ID", "Touch ID", "vân tay"…
  String get label => kind?.label ?? 'sinh trắc học';
}

/// Đăng nhập bằng Face ID / Touch ID / vân tay: lưu email + mật khẩu trong Keychain khi người dùng
/// bật, lần sau xác thực sinh trắc rồi đăng nhập bằng thông tin đó. Đăng xuất vẫn giữ để đăng nhập
/// lại nhanh; xoá tài khoản hoặc tắt trong Cài đặt thì xoá.
@Riverpod(keepAlive: true)
class BiometricLogin extends _$BiometricLogin {
  @override
  Future<BiometricStatus> build() async {
    // Quay lại app (vd. vừa cài Face ID trong Cài đặt của máy) → kiểm tra lại.
    final lifecycle = AppLifecycleListener(onResume: ref.invalidateSelf);
    ref.onDispose(lifecycle.dispose);
    final bio = ref.read(biometricAuthProvider);
    final kind = await bio.availableKind();
    if (kind == null) return BiometricStatus(hasHardware: await bio.hasHardware());
    final saved = await ref.read(credentialStorageProvider).read();
    return BiometricStatus(kind: kind, email: saved?.email, hasHardware: true);
  }

  /// Hỏi xác thực sinh trắc trước khi bật (cũng là lúc iOS xin quyền Face ID).
  /// false = người dùng huỷ hoặc máy không xác thực được → không bật, không chặn việc khác.
  Future<bool> confirmEnable() async {
    final status = await future;
    if (!status.available) return false;
    try {
      return await ref
          .read(biometricAuthProvider)
          .authenticate('Xác nhận để bật đăng nhập bằng ${status.label}');
    } on BiometricException {
      return false;
    }
  }

  /// Lưu thông tin đăng nhập (gọi sau khi đăng nhập bằng mật khẩu thành công).
  Future<void> save({required String email, required String password}) async {
    await ref.read(credentialStorageProvider).save(email: email, password: password);
    final status = await future;
    state = AsyncData(BiometricStatus(kind: status.kind, email: email, hasHardware: status.hasHardware));
  }

  /// Bật từ Cài đặt: kiểm tra mật khẩu của tài khoản đang đăng nhập với máy chủ, xác thực sinh trắc,
  /// rồi lưu. false = người dùng huỷ xác thực. Sai mật khẩu → ném lỗi của đăng nhập.
  Future<bool> enableWithPassword(String password) async {
    final email = ref.read(authControllerProvider).value?.user.email;
    if (email == null) return false;
    await ref.read(authControllerProvider.notifier).signIn(email: email, password: password);
    if (!await confirmEnable()) return false;
    await save(email: email, password: password);
    return true;
  }

  Future<void> disable() async {
    await ref.read(credentialStorageProvider).clear();
    final status = await future;
    state = AsyncData(BiometricStatus(kind: status.kind, hasHardware: status.hasHardware));
  }

  /// Đổi mật khẩu thành công → cập nhật mật khẩu đã lưu nếu đang bật cho đúng email đó.
  Future<void> onPasswordChanged({required String email, required String password}) async {
    final status = await future;
    if (status.enabled && status.email == email) await save(email: email, password: password);
  }

  /// Xác thực sinh trắc rồi đăng nhập. false = người dùng huỷ.
  /// Mật khẩu đã lưu không còn đúng (đổi ở máy khác) → xoá và báo đăng nhập bằng mật khẩu.
  Future<bool> signIn() async {
    final status = await future;
    if (!status.enabled) return false;
    final ok = await ref.read(biometricAuthProvider).authenticate('Đăng nhập Bami TOEIC');
    if (!ok) return false;
    final saved = await ref.read(credentialStorageProvider).read();
    if (saved == null) {
      await disable();
      throw const UnauthorizedException('Chưa có thông tin đăng nhập đã lưu. Đăng nhập bằng mật khẩu.');
    }
    try {
      await ref.read(authControllerProvider.notifier).signIn(email: saved.email, password: saved.password);
    } on UnauthorizedException {
      await disable();
      throw UnauthorizedException(
        'Mật khẩu đã thay đổi. Đăng nhập bằng mật khẩu mới, rồi bật lại ${status.label}.',
      );
    }
    return true;
  }
}
