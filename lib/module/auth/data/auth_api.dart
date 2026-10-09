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

  /// Gửi email đặt lại mật khẩu (template "Reset Password" cần có {{ .Token }} để hiện mã).
  /// Email không tồn tại vẫn trả 200 – không lộ ai đã đăng ký.
  @POST('/auth/v1/recover')
  @Extra({AuthInterceptor.skipAuth: true})
  Future<void> recover(@Body() Map<String, dynamic> body);

  /// Đổi mã OTP lấy phiên (type = 'recovery').
  @POST('/auth/v1/verify')
  @Extra({AuthInterceptor.skipAuth: true})
  Future<Session> verifyOtp(@Body() Map<String, dynamic> body);

  /// Đổi mật khẩu bằng token truyền tay: phiên chỉ được lưu sau khi đổi xong.
  @PUT('/auth/v1/user')
  @Extra({AuthInterceptor.skipAuth: true})
  Future<void> updatePassword(
    @Header('Authorization') String bearer,
    @Body() Map<String, dynamic> body,
  );

  /// Xoá vĩnh viễn tài khoản hiện tại và toàn bộ dữ liệu học (hàm SQL delete_my_account).
  @POST('/rest/v1/rpc/delete_my_account')
  Future<void> deleteAccount();

  @POST('/auth/v1/logout')
  Future<void> signOut();
}
