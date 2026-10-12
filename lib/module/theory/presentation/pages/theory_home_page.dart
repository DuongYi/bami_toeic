import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../routes/app_router.dart';
import '../../data/models/theory_models.dart';
import '../controllers/theory_controller.dart';

/// Màn hình chính Sổ tay Lý thuyết & Ngữ pháp, Phát âm, Chiến thuật làm bài
class TheoryHomePage extends ConsumerStatefulWidget {
  const TheoryHomePage({super.key});

  @override
  ConsumerState<TheoryHomePage> createState() => _TheoryHomePageState();
}

class _TheoryHomePageState extends ConsumerState<TheoryHomePage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(theoryControllerProvider);
    final controller = ref.read(theoryControllerProvider.notifier);
    final filteredTopics = state.filteredTopics;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sổ tay Lý thuyết & Mẹo thi'),
        actions: [
          IconButton(
            tooltip: state.showOnlyBookmarks ? 'Xem tất cả' : 'Chỉ xem bài đã lưu',
            icon: Icon(
              state.showOnlyBookmarks ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: state.showOnlyBookmarks ? context.colors.primary : null,
            ),
            onPressed: () => controller.toggleBookmarksFilter(),
          ),
        ],
      ),
      body: ListView(
        padding: AppInsets.screen,
        children: [
          // Thẻ Hero tổng quan tiến độ
          _TheoryHeroCard(
            completedCount: state.completedCount,
            totalCount: state.totalCount,
            progressRatio: state.progressRatio,
          ),
          Gaps.v16,

          // Thanh tìm kiếm nhanh
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm chủ điểm, thì, âm IPA, bẫy Part...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        controller.setSearchQuery('');
                        setState(() {});
                      },
                    )
                  : null,
              filled: true,
              fillColor: context.colors.surfaceContainerLowest,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: AppSpacing.s12,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.brMd,
                borderSide: BorderSide(color: context.colors.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.brMd,
                borderSide: BorderSide(color: context.colors.outlineVariant),
              ),
            ),
            onChanged: (val) {
              controller.setSearchQuery(val);
              setState(() {});
            },
          ),
          Gaps.v16,

          // Bộ lọc phân loại nhanh
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: Text('Tất cả (${state.allTopics.length})'),
                  selected: state.selectedCategory == null && !state.showOnlyBookmarks,
                  onSelected: (_) {
                    if (state.showOnlyBookmarks) controller.toggleBookmarksFilter();
                    controller.selectCategory(null);
                  },
                ),
                Gaps.h8,
                for (final cat in TheoryCategory.values) ...[
                  FilterChip(
                    avatar: Icon(cat.icon, size: AppSizes.iconSm),
                    label: Text(
                      '${cat.label} (${state.allTopics.where((t) => t.category == cat).length})',
                    ),
                    selected: state.selectedCategory == cat,
                    onSelected: (_) => controller.selectCategory(cat),
                  ),
                  Gaps.h8,
                ],
                FilterChip(
                  avatar: const Icon(Icons.bookmark_rounded, size: AppSizes.iconSm),
                  label: Text('Đã lưu (${state.bookmarkedIds.length})'),
                  selected: state.showOnlyBookmarks,
                  onSelected: (_) => controller.toggleBookmarksFilter(),
                ),
              ],
            ),
          ),
          Gaps.v16,

          // Danh sách bài học
          if (filteredTopics.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s32),
              child: AppEmptyView(
                icon: Icons.search_off_rounded,
                message: state.showOnlyBookmarks
                    ? 'Bạn chưa lưu bài lý thuyết nào.\nHãy nhấn biểu tượng lưu để xem lại sau.'
                    : 'Không tìm thấy bài học nào phù hợp với từ khóa.',
              ),
            )
          else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh sách bài học (${filteredTopics.length})',
                  style: context.textStyles.titleMedium,
                ),
                if (state.selectedCategory != null)
                  Text(
                    state.selectedCategory!.label,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            Gaps.v12,
            for (final topic in filteredTopics) ...[
              _TheoryTopicCard(
                topic: topic,
                isCompleted: state.isCompleted(topic.id),
                isBookmarked: state.isBookmarked(topic.id),
                quizScore: state.getQuizScore(topic.id),
                onTap: () => context.push(Routes.theoryDetail(topic.id)),
                onToggleBookmark: () => controller.toggleBookmark(topic.id),
              ),
              Gaps.v12,
            ],
          ],
          Gaps.v24,
        ],
      ),
    );
  }
}

