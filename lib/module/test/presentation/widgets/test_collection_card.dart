import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';
import '../../data/test_catalog.dart';

/// Icon + tone của từng loại bộ đề (thẻ ở màn chủ và đầu trang bộ đề).
(IconData, AppTone) collectionVisual(CollectionKind kind) => switch (kind) {
  CollectionKind.ets => (Icons.workspace_premium_rounded, AppTone.info),
  CollectionKind.extreme => (
    Icons.local_fire_department_rounded,
    AppTone.danger,
  ),
  CollectionKind.quick => (Icons.bolt_rounded, AppTone.warning),
  CollectionKind.mini => (Icons.timer_outlined, AppTone.warning),
  CollectionKind.listening => (Icons.headphones_rounded, AppTone.success),
  CollectionKind.part5 => (Icons.spellcheck_rounded, AppTone.success),
  CollectionKind.part6 => (Icons.segment_rounded, AppTone.success),
  CollectionKind.part7 => (Icons.chrome_reader_mode_outlined, AppTone.success),
  CollectionKind.other => (Icons.folder_open_rounded, AppTone.neutral),
};

/// Một dòng tóm tắt tiến độ: "3/10 đề · TB 785 điểm", "Chưa làm đề nào".
String collectionCaption(CollectionProgress p) {
  if (p.done == 0) {
    return p.inProgress > 0
        ? '${p.inProgress} đề đang làm dở'
        : 'Chưa làm đề nào';
  }
  final avg = switch ((p.averageScore, p.averageRatio)) {
    (final s?, _) => ' · TB $s điểm',
    (_, final r?) => ' · TB ${(r * 100).round()}% đúng',
    _ => '',
  };
  return '${p.done}/${p.total} đề$avg';
}

/// Thẻ bộ đề trong lưới 2 cột ở màn chủ: icon, tên, mô tả, thanh tiến độ, số đề.
class TestCollectionCard extends StatelessWidget {
  const TestCollectionCard({
    super.key,
    required this.collection,
    required this.progress,
    required this.onTap,
    this.locked = false,
  });

  final TestCollection collection;
  final CollectionProgress progress;
  final VoidCallback onTap;

  /// Mọi đề trong bộ đều cần PRO.
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final (icon, tone) = collectionVisual(collection.kind);
    final caption = collectionCaption(progress);
    return Semantics(
      button: true,
      label: '${collection.title}, ${progress.total} đề, $caption',
      excludeSemantics: true,
      child: AppCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconBadge(icon: icon, tone: tone),
                const Spacer(),
                if (locked)
                  const ProBadge(label: 'PRO', mini: true)
                else
                  Text(
                    '${progress.total} đề',
                    style: context.textStyles.labelMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            Gaps.v12,
            Text(
              collection.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              collection.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Gaps.v12,
            AppProgressBar(
              value: progress.ratio,
              tone: tone,
              thickness: AppSizes.progressThin,
            ),
            Gaps.v4,
            Text(
              caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
