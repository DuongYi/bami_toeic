import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../routes/app_router.dart';
import '../../../plan/presentation/controllers/plan_controller.dart';
import '../../../plan/presentation/widgets/pro_sheet.dart';
import '../../../test/presentation/controllers/test_providers.dart';
import '../../../test/presentation/widgets/question_group_view.dart';

/// Chọn đề + Part để luyện nghe chép chính tả.
class ListeningHomePage extends ConsumerStatefulWidget {
  const ListeningHomePage({super.key});

  @override
  ConsumerState<ListeningHomePage> createState() => _ListeningHomePageState();
}

class _ListeningHomePageState extends ConsumerState<ListeningHomePage> {
  int _part = 2;

  static const _hints = {
    1: 'Câu ngắn, dễ bắt đầu',
    2: 'Câu hỏi + 3 lời đáp, luyện phản xạ',
    3: 'Hội thoại dài, thử thách hơn',
    4: 'Bài nói một người, thử thách hơn',
  };

  @override
  Widget build(BuildContext context) {
    final tests = ref.watch(testListProvider);
    final plan = ref.watch(myPlanProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Luyện nghe')),
      body: AsyncView(
        value: tests,
        onRetry: () => ref.invalidate(testListProvider),
        data: (list) => ListView(
          padding: AppInsets.screen,
          children: [
            const AppBanner(
              message:
                  'Nghe từng đoạn, gõ lại những gì nghe được rồi bấm Kiểm tra. '
                  'Sau đó mở transcript và nói theo (shadowing) với tốc độ chậm.',
            ),
            Gaps.v24,
            const SectionHeader(title: 'Chọn Part'),
            for (final p in [1, 2, 3, 4]) ...[
              ChoiceCard(
                icon: Icons.headphones_rounded,
                title: partNames[p] ?? 'Part $p',
                subtitle: _hints[p],
                selected: _part == p,
                onTap: () => setState(() => _part = p),
              ),
              Gaps.v8,
            ],
            Gaps.v16,
            const SectionHeader(title: 'Chọn đề'),
            if (list.isEmpty)
              const AppEmptyView(icon: Icons.inbox_outlined, message: 'Chưa có đề nào.')
            else
              AppListGroup(
                dividerIndent: AppSpacing.s16 + AppSizes.badgeMd + AppSpacing.s16,
                children: [
                  for (final t in list)
                    if (isTestLocked(t, plan))
                      ListTile(
                        leading: const IconBadge(
                          icon: Icons.lock_outline_rounded,
                          tone: AppTone.neutral,
                        ),
                        title: Text(t.title),
                        trailing: const ProBadge(mini: true),
                        onTap: () => showProSheet(context),
                      )
                    else
                      ListTile(
                        leading: const IconBadge(icon: Icons.graphic_eq_rounded),
                        title: Text(t.title),
                        trailing: Icon(
                          Icons.chevron_right_rounded,
                          color: context.colors.onSurfaceVariant,
                        ),
                        onTap: () => context.push(Routes.dictation(t.id, part: _part)),
                      ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
