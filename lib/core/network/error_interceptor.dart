import 'package:dio/dio.dart';

import 'app_exception.dart';

/// Gắn [AppException] vào `DioException.error` để tầng trên chỉ cần đọc message.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.error is AppException) return handler.next(err);
    handler.next(err.copyWith(error: AppException.mapDio(err)));
  }
}
