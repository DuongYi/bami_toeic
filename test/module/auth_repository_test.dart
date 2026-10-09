import 'package:bami_toeic/core/network/app_exception.dart';
import 'package:bami_toeic/module/auth/data/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _err(int status, Object? body) {
  final req = RequestOptions(path: '/auth/v1/token');
  return DioException(
    requestOptions: req,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: req, statusCode: status, data: body),
  );
}

void main() {
  group('AuthRepository.mapSignInError', () {
    test('sai email / mật khẩu (định dạng mới error_code)', () {
      final e = AuthRepository.mapSignInError(
        _err(400, {
          'code': 400,
          'error_code': 'invalid_credentials',
          'msg': 'Invalid login credentials',
        }),
      );
      expect(e, isA<UnauthorizedException>());
      expect(e.message, 'Email hoặc mật khẩu không đúng.');
    });

    test('sai email / mật khẩu (định dạng cũ invalid_grant)', () {
      final e = AuthRepository.mapSignInError(
        _err(400, {'error': 'invalid_grant', 'error_description': 'Invalid login credentials'}),
      );
      expect(e.message, 'Email hoặc mật khẩu không đúng.');
    });

    test('email chưa xác nhận', () {
      final e = AuthRepository.mapSignInError(_err(400, {'error_code': 'email_not_confirmed'}));
      expect(e.message, contains('chưa được xác nhận'));
    });

    test('quá nhiều lần thử (429)', () {
      final e = AuthRepository.mapSignInError(_err(429, {'msg': 'rate limited'}));
      expect(e, isA<ServerException>());
      expect(e.message, contains('quá nhiều lần'));
    });

    test('body lỗi lạ (error_code không phải chuỗi) không làm crash', () {
      final e = AuthRepository.mapSignInError(
        _err(500, {
          'error_code': 123,
          'error': {'x': 1},
        }),
      );
      expect(e, isA<ServerException>());
    });

    test('mất mạng → NetworkException', () {
      final e = AuthRepository.mapSignInError(
        DioException(
          requestOptions: RequestOptions(path: '/auth/v1/token'),
          type: DioExceptionType.connectionError,
        ),
      );
      expect(e, isA<NetworkException>());
    });
  });

  group('AuthRepository.mapPasswordResetError', () {
    test('mã sai / hết hạn', () {
      final e = AuthRepository.mapPasswordResetError(
        _err(403, {'error_code': 'otp_expired', 'msg': 'Token has expired or is invalid'}),
      );
      expect(e.message, contains('hết hạn'));
    });

    test('mật khẩu mới trùng mật khẩu cũ', () {
      final e = AuthRepository.mapPasswordResetError(_err(422, {'error_code': 'same_password'}));
      expect(e.message, 'Mật khẩu mới phải khác mật khẩu cũ.');
    });

    test('gửi mã quá nhanh (429)', () {
      final e = AuthRepository.mapPasswordResetError(
        _err(429, {'error_code': 'over_email_send_rate_limit'}),
      );
      expect(e, isA<ServerException>());
      expect(e.message, contains('1 phút'));
    });
  });
}
