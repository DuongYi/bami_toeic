import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../tokens/app_dimens.dart';
import '../theme/context_ext.dart';
import 'app_glass_tab_bar.dart';

/// Khối Skeleton Shimmer cơ bản cho hiệu ứng tải trang mượt mà.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  const AppSkeleton.line({
    super.key,
    this.width,
    this.height = 14,
    BorderRadius? borderRadius,
  })  : borderRadius = borderRadius ?? AppRadius.brXs,
        shape = BoxShape.rectangle;

  const AppSkeleton.circle({
    super.key,
    double size = 40,
  })  : width = size,
        height = size,
        borderRadius = null,
        shape = BoxShape.circle;

  const AppSkeleton.button({
    super.key,
    this.width,
    this.height = AppSizes.touchTarget,
    BorderRadius? borderRadius,
  })  : borderRadius = borderRadius ?? AppRadius.brLg,
        shape = BoxShape.rectangle;

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.surfaceContainerHighest.withValues(alpha: 0.7);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : (borderRadius ?? AppRadius.brSm),
      ),
    );
  }
}

/// Bọc layout skeleton với hiệu ứng nhịp thở / shimmer.
/// Tự động tắt lặp vô hạn khi chạy test để không làm timeout [pumpAndSettle].
class AppSkeletonShimmer extends StatefulWidget {
  const AppSkeletonShimmer({super.key, required this.child});

  final Widget child;

  @override
  State<AppSkeletonShimmer> createState() => _AppSkeletonShimmerState();
}

class _AppSkeletonShimmerState extends State<AppSkeletonShimmer>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  bool get _isTesting => !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');

  @override
  void initState() {
    super.initState();
    if (!_isTesting) {
      _controller = AnimationController(
        vsync: this,
        duration: AppMotion.shimmer,
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isTesting || MediaQuery.disableAnimationsOf(context)) {
      return Opacity(opacity: 0.75, child: widget.child);
    }

    final controller = _controller;
    if (controller == null) return widget.child;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final opacity = 0.45 + (controller.value * 0.45);
        return Opacity(opacity: opacity, child: child);
      },
      child: widget.child,
    );
  }
}

/// Thẻ Card Skeleton bọc sẵn padding và viền chuẩn design system.
class AppSkeletonCard extends StatelessWidget {
  const AppSkeletonCard({
    super.key,
    this.height,
    this.child,
    this.padding = AppInsets.card,
  });

  final double? height;
  final Widget? child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: child == null ? height : null,
      constraints: (child != null && height != null)
          ? BoxConstraints(minHeight: height!)
          : null,
      padding: padding,
      decoration: BoxDecoration(
        color: context.surfaces.raised,
        borderRadius: AppRadius.brLg,
        border: Border.fromBorderSide(context.surfaces.hairline),
      ),
      child: child,
    );
  }
}

