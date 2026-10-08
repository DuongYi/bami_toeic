import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

/// Phiên đăng nhập trả về từ `POST /auth/v1/token`.
@freezed
abstract class Session with _$Session {
  const Session._();

  const factory Session({
    required String accessToken,
    required String refreshToken,

    /// Unix time (giây)
    required int expiresAt,
    required AuthUser user,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  bool get isExpiringSoon =>
      DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000)
          .isBefore(DateTime.now().add(const Duration(seconds: 60)));
}

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({required String id, String? email}) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);
}