/// Thẻ Hero hiển thị tiến độ và định hướng học tập
class _TheoryHeroCard extends StatelessWidget {
  const _TheoryHeroCard({
    required this.completedCount,
    required this.totalCount,
    required this.progressRatio,
  });

  final int completedCount;
  final int totalCount;
  final double progressRatio;

  @override
  Widget build(BuildContext context) {
    final fg = AppHeroCard.foreground(context);
    return AppHeroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s8),
                decoration: BoxDecoration(
                  color: fg.withValues(alpha: 0.2),
                  borderRadius: AppRadius.brMd,
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: fg,
                  size: AppSizes.iconMd,
                ),
              ),
              Gaps.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KHO LÝ THUYẾT & MẸO ETS',
                      style: context.textStyles.labelSmall?.copyWith(
                        color: fg.withValues(alpha: 0.8),
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Nắm chắc nền tảng – Tăng tốc điểm số',
                      style: context.textStyles.titleMedium?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gaps.v16,
          Text(
            'Hệ thống lý thuyết cô đọng từ Ngữ pháp 12 thì, Bảng 44 âm IPA đến Chiến thuật phá bẫy đề thi Part 1–7.',
            style: context.textStyles.bodySmall?.copyWith(
              color: fg.withValues(alpha: 0.9),
            ),
          ),
          Gaps.v16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tiến độ: $completedCount / $totalCount bài hoàn thành',
                style: context.textStyles.labelMedium?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progressRatio * 100).toInt()}%',
                style: context.textStyles.labelLarge?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Gaps.v8,
          ClipRRect(
            borderRadius: AppRadius.brXs,
            child: LinearProgressIndicator(
              value: progressRatio,
              minHeight: 6,
              backgroundColor: fg.withValues(alpha: 0.25),
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          ),
        ],
      ),
    );
  }
}

/// Thẻ bài học lý thuyết
class _TheoryTopicCard extends StatelessWidget {
  const _TheoryTopicCard({
    required this.topic,
    required this.isCompleted,
    required this.isBookmarked,
    required this.quizScore,
    required this.onTap,
    required this.onToggleBookmark,
  });

  final TheoryTopic topic;
  final bool isCompleted;
  final bool isBookmarked;
  final int? quizScore;
  final VoidCallback onTap;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: AppInsets.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBadge(
                icon: topic.category.icon,
                tone: topic.category.tone,
                size: AppSizes.badgeMd,
              ),
              Gaps.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: context.textStyles.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gaps.v4,
                    Text(
                      topic.subtitle,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isBookmarked ? context.colors.primary : context.colors.onSurfaceVariant,
                ),
                tooltip: isBookmarked ? 'Bỏ lưu' : 'Lưu bài học',
                onPressed: onToggleBookmark,
              ),
            ],
          ),
          Gaps.v12,
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Badge danh mục
              StatusBadge(
                label: topic.category.label,
                tone: topic.category.tone,
              ),
              // Badge độ khó
              StatusBadge(
                label: topic.difficulty,
                tone: switch (topic.difficulty) {
                  'Nâng cao' => AppTone.danger,
                  'Trung cấp' => AppTone.warning,
                  _ => AppTone.info,
                },
              ),
              // Badge thời gian đọc
              StatusBadge(
                icon: Icons.timer_outlined,
                label: '${topic.readTimeMinutes} phút',
                tone: AppTone.neutral,
              ),
              // Trạng thái hoàn thành & Điểm Quiz
              if (isCompleted)
                StatusBadge(
                  icon: Icons.check_circle_rounded,
                  label: quizScore != null
                      ? 'Đạt $quizScore/${topic.quiz.length}'
                      : 'Đã hoàn thành',
                  tone: AppTone.success,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