/// Skeleton mặc định cho danh sách (dùng khi AsyncView chưa cấu hình skeleton riêng).
class AppSkeletonList extends StatelessWidget {
  const AppSkeletonList({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return AppSkeletonShimmer(
      child: ListView(
        padding: AppInsets.screen,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const AppSkeletonCard(
            height: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSkeleton.line(width: 140, height: 18),
                Gaps.v12,
                AppSkeleton.line(width: double.infinity, height: 14),
                Gaps.v8,
                AppSkeleton.line(width: 220, height: 14),
              ],
            ),
          ),
          Gaps.v16,
          for (var i = 0; i < itemCount; i++) ...[
            const AppSkeletonCard(
              child: Row(
                children: [
                  AppSkeleton(
                    width: AppSizes.badgeLg,
                    height: AppSizes.badgeLg,
                    borderRadius: AppRadius.brMd,
                  ),
                  Gaps.h12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSkeleton.line(width: 160, height: 16),
                        Gaps.v8,
                        AppSkeleton.line(width: 100, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gaps.v12,
          ],
        ],
      ),
    );
  }
}

/// Skeleton hoàn chỉnh cho màn danh sách đề thi ([TestListPage]).
class TestListSkeleton extends StatelessWidget {
  const TestListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonShimmer(
      child: ListView(
        padding: AppInsets.screen,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Greeting Skeleton
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeleton.line(width: 80, height: 12),
                  Gaps.v4,
                  AppSkeleton.line(width: 180, height: 22),
                ],
              ),
              Row(
                children: [
                  AppSkeleton(width: 64, height: 28, borderRadius: AppRadius.brFull),
                  Gaps.h8,
                  AppSkeleton.circle(size: AppSizes.avatarSm),
                ],
              ),
            ],
          ),
          Gaps.v16,
          // Hero Overview Card Skeleton
          const AppSkeletonCard(
            height: 130,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppSkeleton.line(width: 120, height: 14),
                      Gaps.v8,
                      AppSkeleton.line(width: 90, height: 32),
                      Gaps.v8,
                      AppSkeleton.line(width: 180, height: 12),
                    ],
                  ),
                ),
                AppSkeleton(
                  width: AppSizes.ringMd,
                  height: AppSizes.ringMd,
                  shape: BoxShape.circle,
                ),
              ],
            ),
          ),
          Gaps.v16,
          // Daily Mission Card Skeleton
          const AppSkeletonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppSkeleton.line(width: 140, height: 16),
                    AppSkeleton.line(width: 40, height: 14),
                  ],
                ),
                Gaps.v12,
                AppSkeleton(width: double.infinity, height: 8, borderRadius: AppRadius.brFull),
                Gaps.v12,
                AppSkeleton.line(width: 180, height: 14),
              ],
            ),
          ),
          Gaps.v16,
          // Bento Quick Actions Skeleton
          const Row(
            children: [
              Expanded(
                child: AppSkeletonCard(
                  height: 64,
                  child: Row(
                    children: [
                      AppSkeleton.circle(size: 32),
                      Gaps.h8,
                      Expanded(child: AppSkeleton.line(width: 60, height: 12)),
                    ],
                  ),
                ),
              ),
              Gaps.h12,
              Expanded(
                child: AppSkeletonCard(
                  height: 64,
                  child: Row(
                    children: [
                      AppSkeleton.circle(size: 32),
                      Gaps.h8,
                      Expanded(child: AppSkeleton.line(width: 60, height: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Gaps.v24,
          // Section header skeleton
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppSkeleton.line(width: 150, height: 18),
              AppSkeleton.line(width: 40, height: 14),
            ],
          ),
          Gaps.v12,
          // Filter tabs skeleton
          const Row(
            children: [
              AppSkeleton(width: 80, height: 32, borderRadius: AppRadius.brFull),
              Gaps.h8,
              AppSkeleton(width: 100, height: 32, borderRadius: AppRadius.brFull),
              Gaps.h8,
              AppSkeleton(width: 90, height: 32, borderRadius: AppRadius.brFull),
            ],
          ),
          Gaps.v16,
          // Test Cards
          for (var i = 0; i < 3; i++) ...[
            const AppSkeletonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppSkeleton(
                        width: AppSizes.badgeLg,
                        height: AppSizes.badgeLg,
                        borderRadius: AppRadius.brMd,
                      ),
                      Gaps.h12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppSkeleton.line(width: 180, height: 16),
                            Gaps.v8,
                            AppSkeleton.line(width: 120, height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gaps.v12,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppSkeleton(width: 70, height: 20, borderRadius: AppRadius.brXs),
                      AppSkeleton(width: 80, height: 28, borderRadius: AppRadius.brSm),
                    ],
                  ),
                ],
              ),
            ),
            Gaps.v12,
          ],
        ],
      ),
    );
  }
}

/// Skeleton hoàn chỉnh cho màn chi tiết đề thi ([TestDetailPage]).
class TestDetailSkeleton extends StatelessWidget {
  const TestDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonShimmer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.s24),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Hero cover card
          const AppSkeletonCard(
            height: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSkeleton(width: 110, height: 20, borderRadius: AppRadius.brFull),
                Gaps.v12,
                AppSkeleton.line(width: 220, height: 22),
                Gaps.v8,
                AppSkeleton.line(width: 180, height: 14),
              ],
            ),
          ),
          Gaps.v16,
          const AppSkeletonCard(
            height: 52,
            child: Row(
              children: [
                AppSkeleton.circle(size: 24),
                Gaps.h12,
                Expanded(child: AppSkeleton.line(width: double.infinity, height: 12)),
              ],
            ),
          ),
          Gaps.v24,
          const AppSkeleton.line(width: 100, height: 18),
          Gaps.v12,
          const AppSkeletonCard(height: 64),
          Gaps.v8,
          const AppSkeletonCard(height: 64),
          Gaps.v24,
          const AppSkeleton.line(width: 120, height: 18),
          Gaps.v12,
          for (var i = 0; i < 4; i++) ...[
            const AppSkeletonCard(height: 56),
            Gaps.v8,
          ],
        ],
      ),
    );
  }
}

