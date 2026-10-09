import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_models.freezed.dart';
part 'plan_models.g.dart';

/// Gói của user hiện tại (hàm SQL `my_plan`). Admin luôn có quyền PRO.
@freezed
abstract class MyPlan with _$MyPlan {
  const factory MyPlan({
    @Default(false) bool isPro,
    @Default(false) bool isAdmin,
    DateTime? proUntil,
  }) = _MyPlan;

  factory MyPlan.fromJson(Map<String, dynamic> json) => _$MyPlanFromJson(json);
}

/// 1 dòng của hàm SQL `admin_list_users` (chỉ admin gọi được).
@freezed
abstract class AdminUser with _$AdminUser {
  const AdminUser._();

  const factory AdminUser({
    required String userId,
    String? email,
    required DateTime createdAt,
    DateTime? lastSignInAt,
    @Default(false) bool isAdmin,
    DateTime? proUntil,
  }) = _AdminUser;

  factory AdminUser.fromJson(Map<String, dynamic> json) => _$AdminUserFromJson(json);

  bool isProAt(DateTime now) => isAdmin || (proUntil?.isAfter(now) ?? false);
}
