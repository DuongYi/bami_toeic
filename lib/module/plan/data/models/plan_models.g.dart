// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyPlan _$MyPlanFromJson(Map<String, dynamic> json) => _MyPlan(
  isPro: json['is_pro'] as bool? ?? false,
  isAdmin: json['is_admin'] as bool? ?? false,
  proUntil: json['pro_until'] == null
      ? null
      : DateTime.parse(json['pro_until'] as String),
);

Map<String, dynamic> _$MyPlanToJson(_MyPlan instance) => <String, dynamic>{
  'is_pro': instance.isPro,
  'is_admin': instance.isAdmin,
  'pro_until': instance.proUntil?.toIso8601String(),
};

_AdminUser _$AdminUserFromJson(Map<String, dynamic> json) => _AdminUser(
  userId: json['user_id'] as String,
  email: json['email'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  lastSignInAt: json['last_sign_in_at'] == null
      ? null
      : DateTime.parse(json['last_sign_in_at'] as String),
  isAdmin: json['is_admin'] as bool? ?? false,
  proUntil: json['pro_until'] == null
      ? null
      : DateTime.parse(json['pro_until'] as String),
);

Map<String, dynamic> _$AdminUserToJson(_AdminUser instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'created_at': instance.createdAt.toIso8601String(),
      'last_sign_in_at': instance.lastSignInAt?.toIso8601String(),
      'is_admin': instance.isAdmin,
      'pro_until': instance.proUntil?.toIso8601String(),
    };
