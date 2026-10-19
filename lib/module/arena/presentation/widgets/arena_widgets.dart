import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../helper/format.dart';
import '../../../../routes/app_router.dart';
import '../../data/models/arena_models.dart';
import '../controllers/contest_controller.dart';
import '../controllers/duel_controller.dart';

/// Dựng lại mỗi giây (đồng hồ đếm ngược). Tự huỷ timer khi rời màn.
class SecondTicker extends StatefulWidget {
  const SecondTicker({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  State<SecondTicker> createState() => _SecondTickerState();
}

class _SecondTickerState extends State<SecondTicker> {
  late final Timer _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}

/// "Còn 2 ngày 05:12:09" / "Còn 12:09".
String countdownLabel(Duration d) {
  if (d.isNegative) return '00:00';
  final days = d.inDays;
  final rest = Fmt.clock(d - Duration(days: days));
  return days > 0 ? '$days ngày $rest' : rest;
}

/// Đếm ngược gọn cho thẻ nhỏ: "Còn 5 ngày" / "Còn 03:12:09".
String _short(Duration d) => d.inDays > 0 ? 'Còn ${d.inDays} ngày' : 'Còn ${Fmt.clock(d)}';

/// "20:00 Chủ nhật 25/10".
String contestSlotLabel(DateTime startsAt) {
  final t = startsAt.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(t.hour)}:${two(t.minute)} Chủ nhật ${two(t.day)}/${two(t.month)}';
}

/// Lối vào Đấu trường: Thi Chủ nhật (đếm ngược / đang thi) + Đấu 1 vs 1.
class ArenaShortcuts extends ConsumerWidget {
  const ArenaShortcuts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(contestOverviewProvider).value;
    final stats = ref.watch(duelStatsProvider).value;
    final current = overview?.current;
    final offset = overview == null ? Duration.zero : serverOffset(overview.serverNow);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _ShortcutCard(
              icon: Icons.emoji_events_outlined,
              tone: AppTone.warning,
              title: 'Thi Chủ nhật',
              subtitle: SecondTicker(
                builder: (context) {
                  if (current == null) return const Text('Chủ nhật 20:00');
                  final now = DateTime.now().add(offset);
                  return Text(switch (current.phaseAt(now)) {
                    ContestPhase.upcoming =>
                      _short(current.startsAt.difference(now)),
                    ContestPhase.live =>
                      current.submitted ? 'Xem hạng' : 'Đang mở phòng!',
                    ContestPhase.finished => 'Xem kết quả',
                  });
                },
              ),
              live: current != null &&
                  current.phaseAt(DateTime.now().add(offset)) == ContestPhase.live,
              onTap: () => context.push(Routes.contest),
            ),
          ),
          Gaps.h12,
          Expanded(
            child: _ShortcutCard(
              icon: Icons.sports_kabaddi_outlined,
              tone: AppTone.danger,
              title: 'Đấu 1 vs 1',
              subtitle: Text(switch (stats) {
                null => '10 câu tốc độ',
                DuelStats(wins: 0, losses: 0, draws: 0) => '10 câu tốc độ',
                final s => '${s.wins} thắng · ${s.losses} thua',
              }),
              onTap: () => context.push(Routes.duelLobby),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.icon,
    required this.tone,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.live = false,
  });

  final IconData icon;
  final AppTone tone;
  final String title;
  final Widget subtitle;
  final VoidCallback onTap;
  final bool live;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      tone: live ? AppTone.info : null,
      child: Row(
        children: [
          IconBadge(icon: icon, tone: tone),
          Gaps.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: context.textStyles.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (live) ...[
                      Gaps.h4,
                      const StatusBadge(label: 'LIVE', tone: AppTone.danger),
                    ],
                  ],
                ),
                DefaultTextStyle.merge(
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                  child: subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
