import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import 'models/plan_models.dart';
import 'plan_api.dart';

part 'plan_repository.g.dart';

@Riverpod(keepAlive: true)
PlanApi planApi(Ref ref) => PlanApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
PlanRepository planRepository(Ref ref) => PlanRepository(ref.watch(planApiProvider));

class PlanRepository {
  PlanRepository(this._api);

  final PlanApi _api;

  Future<MyPlan> fetchMyPlan() async => (await _api.getMyPlan()).firstOrNull ?? const MyPlan();

  Future<List<AdminUser>> listUsers(String query) =>
      _api.listUsers(AdminUserQuery(query.trim().isEmpty ? null : query.trim()));

  Future<DateTime?> grantPro(String userId, int days) async {
    final until = await _api.grantPro(GrantProBody(userId, days));
    return until == null ? null : DateTime.parse(until);
  }
}
