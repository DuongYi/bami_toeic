import 'package:dio/dio.dart';

import '../../module/auth/data/models/session.dart';
import '../storage/token_storage.dart';

/// Gắn access token vào request; tự refresh khi token sắp hết hạn hoặc gặp 401.
///
/// Dùng [QueuedInterceptor] để khi nhiều request cùng gặp 401 thì chỉ refresh 1 lần.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this._storage,
    required this._refreshDio,
    required this._onSessionExpired,
  });

  /// Đặt `extra[skipAuth] = true` cho request không cần token (đăng nhập, refresh).
  static const skipAuth = 'skipAuth';
  static const _retried = 'authRetried';

  final TokenStorage _storage;
  final Dio _refreshDio;
  final void Function() _onSessionExpired;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra[skipAuth] == true) return handler.next(options);
    var session = await _storage.read();
    if (session != null && session.isExpiringSoon) {
      session = await _refresh(session);
    }
    if (session != null) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    if (err.response?.statusCode != 401 ||
        options.extra[skipAuth] == true ||
        options.extra[_retried] == true) {
      return handler.next(err);
    }

    var session = await _storage.read();
    if (session == null) return handler.next(err);

    // Nếu request khác trong hàng đợi đã refresh rồi thì chỉ cần gửi lại với token mới.
    final sentToken = options.headers['Authorization'];
    if (sentToken == 'Bearer ${session.accessToken}') {
      session = await _refresh(session);
      if (session == null) return handler.next(err);
    }

    try {
      options
        ..headers['Authorization'] = 'Bearer ${session.accessToken}'
        ..extra[_retried] = true;
      handler.resolve(await _refreshDio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  /// Trả về phiên mới; null nếu refresh token không còn hợp lệ (đã đăng xuất).
  /// Lỗi mạng thì giữ phiên cũ để không đá người dùng ra khi offline.
  Future<Session?> _refresh(Session session) async {
    try {
      final res = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/v1/token',
        queryParameters: {'grant_type': 'refresh_token'},
        data: {'refresh_token': session.refreshToken},
      );
      final next = Session.fromJson(res.data!);
      await _storage.save(next);
      return next;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status != null && status >= 400 && status < 500) {
        await _storage.clear();
        _onSessionExpired();
        return null;
      }
      return session;
    }
  }
}
