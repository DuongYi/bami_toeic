import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import 'goals_api.dart';
import 'study_store.dart';

part 'goals_repository.g.dart';

@Riverpod(keepAlive: true)
GoalsApi goalsApi(Ref ref) => GoalsApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
GoalsRepository goalsRepository(Ref ref) => GoalsRepository(ref.watch(goalsApiProvider));

class GoalsRepository {
  GoalsRepository(this._api);

  final GoalsApi _api;

  /// null = user chưa từng lưu mục tiêu trên server.
  Future<GoalSettings?> fetchGoals() async => (await _api.getGoals()).firstOrNull;

  Future<void> saveGoals(GoalSettings g) => _api.upsertGoals(GoalsUpsert(g));

  /// Số liệu từng ngày kể từ [since] (theo ngày "yyyy-mm-dd").
  Future<Map<String, DayLog>> fetchDays(DateTime since) async => {
    for (final r in await _api.getStudyDays(since: 'gte.${dayKey(since)}')) r.day: r.log,
  };

  Future<void> bump(String day, DayLog delta) => _api.bumpStudyDay(StudyDayBump(day, delta));
}
