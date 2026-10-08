import 'package:dio/dio.dart';

/// Lỗi đã được chuẩn hoá để hiển thị cho người dùng.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  /// Chuyển mọi lỗi (DioException, AppException, khác) thành AppException.
  static AppException from(Object error) => switch (error) {
    AppException e => e,
    DioException(error: final AppException e) => e,
    DioException e => mapDio(e),
    _ => UnknownException(error.toString()),
  };

  static AppException mapDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const NetworkException('Máy chủ phản hồi quá lâu. Thử lại sau.');
      case DioExceptionType.connectionError:
        return const NetworkException('Không có kết nối mạng.');
      case DioExceptionType.cancel:
        return const UnknownException('Yêu cầu đã bị huỷ.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return UnknownException(e.message ?? 'Lỗi không xác định.');
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode ?? 0;
        final data = e.response?.data;
        // PostgREST không tìm thấy bảng/view → chưa chạy supabase/schema.sql.
        if (data is Map && data['code'] == 'PGRST205') {
          return ServerException(
            'Database chưa được khởi tạo. Mở Supabase → SQL Editor và chạy file supabase/schema.sql.',
            statusCode: status,
          );
        }
        final message = _extractMessage(e.response?.data) ?? 'Lỗi máy chủ ($status).';
        if (status == 401) return UnauthorizedException(message);
        if (status == 404) return NotFoundException(message);
        return ServerException(message, statusCode: status);
    }
  }

  /// Đọc message từ body lỗi của Supabase (PostgREST hoặc Auth).
  static String? _extractMessage(Object? data) {
    if (data is! Map) return null;
    for (final key in ['msg', 'message', 'error_description', 'error']) {
      final v = data[key];
      if (v is String && v.isNotEmpty) return v;
    }
    return null;
  }

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message);
}

class ServerException extends AppException {
  const ServerException(super.message, {required this.statusCode});

  final int statusCode;
}

class UnknownException extends AppException {
  const UnknownException(super.message);
}
