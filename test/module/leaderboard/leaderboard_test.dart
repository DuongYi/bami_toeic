import 'package:bami_toeic/module/leaderboard/data/models/leaderboard_models.dart';
import 'package:bami_toeic/module/leaderboard/data/realm.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Realm', () {
    test('ranh giới cảnh giới', () {
      expect(Realm.of(5), Realm.luyenKhi);
      expect(Realm.of(219), Realm.luyenKhi);
      expect(Realm.of(220), Realm.trucCo);
      expect(Realm.of(470), Realm.ketDan);
      expect(Realm.of(730), Realm.nguyenAnh);
      expect(Realm.of(860), Realm.hoaThan);
      expect(Realm.of(990), Realm.doKiep);
    });

    test('cảnh giới kế tiếp', () {
      expect(Realm.ketDan.next, Realm.nguyenAnh);
      expect(Realm.doKiep.next, isNull);
    });
  });

  test('đọc dòng leaderboard từ RPC (snake_case, rank null)', () {
    final e = LeaderboardEntry.fromJson({
      'rank': null,
      'user_id': 'u1',
      'display_name': 'Học viên AB12',
      'is_me': true,
      'best_score': null,
      'best_listening': null,
      'best_reading': null,
      'full_tests': 0,
      'week_questions': 40,
      'week_correct': 30,
    });
    expect(e.rank, isNull);
    expect(e.isMe, isTrue);
    expect(e.weekAccuracy, 0.75);
  });
}
