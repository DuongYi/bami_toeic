import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/env.dart';
import '../../module/auth/presentation/controllers/auth_controller.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'network_log_interceptor.dart';

part 'dio_client.g.dart';

BaseOptions _baseOptions() => BaseOptions(
  baseUrl: Env.supabaseUrl,
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 30),
  contentType: Headers.jsonContentType,
  headers: {'apikey': Env.supabaseKey},
);

/// Dio dùng chung cho toàn app (Supabase REST, Auth).
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(_baseOptions());
  // Dio phụ (không có AuthInterceptor) để refresh token và gửi lại request sau 401.
  final plainDio = Dio(_baseOptions());

  dio.interceptors.addAll([
    AuthInterceptor(
      storage: ref.watch(tokenStorageProvider),
      refreshDio: plainDio,
      onSessionExpired: () => ref.read(authControllerProvider.notifier).onSessionExpired(),
    ),
    ErrorInterceptor(),
    // Sau Auth + Error: thấy header thật (đã che) và message lỗi đã dịch. Xem ở màn Nhật ký debug.
    NetworkLogInterceptor(),
  ]);
  // Refresh token + gửi lại request sau 401 đi qua Dio phụ → cũng ghi log.
  plainDio.interceptors.addAll([ErrorInterceptor(), NetworkLogInterceptor(tag: 'auth')]);

  ref.onDispose(() {
    dio.close();
    plainDio.close();
  });
  return dio;
}
