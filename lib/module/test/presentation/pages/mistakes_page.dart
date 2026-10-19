import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../routes/app_router.dart';
import '../../data/models/test_models.dart';
import '../../data/question_tags.dart';
import '../controllers/test_providers.dart';
import '../widgets/question_group_view.dart';

/// Sổ câu sai: câu từng sai, gom theo Part và dạng câu, ôn theo lịch (1 → 3 → 7 → 21 ngày).
/// Làm đúng ở 3 ngày khác nhau → câu ra khỏi sổ. Kèm danh sách câu đã lưu.
class MistakesPage extends ConsumerWidget {
  const MistakesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mistakes = ref.watch(mistakesProvider);
    final saved = ref.watch(savedQuestionsProvider).value ?? const <SavedQuestion>[];
    final now = DateTime.now();
    final count = mistakes.value?.length ?? 0;
    final due = mistakes.value?.where((m) => m.isDue(now)).length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sổ câu sai'),
        actions: [
          IconButton(
            tooltip: 'Sổ tay lý thuyết & mẹo thi',
            icon: const Icon(Icons.auto_stories_rounded),
            onPressed: () => context.push(Routes.theory),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          ref.invalidate(savedQuestionsProvider);
          return ref.refresh(mistakesProvider.future);
        },
        child: AsyncView(
          value: mistakes,
          loading: (_) => const MistakesSkeleton(),
          onRetry: () => ref.invalidate(mistakesProvider),
          data: (list) => list.isEmpty && saved.isEmpty
              ? const ScrollableFill(
                  child: AppEmptyView(
                    icon: Icons.verified_rounded,
                    message:
                        'Sổ câu sai đang trống.\nCâu làm sai trong các đề sẽ hiện ở đây, '
                        'kèm lịch ôn lại để nhớ lâu.',
                  ),
                )
              : _MistakesBody(mistakes: list, saved: saved),
        ),
      ),
      bottomNavigationBar: count == 0
          ? null
          : AppBottomBar(
              child: due > 0
                  ? AppPrimaryButton(
                      icon: Icons.event_repeat_rounded,
                      label: 'Ôn $due câu đến hạn',
                      onPressed: () => context.push(Routes.takeMistakes(filter: 'due')),
                    )
                  : AppPrimaryButton(
                      icon: Icons.replay_rounded,
                      label: 'Luyện lại tất cả · $count câu',
                      onPressed: () => context.push(Routes.takeMistakes()),
                    ),
            ),
    );
  }
}

class _MistakesBody extends StatelessWidget {
  const _MistakesBody({required this.mistakes, required this.saved});

  final List<QuestionReview> mistakes;
  final List<SavedQuestion> saved;

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
    final now = DateTime.now();
    final due = mistakes.where((m) => m.isDue(now)).length;
    final reviewing = mistakes.where((m) => m.streak > 0).length;
    final fg = AppHeroCard.foreground(context);

    return ListView(
      padding: AppInsets.screen,
      children: [
        AppHeroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Đến hạn ôn hôm nay', style: context.textStyles.labelLarge?.copyWith(color: fg)),
              Gaps.v4,
              Text('$due', style: context.textStyles.displaySmall?.copyWith(color: fg)),
              Gaps.v8,
              Text(
                [
                  '${mistakes.length} câu trong sổ',
                  if (reviewing > 0) '$reviewing câu đang nhớ dần',
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
                  'Câu sai quay lại sau 1 ngày; làm đúng thì giãn ra 3 → 7 → 21 ngày. '
                  'Đúng ở 3 ngày khác nhau là đã thuộc, câu tự ra khỏi sổ.',
                  style: context.textStyles.bodySmall,
                ),
              ),
            ],
          ),
        ),
        Gaps.v12,
        AppCard(
          tone: AppTone.info,
          onTap: () => context.push(Routes.theory),
          child: Row(
            children: [
              const IconBadge(
                icon: Icons.menu_book_rounded,
                tone: AppTone.info,
                size: AppSizes.badgeMd,
              ),
              Gaps.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ôn lại lý thuyết nền tảng',
                      style: context.textStyles.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.v4,
                    Text(
                      'Xem lại các thì, mệnh đề, dạng từ và bẫy ETS để không lặp lại lỗi sai.',
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: context.colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
        if (saved.isNotEmpty) ...[
          Gaps.v16,
          const SectionHeader(title: 'Câu đã lưu'),
          AppListGroup(
            children: [
              _FilterTile(
                icon: Icons.bookmark_rounded,
                tone: AppTone.success,
                title: 'Luyện các câu đã lưu',
                count: saved.length,
                filter: 'saved',
              ),
            ],
          ),
        ],
        if (mistakes.isNotEmpty) ...[
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
