import 'package:bami_toeic/core/design_system/design_system.dart';
import 'package:bami_toeic/module/arena/data/arena_repository.dart';
import 'package:bami_toeic/module/arena/data/models/arena_models.dart';
import 'package:bami_toeic/module/arena/presentation/pages/duel_match_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Trận giả: đối thủ người thật, 2 câu; trả lời xong cả 2 câu thì trận kết thúc.
class _FakeArena implements ArenaRepository {
  _FakeArena({required this.startIn});

  final Duration startIn;
  final answered = <int, String?>{};
  late final DateTime _start = DateTime.now().add(startIn);

  static const _questions = [
    DuelQuestion(n: 1, content: 'Q1 -------.', options: ['a', 'b', 'c', 'd']),
    DuelQuestion(n: 2, content: 'Q2 -------.', options: ['e', 'f', 'g', 'h']),
  ];

  @override
  Future<DuelState> duelState(String duelId) async {
    final correct = answered.entries.where((e) => e.value == 'B').length;
    final done = answered.length == 2;
    return DuelState(
      id: duelId,
      status: done ? DuelStatus.finished : DuelStatus.active,
      serverNow: DateTime.now(),
      startedAt: _start,
      questionCount: 2,
      me: DuelSide(name: 'Tôi', answered: answered.length, correct: correct, finished: done),
      opponent: const DuelSide(name: 'Lan', answered: 1, correct: 0),
      winner: done ? (correct > 0 ? 'me' : 'draw') : null,
    );
  }

  @override
  Future<List<DuelQuestion>> duelQuestions(String duelId) async => _questions;

  @override
  Future<DuelAnswerResult> answerDuel(String duelId, int n, String? chosen, int ms) async {
    answered[n] = chosen;
    return DuelAnswerResult(ok: chosen == 'B', answer: 'B');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('paperToGroups', () {
    test('đánh số c<n>, gắn đáp án khi có key', () {
      final groups = paperToGroups('x', const [
        PaperGroup(part: 5, questions: [PaperQuestion(n: 1, part: 5, content: 'A', options: ['1', '2', '3', '4'])]),
        PaperGroup(part: 7, passage: 'P', questions: [
          PaperQuestion(n: 2, part: 7, content: 'B'),
          PaperQuestion(n: 3, part: 7, content: 'C'),
        ]),
      ], key: const {'2': ReviewKey(a: 'C', e: 'vì…')});
      expect(groups, hasLength(2));
      expect(groups[1].questions.map((q) => q.id), ['c2', 'c3']);
      expect(groups[1].questions.first.answer, 'C');
      expect(groups[1].questions.first.explanation, 'vì…');
      expect(groups[0].questions.first.answer, ''); // đề thi: không có đáp án
    });
  });

  test('ContestInfo.phaseAt', () {
    final c = ContestInfo(
      id: '1',
      title: 't',
      startsAt: DateTime(2026, 10, 25, 20),
      endsAt: DateTime(2026, 10, 25, 20, 40),
      questionCount: 50,
    );
    expect(c.phaseAt(DateTime(2026, 10, 25, 19, 59)), ContestPhase.upcoming);
    expect(c.phaseAt(DateTime(2026, 10, 25, 20, 10)), ContestPhase.live);
    expect(c.phaseAt(DateTime(2026, 10, 25, 20, 40)), ContestPhase.finished);
  });

  testWidgets('Đấu 1 vs 1: đếm ngược → trả lời 2 câu → kết quả', (tester) async {
    final fake = _FakeArena(startIn: const Duration(seconds: 2));
    await tester.runAsync(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [arenaRepositoryProvider.overrideWithValue(fake)],
          child: MaterialApp(theme: AppTheme.light(), home: const DuelMatchPage(duelId: 'd1')),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await tester.pump();
      expect(find.text('Bạn vs Lan'), findsOneWidget);

      // Hết đếm ngược → lần hỏi trạng thái kế tiếp mở câu 1.
      await Future<void>.delayed(const Duration(seconds: 4));
      await tester.pump();
      expect(find.text('Q1 -------.'), findsOneWidget);
      await tester.tap(find.text('b'));
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await tester.pump();
      expect(fake.answered[1], 'B');

      // Sau 1,2 giây xem đúng/sai → câu 2.
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      await tester.pump();
      expect(find.text('Q2 -------.'), findsOneWidget);
      await tester.tap(find.text('e'));
      await Future<void>.delayed(const Duration(seconds: 3));
      await tester.pump();
      expect(find.text('Bạn thắng!'), findsOneWidget);
    });
    // Rời màn để huỷ timer hỏi trạng thái.
    await tester.pumpWidget(const SizedBox());
  });
}