/// Skeleton hoàn chỉnh cho màn từ vựng ([VocabPage]).
class VocabSkeleton extends StatelessWidget {
  const VocabSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonShimmer(
      child: ListView(
        padding: AppInsets.screen.copyWith(
          bottom: AppSpacing.fabClearance + AppGlassTabBar.inset(context),
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppSkeleton.line(width: 140, height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSkeleton(width: 50, height: 24, borderRadius: AppRadius.brFull),
                  Gaps.h8,
                  AppSkeleton(width: 60, height: 24, borderRadius: AppRadius.brFull),
                  Gaps.h8,
                  AppSkeleton(width: 44, height: 24, borderRadius: AppRadius.brFull),
                ],
              ),
            ],
          ),
          Gaps.v16,
          const AppSkeleton.line(width: 180, height: 28),
          Gaps.v4,
          const AppSkeleton.line(width: 240, height: 14),
          Gaps.v16,
          const AppSkeletonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.line(width: 100, height: 14),
                Gaps.v8,
                AppSkeleton.line(width: 80, height: 32),
                Gaps.v12,
                Row(
                  children: [
                    AppSkeleton(width: 80, height: 20, borderRadius: AppRadius.brFull),
                    Gaps.h8,
                    AppSkeleton(width: 70, height: 20, borderRadius: AppRadius.brFull),
                  ],
                ),
                Gaps.v16,
                AppSkeleton.button(width: double.infinity),
              ],
            ),
          ),
          Gaps.v16,
          const AppSkeletonCard(height: 48),
          Gaps.v16,
          const Row(
            children: [
              AppSkeleton(width: 70, height: 32, borderRadius: AppRadius.brFull),
              Gaps.h8,
              AppSkeleton(width: 90, height: 32, borderRadius: AppRadius.brFull),
              Gaps.h8,
              AppSkeleton(width: 80, height: 32, borderRadius: AppRadius.brFull),
            ],
          ),
          Gaps.v16,
          for (var i = 0; i < 4; i++) ...[
            const AppSkeletonCard(
              child: Row(
                children: [
                  AppSkeleton.circle(size: 36),
                  Gaps.h12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSkeleton.line(width: 120, height: 16),
                        Gaps.v4,
                        AppSkeleton.line(width: 180, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gaps.v12,
          ],
        ],
      ),
    );
  }
}

/// Skeleton hoàn chỉnh cho màn kết quả ([ResultPage]).
class ResultSkeleton extends StatelessWidget {
  const ResultSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonShimmer(
      child: ListView(
        padding: AppInsets.screen,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const AppSkeletonCard(
            padding: AppInsets.cardLarge,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppSkeleton.line(width: 130, height: 14),
                    AppSkeleton(width: 70, height: 20, borderRadius: AppRadius.brXs),
                  ],
                ),
                Gaps.v16,
                AppSkeleton(
                  width: AppSizes.ringLg,
                  height: AppSizes.ringLg,
                  shape: BoxShape.circle,
                ),
                Gaps.v16,
                AppSkeleton.line(width: 120, height: 20),
                Gaps.v8,
                AppSkeleton.line(width: 160, height: 14),
              ],
            ),
          ),
          Gaps.v16,
          const AppSkeletonCard(height: 64),
          Gaps.v24,
          const AppSkeleton.line(width: 110, height: 18),
          Gaps.v12,
          const Row(
            children: [
              Expanded(child: AppSkeletonCard(height: 72)),
              Gaps.h12,
              Expanded(child: AppSkeletonCard(height: 72)),
            ],
          ),
          Gaps.v24,
          const AppSkeleton.line(width: 100, height: 18),
          Gaps.v12,
          const AppSkeletonCard(height: 140),
        ],
      ),
    );
  }
}

