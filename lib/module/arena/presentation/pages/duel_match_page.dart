import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../helper/format.dart';
import '../../../../routes/app_router.dart';
import '../../../test/presentation/widgets/question_group_view.dart';
import '../../data/models/arena_models.dart';
import '../controllers/duel_controller.dart';
import '../widgets/arena_widgets.dart';

/// 1 trận đấu: chờ đối thủ → đếm ngược → 10 câu có giờ → kết quả.
class DuelMatchPage extends ConsumerWidget {
  const DuelMatchPage({super.key, required this.duelId});

  final String duelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = duelMatchProvider(duelId);
    final play = ref.watch(provider);
    final p = play.value;
    final status = p?.match.status;
    final inGame = status == DuelStatus.active && !(p?.doneAnswering ?? false);

    return PopScope(
      canPop: !inGame,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await showAppConfirmDialog(
          context,
          title: 'Bỏ trận?',
          message: 'Các câu chưa trả lời sẽ tính là sai.',
          confirmLabel: 'Bỏ trận',
          cancelLabel: 'Ở lại',
          destructive: true,
        );
        if (leave && context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Đấu 1 vs 1')),
        body: AsyncView(
          value: play,
          onRetry: () => ref.invalidate(provider),
          data: (p) => switch (p.match.status) {
            DuelStatus.waiting => _Waiting(play: p, duelId: duelId),
            DuelStatus.cancelled => const AppEmptyView(
              icon: Icons.event_busy_outlined,
              message: 'Trận đấu đã huỷ.',
            ),
            DuelStatus.finished => _Result(play: p),
            DuelStatus.active when !p.started => _Countdown(play: p),
            DuelStatus.active when p.doneAnswering => _WaitOpponent(play: p),
            DuelStatus.active => _Question(play: p, duelId: duelId),
          },
        ),
      ),
    );
  }
}

/// Hai thanh tiến độ: mình và đối thủ.
class _Scoreboard extends StatelessWidget {
  const _Scoreboard({required this.play});

  final DuelPlay play;

  @override
  Widget build(BuildContext context) {
    final m = play.match;
    Widget side(DuelSide s, {required bool me}) => LabeledProgress(
      label: me ? 'Bạn' : s.name,
      value: m.questionCount == 0 ? 0 : s.answered / m.questionCount,
      trailing: '${s.correct} đúng · ${s.answered}/${m.questionCount}',
      tone: me ? AppTone.info : AppTone.warning,
    );
    return AppCard(
      child: Column(
        children: [
          side(m.me, me: true),
          if (m.opponent case final o?) ...[Gaps.v12, side(o, me: false)],
        ],
      ),
    );
  }
}

class _Waiting extends ConsumerStatefulWidget {
  const _Waiting({required this.play, required this.duelId});

  final DuelPlay play;
  final String duelId;

  /// Chờ bấy nhiêu giây không ai vào thì gợi ý đấu với Bot.
  static const botAfter = 15;

  @override
  ConsumerState<_Waiting> createState() => _WaitingState();
}

class _WaitingState extends ConsumerState<_Waiting> {
  final _since = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final code = widget.play.match.code;
    final notifier = ref.read(duelMatchProvider(widget.duelId).notifier);
    return SecondTicker(
      builder: (context) {
        final waited = DateTime.now().difference(_since);
        return ListView(
          padding: AppInsets.screen,
          children: [
            Gaps.v24,
            const Center(child: CircularProgressIndicator()),
            Gaps.v24,
            Text(
              code == null ? 'Đang tìm đối thủ…' : 'Gửi mã này cho bạn của bạn',
              textAlign: TextAlign.center,
              style: context.textStyles.titleLarge,
            ),
            if (code != null) ...[
              Gaps.v16,
              Center(
                child: SelectableText(
                  code,
                  style: context.textStyles.displaySmall?.copyWith(
                    letterSpacing: AppSpacing.s8,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Gaps.v8,
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text('Chép lời mời'),
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: 'Đấu TOEIC với mình trên Bami TOEIC nhé! '
                            'Vào Bảng xếp hạng → Đấu 1 vs 1 → Nhập mã: $code',
                      ),
                    );
                    if (context.mounted) {
                      showAppSnackBar(context, 'Đã chép lời mời', tone: AppTone.success);
                    }
                  },
                ),
              ),
              Gaps.v8,
              Text(
                'Trận bắt đầu ngay khi bạn ấy nhập mã. Mã còn hiệu lực 30 phút.',
                textAlign: TextAlign.center,
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ] else ...[
              Gaps.v8,
              Text(
                'Đã chờ ${Fmt.clock(waited)}',
                textAlign: TextAlign.center,
                style: context.textStyles.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
            Gaps.v32,
            if (code == null && waited.inSeconds >= _Waiting.botAfter) ...[
              Text(
                'Chưa có ai đang tìm trận. Đấu với Bami Bot trong lúc chờ nhé?',
                textAlign: TextAlign.center,
                style: context.textStyles.bodyMedium,
              ),
              Gaps.v12,
              AppPrimaryButton(
                icon: Icons.smart_toy_outlined,
                label: 'Đấu với Bami Bot',
                onPressed: notifier.playBot,
              ),
              Gaps.v8,
            ],
            OutlinedButton(
              onPressed: () async {
                await notifier.cancel();
                if (context.mounted) context.pop();
              },
              child: const Text('Huỷ'),
            ),
          ],
        );
      },
    );
  }
}

class _Countdown extends StatelessWidget {
  const _Countdown({required this.play});

  final DuelPlay play;

