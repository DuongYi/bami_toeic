import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/network/auth_interceptor.dart';
import 'models/session.dart';

part 'auth_api.g.dart';

/// Supabase Auth (GoTrue) REST API.
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('/auth/v1/token')
  @Extra({AuthInterceptor.skipAuth: true})
  Future<Session> signInWithPassword(
    @Body() Map<String, dynamic> body, {
    @Query('grant_type') String grantType = 'password',
  });

  /// Tắt "Confirm email" → trả về phiên (có access_token); bật → chỉ trả về user, cần xác nhận email.
  @POST('/auth/v1/signup')
  @Extra({AuthInterceptor.skipAuth: true})
  Future<dynamic> signUp(@Body() Map<String, dynamic> body);

  /// Xoá vĩnh viễn tài khoản hiện tại và toàn bộ dữ liệu học (hàm SQL delete_my_account).
  @POST('/rest/v1/rpc/delete_my_account')
  Future<void> deleteAccount();

  @POST('/auth/v1/logout')
  Future<void> signOut();
}
