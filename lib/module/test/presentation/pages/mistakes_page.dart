import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../routes/app_router.dart';
import '../../data/models/test_models.dart';
import '../../data/question_tags.dart';
import '../controllers/test_providers.dart';
import '../widgets/question_group_view.dart';

/// Sổ câu sai: các câu sai/bỏ trống ở lần làm gần nhất, gom theo Part và dạng câu.
/// Làm đúng khi luyện lại → câu tự ra khỏi sổ.
class MistakesPage extends ConsumerWidget {
  const MistakesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mistakes = ref.watch(mistakesProvider);
    final count = mistakes.value?.length ?? 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Sổ câu sai')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(mistakesProvider.future),
        child: AsyncView(
          value: mistakes,
          onRetry: () => ref.invalidate(mistakesProvider),
          data: (list) => list.isEmpty
              ? const ScrollableFill(
                  child: AppEmptyView(
                    icon: Icons.verified_rounded,
                    message: 'Sổ câu sai đang trống.\nCâu làm sai trong các đề sẽ hiện ở đây.',
                  ),
                )
              : _MistakesBody(mistakes: list),
        ),
      ),
      bottomNavigationBar: count == 0
          ? null
          : AppBottomBar(
              child: AppPrimaryButton(
                icon: Icons.replay_rounded,
                label: 'Luyện lại tất cả · $count câu',
                onPressed: () => context.push(Routes.takeMistakes()),
              ),
            ),
    );
  }
}

class _MistakesBody extends StatelessWidget {
  const _MistakesBody({required this.mistakes});

  final List<LatestAnswer> mistakes;

  @override
  Widget build(BuildContext context) {
    final byPart = <int, int>{};
    final byTag = <String, int>{};
    for (final m in mistakes) {
      byPart.update(m.part, (v) => v + 1, ifAbsent: () => 1);
      for (final t in m.tags) {
        byTag.update(t, (v) => v + 1, ifAbsent: () => 1);
      }
    }
    final parts = byPart.keys.toList()..sort();
    final tags = byTag.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final skipped = mistakes.where((m) => m.chosen == null).length;
    final fg = AppHeroCard.foreground(context);

    return ListView(
      padding: AppInsets.screen,
      children: [
        AppHeroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Câu cần ôn lại', style: context.textStyles.labelLarge?.copyWith(color: fg)),
              Gaps.v4,
              Text(
                '${mistakes.length}',
                style: context.textStyles.displaySmall?.copyWith(color: fg),
              ),
              Gaps.v8,
              Text(
                [
                  '${mistakes.length - skipped} câu chọn sai',
                  if (skipped > 0) '$skipped câu bỏ trống',
                ].join(' · '),
                style: context.textStyles.bodySmall?.copyWith(color: fg),
              ),
            ],
          ),
        ),
        Gaps.v12,
        AppCard(
          tone: AppTone.info,
          child: Row(
            children: [
              Icon(
                Icons.tips_and_updates_outlined,
                color: context.colors.primary,
                size: AppSizes.iconMd,
              ),
              Gaps.h12,
              Expanded(
                child: Text(
                  'Luyện lại sổ câu sai thường xuyên giúp tăng ngay 50–100 điểm bằng cách triệt tiêu các bẫy đề thi lặp lại.',
                  style: context.textStyles.bodySmall,
                ),
              ),
            ],
          ),
        ),
        Gaps.v16,
        const SectionHeader(title: 'Theo Part'),
        AppListGroup(
          dividerIndent: AppSpacing.s16 + AppSizes.badgeMd + AppSpacing.s16,
          children: [
            for (final p in parts)
              _FilterTile(
                icon: p <= 4 ? Icons.headphones_rounded : Icons.chrome_reader_mode_outlined,
                title: partNames[p] ?? 'Part $p',
                count: byPart[p]!,
                filter: 'part:$p',
              ),
          ],
        ),
        if (tags.isNotEmpty) ...[
          Gaps.v24,
          const SectionHeader(title: 'Theo dạng câu', subtitle: 'Nhiều câu sai nhất ở trên'),
          AppListGroup(
            dividerIndent: AppSpacing.s16 + AppSizes.badgeMd + AppSpacing.s16,
            children: [
              for (final e in tags)
                _FilterTile(
                  icon: Icons.label_outline_rounded,
                  tone: AppTone.warning,
                  title: tagLabel(e.key),
                  count: e.value,
                  filter: 'tag:${e.key}',
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _FilterTile extends StatelessWidget {
  const _FilterTile({
    required this.icon,
    required this.title,
    required this.count,
    required this.filter,
    this.tone = AppTone.info,
  });

  final IconData icon;
  final String title;
  final int count;
  final String filter;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconBadge(icon: icon, tone: tone),
      title: Text(title),
      subtitle: Text('$count câu'),
      trailing: Icon(Icons.chevron_right_rounded, color: context.colors.onSurfaceVariant),
      onTap: () => context.push(Routes.takeMistakes(filter: filter)),
    );
  }
}
