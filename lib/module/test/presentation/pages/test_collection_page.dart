import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../routes/app_router.dart';
import '../../../plan/presentation/controllers/plan_controller.dart';
import '../../../plan/presentation/widgets/pro_sheet.dart';
import '../../data/in_progress_store.dart';
import '../../data/models/test_models.dart';
import '../../data/test_catalog.dart';
import '../controllers/test_providers.dart';
import '../widgets/test_card.dart';
import '../widgets/test_collection_card.dart';

/// Một bộ đề (ETS 2024, Quick 15 phút, Part 5…): tiến độ cả bộ, danh sách đề theo thứ tự,
/// nút "Làm đề tiếp theo" (đề đang làm dở, rồi đến đề chưa làm đầu tiên).
class TestCollectionPage extends ConsumerWidget {
  const TestCollectionPage({super.key, required this.collectionId});

  final String collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(testListProvider);
    final attempts = ref.watch(attemptsProvider).value ?? const <Attempt>[];
    final inProgress =
        ref.watch(inProgressAllProvider).value ??
        const <String, TakingSnapshot>{};
    final plan = ref.watch(myPlanProvider).value;
    final entry = groupTests(tests.value ?? const [])
        .where((e) => e.collection.id == collectionId)
        .firstOrNull;
    final progress = entry == null
        ? null
        : CollectionProgress.of(entry.tests, attempts, inProgress.keys.toSet());
    final next = progress?.next;

    return Scaffold(
      appBar: AppBar(title: Text(entry?.collection.title ?? 'Bộ đề')),
      bottomNavigationBar: next == null
          ? null
          : AppBottomBar(
              child: AppPrimaryButton(
                label: inProgress.containsKey(next.id)
                    ? 'Làm tiếp · ${_shortTitle(next, entry!.collection)}'
                    : 'Làm đề tiếp theo · ${_shortTitle(next, entry!.collection)}',
                icon: isTestLocked(next, plan)
                    ? Icons.lock_outline_rounded
                    : Icons.play_arrow_rounded,
                onPressed: () => isTestLocked(next, plan)
                    ? showProSheet(context)
                    : context.push(Routes.testDetail(next.id)),
              ),
            ),
      body: AsyncView(
        value: tests,
        onRetry: () => ref.invalidate(testListProvider),
        data: (_) {
          if (entry == null || progress == null) {
            return const AppEmptyView(
              icon: Icons.folder_off_outlined,
              message:
                  'Bộ đề này không còn. Quay lại thư viện để chọn bộ khác.',
            );
          }
          return RefreshIndicator(
            onRefresh: () {
              ref
                ..invalidate(attemptsProvider)
                ..invalidate(inProgressAllProvider);
              return ref.refresh(testListProvider.future);
            },
            child: ListView(
              padding: AppInsets.screen,
              children: [
                _Header(collection: entry.collection, progress: progress),
                Gaps.v16,
                for (final t in entry.tests) ...[
                  TestCard(
                    test: t,
                    lastAttempt: attempts
                        .where((a) => a.testId == t.id && !a.isMistakeReview)
                        .firstOrNull,
                    inProgress: inProgress[t.id],
                    locked: isTestLocked(t, plan),
                  ),
                  Gaps.v12,
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  /// "ETS 2024 – Test 3" → "Test 3" cho nút ngắn gọn.
  static String _shortTitle(TestSummary t, TestCollection c) {
    final title = t.title;
    for (final sep in [' – ', ' - ', ' · ']) {
      final i = title.lastIndexOf(sep);
      if (i > 0) return title.substring(i + sep.length);
    }
    return title.startsWith(c.title)
        ? title.substring(c.title.length).trim()
        : title;
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.collection, required this.progress});

  final TestCollection collection;
  final CollectionProgress progress;

  @override
  Widget build(BuildContext context) {
    final (icon, tone) = collectionVisual(collection.kind);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadge(icon: icon, tone: tone, size: AppSizes.badgeLg),
              Gaps.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collection.title,
                      style: context.textStyles.titleMedium,
                    ),
                    Text(
                      collection.subtitle,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gaps.v16,
          // Tiến độ hoàn thành bộ đề, không phải điểm → giữ tone của bộ (không đổi đỏ khi mới làm ít).
          Row(
            children: [
              Expanded(child: Text(collectionCaption(progress))),
              Text(
                '${progress.done}/${progress.total}',
                style: context.textStyles.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Gaps.v8,
          AppProgressBar(
            value: progress.ratio,
            tone: tone,
            semanticLabel: 'Tiến độ bộ đề',
          ),
        ],
      ),
    );
  }
}
