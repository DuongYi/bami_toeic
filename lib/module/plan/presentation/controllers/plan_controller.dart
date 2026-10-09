import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../test/data/models/test_models.dart';
import '../../data/models/plan_models.dart';
import '../../data/plan_repository.dart';

part 'plan_controller.g.dart';

/// Gói của user đang đăng nhập; tự tải lại khi đổi tài khoản.
@Riverpod(keepAlive: true)
Future<MyPlan> myPlan(Ref ref) async {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return const MyPlan();
  return ref.watch(planRepositoryProvider).fetchMyPlan();
}

/// Đề bị khoá với user hiện tại. Chưa biết gói (đang tải / offline) thì KHÔNG khoá:
/// RLS trên server mới là lớp chặn thật, app không được chặn nhầm đề đã tải offline.
bool isTestLocked(TestSummary test, MyPlan? plan) => !test.isFree && plan != null && !plan.isPro;

@riverpod
Future<List<AdminUser>> adminUsers(Ref ref, String query) =>
    ref.watch(planRepositoryProvider).listUsers(query);
