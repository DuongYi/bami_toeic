import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import 'models/plan_models.dart';

part 'plan_api.g.dart';

/// Gói Free / PRO. Quyền thật nằm ở RLS + hàm SQL; app chỉ đọc để hiện khoá / nhãn.
@RestApi()
abstract class PlanApi {
  factory PlanApi(Dio dio) = _PlanApi;

  @POST('/rest/v1/rpc/my_plan')
  Future<List<MyPlan>> getMyPlan();

  @POST('/rest/v1/rpc/admin_list_users')
  Future<List<AdminUser>> listUsers(@Body() AdminUserQuery body);

  /// Trả về hạn PRO mới (null = đã thu hồi).
  @POST('/rest/v1/rpc/admin_grant_pro')
  Future<String?> grantPro(@Body() GrantProBody body);
}

@JsonSerializable(createFactory: false)
class AdminUserQuery {
  AdminUserQuery(this.query);

  @JsonKey(name: 'p_query')
  final String? query;

  Map<String, dynamic> toJson() => _$AdminUserQueryToJson(this);
}

@JsonSerializable(createFactory: false)
class GrantProBody {
  GrantProBody(this.userId, this.days);

  @JsonKey(name: 'p_user_id')
  final String userId;

  /// <= 0: thu hồi PRO ngay.
  @JsonKey(name: 'p_days')
  final int days;

  Map<String, dynamic> toJson() => _$GrantProBodyToJson(this);
}
