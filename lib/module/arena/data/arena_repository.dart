import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import 'arena_api.dart';
import 'models/arena_models.dart';

part 'arena_repository.g.dart';

@Riverpod(keepAlive: true)
ArenaApi arenaApi(Ref ref) => ArenaApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
ArenaRepository arenaRepository(Ref ref) => ArenaRepository(ref.watch(arenaApiProvider));

class ArenaRepository {
  ArenaRepository(this._api);

  final ArenaApi _api;

  // ---------- Thi Chủ nhật ----------

  Future<ContestOverview> overview() => _api.contestOverview();

  Future<ContestPaper> join(String contestId) => _api.contestJoin({'p_contest': contestId});

  Future<void> saveDraft(String contestId, Map<String, String> answers) =>
      _api.contestSave({'p_contest': contestId, 'p_answers': answers});

  Future<ContestResult> submit(String contestId, Map<String, String> answers) =>
      _api.contestSubmit({'p_contest': contestId, 'p_answers': answers});

  Future<List<ContestRank>> board(String contestId, {int limit = 50}) =>
      _api.contestBoard({'p_contest': contestId, 'p_limit': limit});

  Future<ContestReview> review(String contestId) => _api.contestReview({'p_contest': contestId});

  // ---------- Đấu 1 vs 1 ----------

  Future<DuelRef> findDuel() => _api.duelFind();

  Future<DuelRef> inviteDuel() => _api.duelInvite();

  Future<DuelRef> joinDuel(String code) => _api.duelJoin({'p_code': code});

  Future<void> playBot(String duelId) => _api.duelVsBot({'p_duel': duelId});

  Future<void> cancelDuel(String duelId) => _api.duelCancel({'p_duel': duelId});

  Future<DuelState> duelState(String duelId) => _api.duelState({'p_duel': duelId});

  Future<List<DuelQuestion>> duelQuestions(String duelId) =>
      _api.duelQuestions({'p_duel': duelId});

  Future<DuelAnswerResult> answerDuel(String duelId, int n, String? chosen, int ms) =>
      _api.duelAnswer({'p_duel': duelId, 'p_n': n, 'p_chosen': chosen, 'p_ms': ms});

  Future<DuelStats> duelStats() => _api.duelStats();
}
