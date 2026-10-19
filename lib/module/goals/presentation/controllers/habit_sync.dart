import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/notifications/reminder_service.dart';
import '../../../vocab/presentation/controllers/vocab_controller.dart';
import 'study_progress.dart';

part 'habit_sync.g.dart';

/// Tình hình học hôm nay, gom cho nhắc học thông minh và widget màn hình chính.
@riverpod
Future<HabitStatus> habitStatus(Ref ref) async {
  final p = await ref.watch(studyProgressProvider.future);
  final due = await ref
      .watch(vocabOverviewProvider.future)
      .then((o) => o.dueCount, onError: (_) => 0);
  return HabitStatus(
    day: DateTime.now(),
    studiedToday: p.activeToday,
    streak: p.streak,
    dueWords: due,
    missionsDone: p.missionsDone,
    missionsTotal: p.missions.length,
  );
}
