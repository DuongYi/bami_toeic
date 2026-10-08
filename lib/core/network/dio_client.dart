import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/env.dart';
import '../../module/auth/presentation/controllers/auth_controller.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';

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
  // Dio riêng không có interceptor, dùng để refresh token và gửi lại request.
  final plainDio = Dio(_baseOptions());

  dio.interceptors.addAll([
    AuthInterceptor(
      storage: ref.watch(tokenStorageProvider),
      refreshDio: plainDio,
      onSessionExpired: () => ref.read(authControllerProvider.notifier).onSessionExpired(),
    ),
    ErrorInterceptor(),
    if (kDebugMode)
      LogInterceptor(
        requestHeader: false,
        responseHeader: false,
        requestBody: true,
        logPrint: (o) => debugPrint('[dio] $o'),
      ),
  ]);

  ref.onDispose(() {
    dio.close();
    plainDio.close();
  });
  return dio;
}
