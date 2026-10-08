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

  @POST('/auth/v1/logout')
  Future<void> signOut();
}
