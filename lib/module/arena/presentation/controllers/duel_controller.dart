import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/arena_repository.dart';
import '../../data/models/arena_models.dart';
import 'contest_controller.dart';

part 'duel_controller.freezed.dart';
part 'duel_controller.g.dart';

@riverpod
Future<DuelStats> duelStats(Ref ref) => ref.watch(arenaRepositoryProvider).duelStats();

@freezed
abstract class DuelPlay with _$DuelPlay {
  const DuelPlay._();

  const factory DuelPlay({
    required DuelState match,

    /// Lệch giờ máy so với server (giờ server ≈ now + offset).
    required Duration offset,
    @Default(<DuelQuestion>[]) List<DuelQuestion> questions,

    /// Câu đang làm (0-based); = số câu khi đã làm xong.
    @Default(0) int index,
    String? chosen,
    DuelAnswerResult? feedback,
    DateTime? questionStartedAt,
    @Default(false) bool answering,
  }) = _DuelPlay;

  DateTime get serverNow => DateTime.now().add(offset);

  /// Còn đếm ngược trước khi vào trận.
  Duration get countdown {
    final start = match.startedAt;
    if (start == null) return Duration.zero;
    final d = start.difference(serverNow);
    return d.isNegative ? Duration.zero : d;
  }

  bool get started => match.status == DuelStatus.active && countdown == Duration.zero;
  bool get doneAnswering => questions.isNotEmpty && index >= questions.length;
}

/// 1 trận đấu: hỏi trạng thái 1,5 giây/lần (tiến độ đối thủ), làm từng câu có giới hạn giờ.
@riverpod
class DuelMatch extends _$DuelMatch {
  Timer? _poll;
  Timer? _questionTimer;
  Timer? _nextTimer;

  static const _pollEvery = Duration(milliseconds: 1500); // ds-ignore: nhịp hỏi server, không phải animation
  static const _feedbackPause = Duration(milliseconds: 1200); // ds-ignore: thời gian xem đúng/sai

  ArenaRepository get _repo => ref.read(arenaRepositoryProvider);

  @override
  Future<DuelPlay> build(String duelId) async {
    ref.onDispose(() {
      _poll?.cancel();
      _questionTimer?.cancel();
      _nextTimer?.cancel();
    });
    final match = await _repo.duelState(duelId);
    final play = DuelPlay(match: match, offset: serverOffset(match.serverNow));
    _poll = Timer.periodic(_pollEvery, (_) => _refresh());
    return _withQuestions(play);
  }

  Future<DuelPlay> _withQuestions(DuelPlay p) async {
    if (p.questions.isNotEmpty || p.match.status == DuelStatus.waiting) return p;
    if (p.match.status == DuelStatus.cancelled) return p;
    final qs = await _repo.duelQuestions(duelId);
    // Vào lại giữa trận: tiếp tục từ câu chưa trả lời.
    return p.copyWith(questions: qs, index: p.match.me.answered.clamp(0, qs.length));
  }

  Future<void> _refresh() async {
    final cur = state.value;
    if (cur == null) return;
    if (cur.match.status == DuelStatus.finished || cur.match.status == DuelStatus.cancelled) {
      _poll?.cancel();
      return;
    }
    try {
      final match = await _repo.duelState(duelId);
      var next = (state.value ?? cur).copyWith(match: match, offset: serverOffset(match.serverNow));
      next = await _withQuestions(next);
      if (!ref.mounted) return;
      state = AsyncData(next);
      _armQuestionTimer();
    } catch (_) {
      // Mất mạng tạm thời: giữ trạng thái cũ, lần sau hỏi lại.
    }
  }

  /// Bắt đầu tính giờ câu hiện tại khi trận đã vào (sau đếm ngược).
  void _armQuestionTimer() {
    final p = state.value;
    if (p == null || !p.started || p.doneAnswering || p.questionStartedAt != null) return;
    if (p.feedback != null) return;
    state = AsyncData(p.copyWith(questionStartedAt: DateTime.now()));
    _questionTimer?.cancel();
    _questionTimer = Timer(Duration(seconds: p.match.rules.secondsPerQuestion), () => answer(null));
  }

  /// [letter] null = hết giờ câu này.
  Future<void> answer(String? letter) async {
    final p = state.value;
    if (p == null || !p.started || p.doneAnswering || p.answering || p.feedback != null) return;
    _questionTimer?.cancel();
    final q = p.questions[p.index];
    final ms = DateTime.now().difference(p.questionStartedAt ?? DateTime.now()).inMilliseconds;
    state = AsyncData(p.copyWith(chosen: letter, answering: true));
    try {
      final res = await _repo.answerDuel(duelId, q.n, letter, ms);
      if (!ref.mounted) return;
      state = AsyncData(state.value!.copyWith(feedback: res, answering: false));
      _nextTimer = Timer(_feedbackPause, _next);
    } catch (_) {
      if (!ref.mounted) return;
      // Trận đã kết thúc trên server (quá giờ) → để lần hỏi trạng thái sau chuyển màn kết quả.
      state = AsyncData(state.value!.copyWith(answering: false, index: p.questions.length));
      unawaited(_refresh());
    }
  }

  void _next() {
    final p = state.value;
    if (p == null) return;
    state = AsyncData(
      p.copyWith(index: p.index + 1, chosen: null, feedback: null, questionStartedAt: null),
    );
    _armQuestionTimer();
    unawaited(_refresh());
  }

  Future<void> playBot() async {
    await _repo.playBot(duelId);
    await _refresh();
  }

  Future<void> cancel() => _repo.cancelDuel(duelId);
}
