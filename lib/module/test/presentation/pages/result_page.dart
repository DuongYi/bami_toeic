import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../helper/format.dart';
import '../../../../helper/score.dart';
import '../../../../routes/app_router.dart';
import '../../../leaderboard/data/realm.dart';
import '../../data/models/test_models.dart';
import '../../../vocab/presentation/widgets/word_lookup_sheet.dart';
import '../controllers/test_providers.dart';
import '../widgets/question_group_view.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key, required this.attemptId});

  final String attemptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(attemptResultProvider(attemptId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả'),
        leading: IconButton(
          tooltip: 'Đóng',
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.canPop() ? context.pop() : context.go(Routes.tests),
        ),
      ),
      body: AsyncView(
        value: data,
        loading: (_) => const ResultSkeleton(),
        onRetry: () => ref.invalidate(attemptResultProvider(attemptId)),
        data: (d) => _ResultBody(data: d),
      ),
    );
  }
}

class _ResultBody extends StatefulWidget {
  const _ResultBody({required this.data});

  final AttemptResult data;

  @override
  State<_ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<_ResultBody> {
  bool _wrongOnly = false;

  bool _isCorrect(Question q) => widget.data.isCorrect(q);

  void _openReview(int groupIndex) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _ReviewPager(
          groups: widget.data.groups,
          answers: widget.data.answers,
          initial: groupIndex,
        ),
      ),
    );
  }

  static (String, String) _verdict(double ratio) => ratio >= 0.85
      ? ('Xuất sắc! 🎉', 'Giữ phong độ này nhé.')
      : ratio >= 0.7
      ? ('Làm tốt lắm!', 'Xem lại vài câu sai để hoàn thiện.')
      : ratio >= 0.5
      ? ('Khá ổn', 'Tập trung ôn các Part còn yếu.')
      : ('Cố lên nào', 'Xem lại giải thích từng câu sai nhé.');

  @override
  Widget build(BuildContext context) {
    final a = widget.data.attempt;
    final questions = widget.data.questions;

    final byPart = <int, (int, int)>{};
    for (final q in questions) {
      final (c, t) = byPart[q.part] ?? (0, 0);
      byPart[q.part] = (c + (_isCorrect(q) ? 1 : 0), t + 1);
    }
    final listeningTotal = questions.where((q) => ToeicScore.isListening(q.part)).length;
    final readingTotal = questions.length - listeningTotal;
    final ratio = questions.isEmpty ? 0.0 : a.correct / questions.length;
    final wrong = questions
        .where((q) => !_isCorrect(q) && widget.data.answers[q.id] != null)
        .length;
    final skipped = questions.where((q) => widget.data.answers[q.id] == null).length;
    final listening = a.listeningScore;
    final reading = a.readingScore;
    final (title, hint) = _verdict(ratio);
    final muted = context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: AppInsets.screen,
            children: [
              // Hero kết quả chứng nhận TOEIC
              AppCard(
                padding: AppInsets.cardLarge,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: AppSizes.iconSm,
                              color: AppTone.success.colorsOf(context).main,
                            ),
                            Gaps.h4,
                            Text(
                              'BÁO CÁO KẾT QUẢ TOEIC',
                              style: context.textStyles.labelSmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gaps.v16,
                    ScoreRing(
                      value: ratio,
                      semanticLabel: 'Tỉ lệ đúng',
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(Fmt.percent(ratio), style: context.textStyles.displaySmall),
                          Text('${a.correct}/${questions.length} câu', style: muted),
                        ],
                      ),
                    ),
                    Gaps.v16,
                    Text(title, style: context.textStyles.headlineSmall),
                    Gaps.v4,
                    Text(hint, style: muted, textAlign: TextAlign.center),
                    Gaps.v16,
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: AppSpacing.s8,
                      runSpacing: AppSpacing.s8,
                      children: [
                        StatusBadge(
                          label: '${a.correct} đúng',
                          tone: AppTone.success,
                          icon: Icons.check_rounded,
                        ),
                        StatusBadge(
                          label: '$wrong sai',
                          tone: AppTone.danger,
                          icon: Icons.close_rounded,
                        ),
                        StatusBadge(label: '$skipped bỏ trống', icon: Icons.remove_rounded),
                        TestTag(
                          label: ratio >= 0.85
                              ? 'Trình độ C1'
                              : ratio >= 0.7
                              ? 'Trình độ B2'
                              : ratio >= 0.5
                              ? 'Trình độ B1'
                              : 'Cần bứt phá',
                          tone: ratio >= 0.7 ? TestTagTone.success : TestTagTone.warning,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gaps.v8,
              if (a.isFullTest) _Breakthrough(attempt: a),
              if (wrong > 0) ...[
                AppCard(
                  tone: AppTone.warning,
                  onTap: () => context.push(Routes.mistakes),
                  child: Row(
                    children: [
                      const IconBadge(
                        icon: Icons.assignment_late_outlined,
                        tone: AppTone.danger,
                        size: AppSizes.badgeMd,
                      ),
                      Gaps.h12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Đã lưu $wrong câu sai vào Sổ câu sai',
                              style: context.textStyles.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Gaps.v4,
                            Text(
                              'Bấm để xem phân tích bẫy đề thi và ôn lại ngay.',
                              style: context.textStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: context.colors.onSurfaceVariant),
                    ],
                  ),
                ),
                Gaps.v8,
              ],
              Padding(
                padding: AppInsets.screenH,
                child: Text(
                  '${a.testTitle} · ${a.isExam ? 'Thi thử' : 'Luyện tập'} · ${a.duration.inMinutes} phút',
                  style: muted,
                  textAlign: TextAlign.center,
                ),
              ),
              if (listeningTotal == 100 || readingTotal == 100) ...[
                Gaps.v24,
                const SectionHeader(
                  title: 'Điểm quy đổi',
                  subtitle: 'Ước tính, chỉ mang tính tham khảo',
                ),
                StatGrid(
                  children: [
                    if (listeningTotal == 100)
                      StatCard(
                        icon: Icons.headphones_rounded,
                        value: '$listening',
                        label: 'Listening',
                      ),
                    if (readingTotal == 100)
                      StatCard(
                        icon: Icons.chrome_reader_mode_outlined,
                        value: '$reading',
                        label: 'Reading',
                      ),
                    if (listeningTotal == 100 && readingTotal == 100)
                      StatCard(
                        icon: Icons.emoji_events_outlined,
                        value: '${listening + reading}',
                        label: 'Tổng',
                        tone: AppTone.warning,
                      ),
                  ],
                ),
              ],
              Gaps.v24,
              const SectionHeader(title: 'Theo Part'),
              AppCard(
                child: Column(
                  children: [
                    for (final (i, p) in (byPart.keys.toList()..sort()).indexed) ...[
                      if (i > 0) Gaps.v12,
                      LabeledProgress(
                        label: partNames[p] ?? 'Part $p',
                        value: byPart[p]!.$2 == 0 ? 0 : byPart[p]!.$1 / byPart[p]!.$2,
                        trailing: '${byPart[p]!.$1}/${byPart[p]!.$2}',
                      ),
                    ],
                  ],
                ),
              ),
              Gaps.v24,
              SectionHeader(
                title: 'Đáp án',
                subtitle: 'Chạm số câu để xem giải thích',
                trailing: FilterChip(
                  label: const Text('Chỉ câu sai'),
                  selected: _wrongOnly,
                  onSelected: (v) => setState(() => _wrongOnly = v),
                ),
              ),
              AppCard(
                child: Wrap(
                  spacing: AppSpacing.s8,
                  runSpacing: AppSpacing.s8,
                  children: [
                    for (final (gi, g) in widget.data.groups.indexed)
                      for (final q in g.questions)
                        if (!_wrongOnly || !_isCorrect(q)) _answerCell(q, () => _openReview(gi)),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppBottomBar(
          child: AppPrimaryButton(
            icon: Icons.menu_book_outlined,
            label: 'Xem lại đáp án',
            onPressed: widget.data.groups.isEmpty ? null : () => _openReview(0),
          ),
        ),
      ],
    );
  }

  Widget _answerCell(Question q, VoidCallback onTap) {
    final skipped = widget.data.answers[q.id] == null;
    final (tone, status) = _isCorrect(q)
        ? (AppTone.success, 'đúng')
        : skipped
        ? (AppTone.neutral, 'bỏ trống')
        : (AppTone.danger, 'sai');
    return NumberCell(
      number: q.number,
      tone: tone,
      semanticLabel: 'Câu ${q.number}, $status',
      onTap: onTap,
    );
  }
}

class _ReviewPager extends StatefulWidget {
  const _ReviewPager({required this.groups, required this.answers, required this.initial});

  final List<QuestionGroup> groups;
  final Map<String, String?> answers;
  final int initial;

  @override
  State<_ReviewPager> createState() => _ReviewPagerState();
}

class _ReviewPagerState extends State<_ReviewPager> {
  late final _controller = PageController(initialPage: widget.initial);
  late int _index = widget.initial;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Xem lại · ${_index + 1}/${widget.groups.length}')),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.groups.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (_, i) => QuestionGroupView(
          key: ValueKey(widget.groups[i].id),
          group: widget.groups[i],
          answers: widget.answers,
          isRevealed: (_) => true,
          showTranscript: true,
          contextMenuBuilder: lookupContextMenu(context),
        ),
      ),
    );
  }
}