/// Skeleton hoàn chỉnh cho sổ câu sai ([MistakesPage]).
class MistakesSkeleton extends StatelessWidget {
  const MistakesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonShimmer(
      child: ListView(
        padding: AppInsets.screen,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const AppSkeletonCard(
            height: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSkeleton.line(width: 110, height: 14),
                Gaps.v8,
                AppSkeleton.line(width: 60, height: 32),
                Gaps.v8,
                AppSkeleton.line(width: 140, height: 12),
              ],
            ),
          ),
          Gaps.v12,
          const AppSkeletonCard(height: 60),
          Gaps.v24,
          const AppSkeleton.line(width: 100, height: 18),
          Gaps.v12,
          for (var i = 0; i < 4; i++) ...[
            const AppSkeletonCard(height: 56),
            Gaps.v8,
          ],
        ],
      ),
    );
  }
}

/// Skeleton hoàn chỉnh cho màn làm bài ([TestTakingPage]).
class TestTakingSkeleton extends StatelessWidget {
  const TestTakingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonShimmer(
      child: Padding(
        padding: AppInsets.screen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppSkeleton.line(width: 80, height: 18),
                AppSkeleton(width: 90, height: 28, borderRadius: AppRadius.brFull),
              ],
            ),
            Gaps.v12,
            const AppSkeleton(width: double.infinity, height: 6, borderRadius: AppRadius.brFull),
            Gaps.v24,
            const AppSkeletonCard(
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeleton.line(width: 100, height: 14),
                  Gaps.v12,
                  AppSkeleton.line(width: double.infinity, height: 16),
                  Gaps.v8,
                  AppSkeleton.line(width: double.infinity, height: 16),
                  Gaps.v8,
                  AppSkeleton.line(width: 180, height: 16),
                ],
              ),
            ),
            Gaps.v16,
            for (var i = 0; i < 4; i++) ...[
              const AppSkeletonCard(height: 52),
              Gaps.v8,
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton hoàn chỉnh cho màn lịch sử / tiến độ ([HistoryPage]).
class HistorySkeleton extends StatelessWidget {
  const HistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonShimmer(
      child: ListView(
        padding: AppInsets.screen,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppSkeleton.line(width: 140, height: 24),
              AppSkeleton.circle(size: 32),
            ],
          ),
          Gaps.v16,
          const AppSkeletonCard(height: 160),
          Gaps.v24,
          const AppSkeleton.line(width: 130, height: 18),
          Gaps.v12,
          for (var i = 0; i < 4; i++) ...[
            const AppSkeletonCard(
              child: Row(
                children: [
                  AppSkeleton(
                    width: AppSizes.badgeLg,
                    height: AppSizes.badgeLg,
                    borderRadius: AppRadius.brMd,
                  ),
                  Gaps.h12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSkeleton.line(width: 140, height: 16),
                        Gaps.v4,
                        AppSkeleton.line(width: 90, height: 12),
                      ],
                    ),
                  ),
                  AppSkeleton.line(width: 50, height: 18),
                ],
              ),
            ),
            Gaps.v12,
          ],
        ],
      ),
    );
  }
}

/// Skeleton hoàn chỉnh cho màn chào mở app ([SplashPage]).
class SplashSkeleton extends StatelessWidget {
  const SplashSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonShimmer(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSkeleton(
                width: AppSizes.brandMark,
                height: AppSizes.brandMark,
                borderRadius: AppRadius.brXl,
              ),
              Gaps.v16,
              const AppSkeleton.line(width: 140, height: 22),
              Gaps.v8,
              const AppSkeleton.line(width: 220, height: 14),
              Gaps.v32,
              const AppSkeleton(width: 120, height: 4, borderRadius: AppRadius.brFull),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton hoàn chỉnh cho màn học flashcard ([FlashcardPage]).
class FlashcardSkeleton extends StatelessWidget {
  const FlashcardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonShimmer(
      child: Center(
        child: SingleChildScrollView(
          padding: AppInsets.screen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppSkeletonCard(
                height: 360,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppSkeleton.circle(size: 64),
                      Gaps.v16,
                      AppSkeleton.line(width: 160, height: 28),
                      Gaps.v8,
                      AppSkeleton.line(width: 100, height: 16),
                      Gaps.v24,
                      AppSkeleton(width: 120, height: 36, borderRadius: AppRadius.brFull),
                    ],
                  ),
                ),
              ),
              Gaps.v24,
              const Row(
                children: [
                  Expanded(child: AppSkeleton.button()),
                  Gaps.h12,
                  Expanded(child: AppSkeleton.button()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
