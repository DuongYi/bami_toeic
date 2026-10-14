import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_auth.g.dart';

@Riverpod(keepAlive: true)
BiometricAuth biometricAuth(Ref ref) => BiometricAuth(LocalAuthentication());

/// Loại sinh trắc có trên máy – quyết định nhãn hiển thị ("Face ID", "Touch ID", "vân tay").
enum BiometricKind {
  faceId('Face ID'),
  touchId('Touch ID'),
  fingerprint('vân tay'),
  face('khuôn mặt');

  const BiometricKind(this.label);

  final String label;
}

/// Xác thực bằng Face ID / Touch ID / vân tay (gói local_auth), chạy hoàn toàn trên máy.
class BiometricAuth {
  BiometricAuth(this._auth);

  final LocalAuthentication _auth;

  /// Máy có phần cứng sinh trắc (kể cả khi chưa đăng ký khuôn mặt / vân tay).
  Future<bool> hasHardware() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  /// Loại sinh trắc đã đăng ký trên máy; null = không có / chưa đăng ký.
  Future<BiometricKind?> availableKind() async {
    try {
      if (!await _auth.isDeviceSupported() || !await _auth.canCheckBiometrics) return null;
      final types = await _auth.getAvailableBiometrics();
      final ios = defaultTargetPlatform == TargetPlatform.iOS;
      if (types.contains(BiometricType.face)) return ios ? BiometricKind.faceId : BiometricKind.face;
      if (types.contains(BiometricType.fingerprint)) {
        return ios ? BiometricKind.touchId : BiometricKind.fingerprint;
      }
      // Android chỉ báo "strong"/"weak" mà không nói loại cụ thể.
      if (types.contains(BiometricType.strong) || types.contains(BiometricType.weak)) {
        return BiometricKind.fingerprint;
      }
      return null;
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null; // test / nền tảng không có plugin
    }
  }

  /// true = người dùng xác thực thành công; false = tự huỷ.
  /// Lỗi khác (khoá tạm thời, chưa đăng ký…) ném [BiometricException] với thông báo tiếng Việt.
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason, biometricOnly: true);
    } on LocalAuthException catch (e) {
      return switch (e.code) {
        LocalAuthExceptionCode.userCanceled ||
        LocalAuthExceptionCode.systemCanceled ||
        LocalAuthExceptionCode.userRequestedFallback ||
        LocalAuthExceptionCode.timeout => false,
        LocalAuthExceptionCode.temporaryLockout ||
        LocalAuthExceptionCode.biometricLockout => throw const BiometricException(
          'Sinh trắc học đang bị khoá do thử sai nhiều lần. Mở khoá máy bằng mật mã rồi thử lại, '
          'hoặc đăng nhập bằng mật khẩu.',
        ),
        LocalAuthExceptionCode.noBiometricsEnrolled ||
        LocalAuthExceptionCode.noCredentialsSet ||
        LocalAuthExceptionCode.noBiometricHardware => throw const BiometricException(
          'Máy chưa cài đặt Face ID / vân tay. Bật trong Cài đặt của máy hoặc đăng nhập bằng mật khẩu.',
        ),
        _ => throw const BiometricException(
          'Không xác thực được. Thử lại hoặc đăng nhập bằng mật khẩu.',
        ),
      };
    }
  }
}

class BiometricException implements Exception {
  const BiometricException(this.message);

  final String message;

  @override
  String toString() => message;
}