/// Sau full test: báo đột phá cảnh giới / kỷ lục mới so với các full test trước đó.
class _Breakthrough extends ConsumerWidget {
  const _Breakthrough({required this.attempt});

  final Attempt attempt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attempts = ref.watch(attemptsProvider).value;
    if (attempts == null) return const SizedBox.shrink();
    final score = attempt.totalScore;
    final previous = [
      for (final x in attempts)
        if (x.id != attempt.id && x.isFullTest && x.finishedAt.isBefore(attempt.finishedAt))
          x.totalScore,
    ];
    final best = previous.isEmpty ? null : previous.reduce((x, y) => x > y ? x : y);
    final realm = Realm.of(score);

    final String title;
    final String message;
    if (best == null) {
      title = 'Ghi danh Thương Khung Bảng';
      message = 'Cảnh giới khởi đầu: ${realm.label}. Xem bạn đứng hạng mấy.';
    } else if (realm.index > Realm.of(best).index) {
      title = 'Đột phá ${realm.label}!';
      message = 'Vượt cảnh giới ${Realm.of(best).label} với $score điểm.';
    } else if (score > best) {
      title = 'Kỷ lục mới: $score điểm';
      message = 'Hơn kỷ lục cũ ${score - best} điểm.';
    } else {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s8),
      child: AppCard(
        tone: AppTone.success,
        onTap: () => context.go(Routes.leaderboard),
        child: Row(
          children: [
            const IconBadge(
              icon: Icons.workspace_premium_rounded,
              tone: AppTone.warning,
              size: AppSizes.badgeMd,
            ),
            Gaps.h12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textStyles.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    message,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