  @override
  Widget build(BuildContext context) {
    return SecondTicker(
      builder: (context) {
        final left = play.countdown.inSeconds + 1;
        return Padding(
          padding: AppInsets.screen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Bạn vs ${play.match.opponent?.name ?? 'đối thủ'}',
                textAlign: TextAlign.center,
                style: context.textStyles.titleLarge,
              ),
              Gaps.v24,
              Text(
                '$left',
                textAlign: TextAlign.center,
                style: context.textStyles.displaySmall?.copyWith(color: context.colors.primary),
              ),
              Gaps.v8,
              Text(
                'Chuẩn bị! 10 câu Part 5, mỗi câu ${play.match.rules.secondsPerQuestion} giây.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Question extends ConsumerWidget {
  const _Question({required this.play, required this.duelId});

  final DuelPlay play;
  final String duelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = play.questions[play.index];
    final fb = play.feedback;
    final limit = Duration(seconds: play.match.rules.secondsPerQuestion);
    final started = play.questionStartedAt;
    final notifier = ref.read(duelMatchProvider(duelId).notifier);
    const letters = ['A', 'B', 'C', 'D'];

    return ListView(
      padding: AppInsets.screen,
      children: [
        _Scoreboard(play: play),
        Gaps.v16,
        Row(
          children: [
            Text(
              'Câu ${play.index + 1}/${play.questions.length}',
              style: context.textStyles.labelLarge,
            ),
            const Spacer(),
            if (started != null && fb == null)
              SecondTicker(
                builder: (context) {
                  final left = limit - DateTime.now().difference(started);
                  return StatusBadge(
                    label: '${left.isNegative ? 0 : left.inSeconds + 1} giây',
                    tone: left.inSeconds < 5 ? AppTone.danger : AppTone.info,
                    icon: Icons.timer_outlined,
                  );
                },
              ),
          ],
        ),
        if (started != null && fb == null) ...[
          Gaps.v8,
          // Thanh thời gian chạy đều tới 0 (chức năng, không phải hiệu ứng trang trí).
          TweenAnimationBuilder<double>(
            key: ValueKey('t${play.index}'),
            tween: Tween(begin: 1, end: 0),
            duration: _clamp(limit - DateTime.now().difference(started)),
            builder: (_, v, _) => AppProgressBar(
              value: v,
              tone: v < 0.25 ? AppTone.danger : AppTone.info,
            ),
          ),
        ],
        Gaps.v16,
        Text(q.content, style: context.textStyles.titleMedium),
        Gaps.v16,
        for (final (i, opt) in q.options.indexed) ...[
          AnswerOption(
            letter: letters[i],
            text: opt,
            selected: play.chosen == letters[i],
            result: fb == null
                ? null
                : letters[i] == fb.answer
                ? AppTone.success
                : play.chosen == letters[i]
                ? AppTone.danger
                : null,
            onTap: fb == null && !play.answering ? () => notifier.answer(letters[i]) : null,
          ),
          Gaps.v8,
        ],
        if (fb != null && play.chosen == null)
          AppBanner(message: 'Hết giờ · đáp án ${fb.answer}', tone: AppTone.warning),
      ],
    );
  }
}

Duration _clamp(Duration d) => d.isNegative ? Duration.zero : d;

class _WaitOpponent extends StatelessWidget {
  const _WaitOpponent({required this.play});

  final DuelPlay play;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppInsets.screen,
      children: [
        _Scoreboard(play: play),
        Gaps.v32,
        const Center(child: CircularProgressIndicator()),
        Gaps.v16,
        Text(
          'Bạn đã xong! Đang chờ ${play.match.opponent?.name ?? 'đối thủ'} hoàn thành…',
          textAlign: TextAlign.center,
          style: context.textStyles.titleMedium,
        ),
      ],
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({required this.play});

  final DuelPlay play;

  @override
  Widget build(BuildContext context) {
    final m = play.match;
    final (title, tone, icon) = switch (m.winner) {
      'me' => ('Bạn thắng!', AppTone.success, Icons.emoji_events_rounded),
      'opp' => ('Thua sát nút', AppTone.danger, Icons.sentiment_dissatisfied_outlined),
      'draw' => ('Hoà', AppTone.info, Icons.handshake_outlined),
      _ => ('Trận đã kết thúc', AppTone.neutral, Icons.flag_outlined),
    };
    String time(DuelSide s) => '${(s.timeMs / 1000).toStringAsFixed(1)} giây';

    return ListView(
      padding: AppInsets.screen,
      children: [
        Gaps.v16,
        Center(child: IconBadge(icon: icon, tone: tone, size: AppSizes.badgeLg)),
        Gaps.v12,
        Text(title, textAlign: TextAlign.center, style: context.textStyles.headlineSmall),
        Gaps.v24,
        AppListGroup(
          children: [
            ListTile(
              title: const Text('Bạn'),
              subtitle: Text(time(m.me)),
              trailing: Text(
                '${m.me.correct}/${m.questionCount}',
                style: context.textStyles.titleLarge,
              ),
            ),
            if (m.opponent case final o?)
              ListTile(
                title: Text(o.name),
                subtitle: Text(time(o)),
                trailing: Text(
                  '${o.correct}/${m.questionCount}',
                  style: context.textStyles.titleLarge,
                ),
              ),
          ],
        ),
        Gaps.v12,
        Text(
          'Đúng nhiều hơn thắng; bằng nhau thì tổng thời gian ít hơn thắng.',
          textAlign: TextAlign.center,
          style: context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
        ),
        Gaps.v24,
        AppPrimaryButton(
          icon: Icons.replay_rounded,
          label: 'Đấu trận mới',
          onPressed: () => context.pushReplacement(Routes.duelLobby),
        ),
      ],
    );
  }
}
