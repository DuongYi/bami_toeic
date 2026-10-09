import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/token_storage.dart';
import 'auth_api.dart';
import 'models/session.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthApi authApi(Ref ref) => AuthApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(authApiProvider), ref.watch(tokenStorageProvider));

class AuthRepository {
  AuthRepository(this._api, this._storage);

  final AuthApi _api;
  final TokenStorage _storage;

  Future<Session?> currentSession() => _storage.read();

  Future<Session> signIn({required String email, required String password}) async {
    try {
      final session = await _api.signInWithPassword({'email': email, 'password': password});
      await _storage.save(session);
      return session;
    } on DioException catch (e) {
      throw mapSignInError(e);
    }
  }

  /// null = đã tạo tài khoản nhưng cần mở email xác nhận trước khi đăng nhập.
  Future<Session?> signUp({required String email, required String password}) async {
    try {
      final json = await _api.signUp({'email': email, 'password': password});
      if (json is! Map<String, dynamic> || json['access_token'] == null) return null;
      final session = Session.fromJson(json);
      await _storage.save(session);
      return session;
    } on DioException catch (e) {
      throw mapSignUpError(e);
    }
  }

  static AppException mapSignUpError(DioException e) {
    final data = e.response?.data;
    final rawCode = data is Map ? (data['error_code'] ?? data['code']) : null;
    final code = rawCode is String ? rawCode : null;
    final msg = data is Map ? '${data['msg'] ?? data['message'] ?? ''}' : '';
    return switch (code) {
      'user_already_exists' || 'email_exists' => const UnauthorizedException(
        'Email này đã có tài khoản. Chuyển sang Đăng nhập.',
      ),
      'weak_password' => const UnauthorizedException(
        'Mật khẩu quá yếu. Dùng ít nhất 8 ký tự, có chữ và số.',
      ),
      'signup_disabled' => const ForbiddenException('Hiện chưa mở đăng ký tài khoản mới.'),
      'email_address_invalid' => const UnauthorizedException('Email không hợp lệ.'),
      'over_email_send_rate_limit' || 'over_request_rate_limit' => const ServerException(
        'Gửi quá nhiều yêu cầu. Đợi vài phút rồi thử lại.',
        statusCode: 429,
      ),
      _ when msg.contains('Signups not allowed') => const ForbiddenException(
        'Hiện chưa mở đăng ký tài khoản mới.',
      ),
      _ => AppException.from(e),
    };
  }

  Future<void> requestPasswordReset(String email) async {
    try {
      await _api.recover({'email': email});
    } on DioException catch (e) {
      throw mapPasswordResetError(e);
    }
  }

  /// Xác nhận mã trong email rồi đặt mật khẩu mới; thành công thì đăng nhập luôn.
  Future<Session> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    try {
      final session = await _api.verifyOtp({'type': 'recovery', 'email': email, 'token': code});
      await _api.updatePassword('Bearer ${session.accessToken}', {'password': password});
      await _storage.save(session);
      return session;
    } on DioException catch (e) {
      throw mapPasswordResetError(e);
    }
  }

  static AppException mapPasswordResetError(DioException e) {
    final data = e.response?.data;
    final rawCode = data is Map ? (data['error_code'] ?? data['code']) : null;
    final code = rawCode is String ? rawCode : null;
    final msg = data is Map ? '${data['msg'] ?? data['message'] ?? ''}' : '';
    if (code == 'otp_expired' || msg.contains('expired or is invalid')) {
      return const UnauthorizedException('Mã không đúng hoặc đã hết hạn. Gửi lại mã mới.');
    }
    if (code == 'same_password') {
      return const UnauthorizedException('Mật khẩu mới phải khác mật khẩu cũ.');
    }
    if (code == 'weak_password') {
      return const UnauthorizedException('Mật khẩu quá yếu. Dùng ít nhất 8 ký tự, có chữ và số.');
    }
    if (e.response?.statusCode == 429 ||
        code == 'over_email_send_rate_limit' ||
        code == 'over_request_rate_limit') {
      return const ServerException(
        'Vừa gửi mã gần đây. Đợi khoảng 1 phút rồi gửi lại.',
        statusCode: 429,
      );
    }
    return AppException.from(e);
  }

  Future<void> deleteAccount() async {
    await _api.deleteAccount();
    await _storage.clear();
  }

  /// Đổi lỗi của Supabase Auth sang thông báo tiếng Việt dễ hiểu.
  static AppException mapSignInError(DioException e) {
    final data = e.response?.data;
    // Không ép kiểu trực tiếp: body lỗi lạ (số, object) không được làm crash luồng đăng nhập.
    final rawCode = data is Map ? (data['error_code'] ?? data['error']) : null;
    final code = rawCode is String ? rawCode : null;
    final msg = data is Map ? '${data['msg'] ?? data['error_description'] ?? ''}' : '';
    final status = e.response?.statusCode;

    if (code == 'invalid_credentials' ||
        code == 'invalid_grant' ||
        msg.contains('Invalid login credentials')) {
      return const UnauthorizedException('Email hoặc mật khẩu không đúng.');
    }
    if (code == 'email_not_confirmed') {
      return const UnauthorizedException(
        'Email chưa được xác nhận. Mở email xác nhận Bami TOEIC đã gửi rồi đăng nhập lại.',
      );
    }
    if (status == 429 || code == 'over_request_rate_limit') {
      return const ServerException(
        'Thử đăng nhập quá nhiều lần. Đợi vài phút rồi thử lại.',
        statusCode: 429,
      );
    }
    return AppException.from(e);
  }

  Future<void> signOut() async {
    try {
      await _api.signOut();
    } catch (_) {
      // Vẫn xoá phiên cục bộ dù server lỗi / offline.
    }
    await _storage.clear();
  }
}
