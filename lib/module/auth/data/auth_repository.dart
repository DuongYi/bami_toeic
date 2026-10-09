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
        'Email chưa được xác nhận. Vào Supabase → Authentication → Users để xác nhận tài khoản.',
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
