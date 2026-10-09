import 'package:bami_toeic/module/auth/presentation/controllers/auth_controller.dart';
import 'package:bami_toeic/module/goals/data/goals_repository.dart';
import 'package:bami_toeic/module/goals/data/study_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Server giả: cộng dồn như RPC bump_study_day; [online] = false để giả lập mất mạng.
class _FakeServer implements GoalsRepository {
  final days = <String, DayLog>{};
  GoalSettings? goals;
  bool online = true;

  void _check() {
    if (!online) throw Exception('offline');
  }

  @override
  Future<void> bump(String day, DayLog delta) async {
    _check();
    days[day] = (days[day] ?? const DayLog()) + delta;
  }

  @override
  Future<Map<String, DayLog>> fetchDays(DateTime since) async {
    _check();
    return {...days};
  }

  @override
  Future<GoalSettings?> fetchGoals() async {
    _check();
    return goals;
  }

  @override
  Future<void> saveGoals(GoalSettings g) async {
    _check();
    goals = g;
  }
}

ProviderContainer _container(_FakeServer server, String uid) => ProviderContainer(
  overrides: [
    goalsRepositoryProvider.overrideWithValue(server),
    currentUserIdProvider.overrideWithValue(uid),
  ],
);

void main() {
  final today = dayKey(DateTime.now());

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('mất mạng vẫn đếm trên máy, có mạng thì gửi phần còn thiếu', () async {
    final server = _FakeServer()..online = false;
    final c = _container(server, 'u1');
    addTearDown(c.dispose);
    final store = c.read(studyStoreProvider);

    await store.record(StudyEvent.questions, 3);
    await store.record(StudyEvent.words);
    expect((await store.readLog())[today]?.questions, 3);
    expect(server.days, isEmpty);

    server.online = true;
    final log = await store.readLog();
    expect(server.days[today], const DayLog(questions: 3, words: 1));
    expect(log[today], const DayLog(questions: 3, words: 1)); // không đếm trùng
  });

  test('máy khác đã học → gộp số liệu từ server', () async {
    final server = _FakeServer()..days[today] = const DayLog(questions: 10);
    final c = _container(server, 'u1');
    addTearDown(c.dispose);
    final store = c.read(studyStoreProvider);
    await store.record(StudyEvent.questions, 2);
    expect((await store.readLog())[today]?.questions, 12);
  });

  test('dữ liệu tách theo user', () async {
    final s1 = _FakeServer()..online = false;
    final c1 = _container(s1, 'u1');
    await c1.read(studyStoreProvider).record(StudyEvent.dictations, 4);
    c1.dispose();

    final c2 = _container(_FakeServer()..online = false, 'u2');
    addTearDown(c2.dispose);
    expect((await c2.read(studyStoreProvider).readLog())[today], isNull);
  });

  test('nhật ký cũ (chưa gắn user) chuyển sang user đầu tiên và được gửi lên', () async {
    SharedPreferences.setMockInitialValues({
      'study/log': '{"$today": {"questions": 5}}',
      'study/goals': '{"target_score": 750}',
    });
    final server = _FakeServer();
    final c = _container(server, 'u1');
    addTearDown(c.dispose);
    final store = c.read(studyStoreProvider);

    expect((await store.readLog())[today]?.questions, 5);
    expect(server.days[today]?.questions, 5);
    expect((await store.readGoals()).targetScore, 750);
    expect(server.goals?.targetScore, 750);
  });
}
