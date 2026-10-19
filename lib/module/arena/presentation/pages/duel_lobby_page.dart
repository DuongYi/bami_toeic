import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../routes/app_router.dart';
import '../../../plan/presentation/widgets/pro_sheet.dart';
import '../../data/arena_repository.dart';
import '../../data/models/arena_models.dart';
import '../controllers/duel_controller.dart';

/// Sảnh Đấu 1 vs 1: tìm đối thủ ngẫu nhiên, mời bạn bằng mã, nhập mã của bạn.
class DuelLobbyPage extends ConsumerStatefulWidget {
  const DuelLobbyPage({super.key});

  @override
  ConsumerState<DuelLobbyPage> createState() => _DuelLobbyPageState();
}

class _DuelLobbyPageState extends ConsumerState<DuelLobbyPage> {
  bool _busy = false;

  Future<void> _start(Future<DuelRef> Function(ArenaRepository repo) open) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final duel = await open(ref.read(arenaRepositoryProvider));
      if (!mounted) return;
      await context.push(Routes.duel(duel.id));
      ref.invalidate(duelStatsProvider);
    } catch (e) {
      if (!mounted) return;
      final message = AppException.from(e).message;
      showAppSnackBar(
        context,
        message,
        tone: AppTone.danger,
        actionLabel: message.contains('PRO') ? 'Nâng cấp' : null,
        onAction: message.contains('PRO') ? () => showProSheet(context) : null,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _enterCode() async {
    final code = await showAppBottomSheet<String>(context, builder: (_) => const _CodeSheet());
    if (code != null && code.trim().isNotEmpty) await _start((r) => r.joinDuel(code));
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(duelStatsProvider);
    final s = stats.value;
    final fg = AppHeroCard.foreground(context);
    final noneLeft = s?.leftToday == 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Đấu 1 vs 1')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(duelStatsProvider.future),
        child: ListView(
          padding: AppInsets.screen,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            AppHeroCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thành tích', style: context.textStyles.labelLarge?.copyWith(color: fg)),
                  Gaps.v8,
                  Row(
                    children: [
                      for (final (label, value) in [
                        ('Thắng', s?.wins),
                        ('Thua', s?.losses),
                        ('Hoà', s?.draws),
                      ])
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${value ?? '–'}',
                                style: context.textStyles.headlineSmall?.copyWith(color: fg),
                              ),
                              Text(label, style: context.textStyles.bodySmall?.copyWith(color: fg)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  Gaps.v12,
                  Text(
                    switch (s?.leftToday) {
                      _ when s == null => '',
                      null => 'PRO · đấu không giới hạn',
                      0 => 'Hết lượt miễn phí hôm nay',
                      final n => 'Còn $n trận miễn phí hôm nay',
                    },
                    style: context.textStyles.bodySmall?.copyWith(color: fg),
                  ),
                ],
              ),
            ),
            Gaps.v16,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (i, (icon, text)) in const [
                    (Icons.bolt_rounded, '10 câu Part 5, mỗi câu tối đa 20 giây.'),
                    (Icons.visibility_outlined, 'Thấy tiến độ của đối thủ theo thời gian thực.'),
                    (Icons.emoji_events_outlined, 'Đúng nhiều hơn thắng; bằng nhau thì ai nhanh hơn.'),
                    (Icons.smart_toy_outlined, 'Không ai ghép trong 15 giây thì đấu với Bami Bot.'),
                  ].indexed) ...[
                    if (i > 0) Gaps.v8,
                    IconLabel(icon: icon, label: text, style: context.textStyles.bodyMedium),
                  ],
                ],
              ),
            ),
            if (noneLeft) ...[
              Gaps.v16,
              UpgradeBanner(
                title: 'Hết 3 trận miễn phí hôm nay',
                description: 'Nâng cấp PRO để đấu không giới hạn và luyện phản xạ Part 5 mỗi ngày.',
                onUpgrade: () => showProSheet(context),
              ),
            ],
            Gaps.v24,
            FilledButton.tonalIcon(
              icon: const Icon(Icons.group_add_outlined),
              label: const Text('Mời bạn bằng mã'),
              onPressed: _busy || noneLeft ? null : () => _start((r) => r.inviteDuel()),
            ),
            Gaps.v8,
            OutlinedButton.icon(
              icon: const Icon(Icons.keyboard_outlined),
              label: const Text('Nhập mã của bạn'),
              onPressed: _busy || noneLeft ? null : _enterCode,
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        child: AppPrimaryButton(
          icon: Icons.sports_kabaddi_outlined,
          label: 'Tìm đối thủ',
          loading: _busy,
          onPressed: noneLeft ? null : () => _start((r) => r.findDuel()),
        ),
      ),
    );
  }
}

class _CodeSheet extends StatefulWidget {
  const _CodeSheet();

  @override
  State<_CodeSheet> createState() => _CodeSheetState();
}

class _CodeSheetState extends State<_CodeSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.pop(context, _controller.text.trim().toUpperCase());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.screen,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Nhập mã thách đấu', style: context.textStyles.titleLarge),
          Gaps.v12,
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            maxLength: 6,
            decoration: const InputDecoration(labelText: 'Mã 6 ký tự', hintText: 'VD: K7QX2M'),
            onSubmitted: (_) => _submit(),
          ),
          Gaps.v8,
          AppPrimaryButton(label: 'Vào trận', onPressed: _submit),
        ],
      ),
    );
  }
}
