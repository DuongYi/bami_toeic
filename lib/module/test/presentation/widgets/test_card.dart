import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../routes/app_router.dart';
import '../../../plan/presentation/widgets/pro_sheet.dart';
import '../../data/in_progress_store.dart';
import '../../data/models/test_models.dart';

/// Thẻ một đề: số câu, thời gian, nhãn miễn phí / làm dở / đã làm, nút Làm bài (hoặc Mở khoá PRO).
class TestCard extends StatelessWidget {
  const TestCard({
    super.key,
    required this.test,
    this.lastAttempt,
    this.inProgress,
    this.locked = false,
  });

  final TestSummary test;
  final Attempt? lastAttempt;
  final TakingSnapshot? inProgress;

  /// Đề PRO, user chưa có PRO → chạm mở giới thiệu PRO.
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final a = lastAttempt;
    final done = a == null
        ? null
        : a.isFullTest
        ? '${a.totalScore} điểm'
        : '${a.correct}/${a.totalQuestions} đúng';

    final isFullTest = test.questionCount >= 100;

    void open() => locked
        ? showProSheet(context)
        : context.push(Routes.testDetail(test.id));

    return AppCard(
      onTap: open,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSizes.badgeLg,
                height: AppSizes.badgeLg,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isFullTest
                        ? context.surfaces.hero
                        : context.surfaces.cyan,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.brMd,
                ),
                child: Center(
                  child: Icon(
                    isFullTest ? Icons.menu_book_rounded : Icons.bolt_rounded,
                    color: context.surfaces.onHero,
                    size: AppSizes.iconMd,
                  ),
                ),
              ),
              Gaps.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            test.title,
                            style: context.textStyles.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (locked) const ProBadge(label: 'PRO', mini: true),
                      ],
                    ),
                    Gaps.v4,
                    Wrap(
                      spacing: AppSpacing.s12,
                      runSpacing: AppSpacing.s4,
                      children: [
                        IconLabel(
                          icon: Icons.schedule_rounded,
                          label: '${test.examMinutes} phút',
                        ),
                        IconLabel(
                          icon: Icons.quiz_outlined,
                          label: '${test.questionCount} câu',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gaps.v12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.s8,
                  runSpacing: AppSpacing.s4,
                  children: [
                    TestTag(
                      label: isFullTest ? 'Chuẩn ETS' : 'Mini Test',
                      tone: isFullTest
                          ? TestTagTone.success
                          : TestTagTone.neutral,
                    ),
                    if (test.isFree)
                      const StatusBadge(
                        label: 'Miễn phí',
                        tone: AppTone.success,
                        icon: Icons.lock_open_rounded,
                      ),
                    if (inProgress case final p?)
                      StatusBadge(
                        label:
                            'Làm dở · ${p.answers.length}/${p.totalQuestions}',
                        tone: AppTone.info,
                        icon: Icons.pause_circle_outline_rounded,
                      ),
                    if (done != null)
                      StatusBadge(
                        label: 'Đã làm · $done',
                        tone: AppTone.success,
                        icon: Icons.check_rounded,
                      ),
                  ],
                ),
              ),
              Gaps.h8,
              FilledButton.tonal(
                onPressed: open,
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s12,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(locked ? 'Mở khoá' : 'Làm bài'),
                    Gaps.h4,
                    Icon(
                      locked
                          ? Icons.lock_outline_rounded
                          : Icons.arrow_forward_rounded,
                      size: AppSizes.iconXs,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
