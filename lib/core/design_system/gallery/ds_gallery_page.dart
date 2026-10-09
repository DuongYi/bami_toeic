import 'package:flutter/material.dart';

import '../design_system.dart';

/// Catalog mọi token & component. Mở bằng route `/design-system` (chỉ bản debug).
/// Khi thêm component mới vào design system, PHẢI thêm một mục vào đây.
class DsGalleryPage extends StatelessWidget {
  const DsGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design System')),
      body: ListView(
        padding: AppInsets.screen,
        children: const [
          _Section('Màu (ColorScheme + AppTone)', _ColorsDemo()),
          _Section('Typography', _TypographyDemo()),
          _Section('Nút', _ButtonsDemo()),
          _Section('Card · Badge · Progress', _CardsDemo()),
          _Section('StatTile · NumberCell', _NumbersDemo()),
          _Section('Hero · ScoreRing · StatCard', _HeroDemo()),
          _Section('ChoiceCard · IconBadge · AppListGroup', _ChoiceDemo()),
          _Section('Trạng thái màn hình', _StatesDemo()),
          _Section('Phản hồi (dialog, snackbar, sheet)', _FeedbackDemo()),
          _Section('Thương mại hoá (Commercial · PRO · Streaks)', _CommercialDemo()),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.child);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.s32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: title),
        child,
      ],
    ),
  );
}

class _ColorsDemo extends StatelessWidget {
  const _ColorsDemo();

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    Widget swatch(String name, Color bg, Color fg) => Container(
      padding: const EdgeInsets.all(AppSpacing.s8),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.brSm),
      child: Text(name, style: context.textStyles.labelSmall?.copyWith(color: fg)),
    );
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: [
        swatch('primary', cs.primary, cs.onPrimary),
        swatch('primaryContainer', cs.primaryContainer, cs.onPrimaryContainer),
        swatch('secondary', cs.secondary, cs.onSecondary),
        swatch('tertiary', cs.tertiary, cs.onTertiary),
        swatch('surfaceContainerLow', cs.surfaceContainerLow, cs.onSurface),
        swatch('error', cs.error, cs.onError),
        for (final t in AppTone.values) ...[
          swatch(t.name, t.colorsOf(context).main, t.colorsOf(context).onMain),
          swatch(
            '${t.name}Container',
            t.colorsOf(context).container,
            t.colorsOf(context).onContainer,
          ),
        ],
      ],
    );
  }
}

class _TypographyDemo extends StatelessWidget {
  const _TypographyDemo();

  @override
  Widget build(BuildContext context) {
    final t = context.textStyles;
    final styles = {
      'displaySmall': t.displaySmall,
      'headlineSmall': t.headlineSmall,
      'titleLarge': t.titleLarge,
      'titleMedium': t.titleMedium,
      'bodyLarge': t.bodyLarge,
      'bodyMedium': t.bodyMedium,
      'bodySmall': t.bodySmall,
      'labelLarge': t.labelLarge,
      'labelSmall': t.labelSmall,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final e in styles.entries) Text('${e.key} · Ấ Ễ Ộ Ữ ợ', style: e.value)],
    );
  }
}

class _ButtonsDemo extends StatelessWidget {
  const _ButtonsDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppPrimaryButton(
          label: 'AppPrimaryButton',
          icon: Icons.play_arrow_rounded,
          onPressed: () {},
        ),
        Gaps.v8,
        const AppPrimaryButton(label: 'Loading', loading: true, onPressed: null),
        Gaps.v8,
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            FilledButton(onPressed: () {}, child: const Text('Filled')),
            FilledButton.tonal(onPressed: () {}, child: const Text('Tonal')),
            OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
            TextButton(onPressed: () {}, child: const Text('Text')),
          ],
        ),
      ],
    );
  }
}

class _CardsDemo extends StatelessWidget {
  const _CardsDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppCard(child: Text('AppCard mặc định')),
        Gaps.v8,
        const AppCard(tone: AppTone.info, child: Text('AppCard tone: info')),
        Gaps.v8,
        const AppBanner(
          message: 'AppBanner danger: Email hoặc mật khẩu không đúng.',
          tone: AppTone.danger,
        ),
        Gaps.v8,
        const AppBanner(message: 'AppBanner info: gợi ý / thông tin phụ.'),
        Gaps.v12,
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            for (final t in AppTone.values) StatusBadge(label: t.name, tone: t, icon: t.icon),
          ],
        ),
        Gaps.v12,
        const LabeledProgress(label: 'Tốt (≥ 70%)', value: 0.82, trailing: '82%'),
        Gaps.v8,
        const LabeledProgress(label: 'Trung bình (≥ 50%)', value: 0.6, trailing: '60%'),
        Gaps.v8,
        const LabeledProgress(label: 'Yếu', value: 0.3, trailing: '30%'),
      ],
    );
  }
}

class _NumbersDemo extends StatelessWidget {
  const _NumbersDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppCard(
          child: Row(
            children: [
              StatTile(value: '12', label: 'Lượt làm'),
              StatTile(value: '78%', label: 'Tỉ lệ đúng'),
              StatTile(value: '850', label: 'Cao nhất', highlight: true),
            ],
          ),
        ),
        Gaps.v12,
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            const NumberCell(number: 1),
            const NumberCell(number: 2, filled: true),
            const NumberCell(number: 3, current: true),
            const NumberCell(number: 7, filled: true, flagged: true),
            const NumberCell(number: 4, tone: AppTone.success),
            const NumberCell(number: 5, tone: AppTone.danger),
            const NumberCell(number: 6, tone: AppTone.neutral),
          ],
        ),
      ],
    );
  }
}

class _StatesDemo extends StatelessWidget {
  const _StatesDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: AppSizes.imagePlaceholder, child: AppLoadingView()),
        AppEmptyView(icon: Icons.inbox_outlined, message: 'AppEmptyView: chưa có dữ liệu.'),
        AppErrorView(message: 'AppErrorView: không có kết nối mạng.', onRetry: _noop),
      ],
    );
  }
}

void _noop() {}

class _FeedbackDemo extends StatelessWidget {
  const _FeedbackDemo();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: [
        OutlinedButton(
          onPressed: () => showAppConfirmDialog(
            context,
            title: 'Xoá mục này?',
            message: 'Không thể hoàn tác.',
            confirmLabel: 'Xoá',
            destructive: true,
          ),
          child: const Text('Confirm (destructive)'),
        ),
        OutlinedButton(
          onPressed: () => showAppSnackBar(context, 'Đã lưu', tone: AppTone.success),
          child: const Text('Snackbar success'),
        ),
        OutlinedButton(
          onPressed: () => showAppSnackBar(
            context,
            'Lưu thất bại',
            tone: AppTone.danger,
            actionLabel: 'Thử lại',
            onAction: () {},
          ),
          child: const Text('Snackbar danger'),
        ),
        OutlinedButton(
          onPressed: () => showAppBottomSheet<void>(
            context,
            builder: (_) =>
                const Padding(padding: AppInsets.cardLarge, child: Text('Nội dung bottom sheet')),
          ),
          child: const Text('Bottom sheet'),
        ),
      ],
    );
  }
}

class _HeroDemo extends StatelessWidget {
  const _HeroDemo();

  @override
  Widget build(BuildContext context) {
    final fg = AppHeroCard.foreground(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppHeroCard(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'AppHeroCard',
                  style: context.textStyles.titleLarge?.copyWith(color: fg),
                ),
              ),
              ScoreRing(
                value: 0.72,
                size: AppSizes.ringSm,
                strokeWidth: AppSizes.ringStrokeSm,
                color: fg,
                trackColor: fg.withValues(alpha: 0.25),
                child: Text('72%', style: context.textStyles.labelLarge?.copyWith(color: fg)),
              ),
            ],
          ),
        ),
        Gaps.v12,
        Center(
          child: ScoreRing(value: 0.75, child: Text('75%', style: context.textStyles.displaySmall)),
        ),
        Gaps.v12,
        const StatGrid(
          children: [
            StatCard(icon: Icons.assignment_turned_in_outlined, value: '12', label: 'Lượt làm'),
            StatCard(
              icon: Icons.emoji_events_outlined,
              value: '850',
              label: 'Cao nhất',
              tone: AppTone.warning,
            ),
          ],
        ),
      ],
    );
  }
}

class _ChoiceDemo extends StatefulWidget {
  const _ChoiceDemo();

  @override
  State<_ChoiceDemo> createState() => _ChoiceDemoState();
}

class _ChoiceDemoState extends State<_ChoiceDemo> {
  bool _a = true;
  bool _b = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChoiceCard(
          icon: Icons.lightbulb_outline_rounded,
          title: 'ChoiceCard (radio)',
          subtitle: 'Chọn một',
          selected: _a,
          onTap: () => setState(() => _a = !_a),
        ),
        Gaps.v8,
        ChoiceCard(
          multiSelect: true,
          icon: Icons.headphones_rounded,
          title: 'ChoiceCard (multi)',
          subtitle: 'Chọn nhiều',
          selected: _b,
          onTap: () => setState(() => _b = !_b),
        ),
        Gaps.v12,
        const AppListGroup(
          children: [
            ListTile(
              leading: IconBadge(icon: Icons.menu_book_rounded),
              title: Text('AppListGroup + IconBadge'),
              subtitle: Text('Item 1'),
            ),
            ListTile(
              leading: IconBadge(icon: Icons.timer_outlined, tone: AppTone.warning),
              title: Text('Item 2'),
            ),
          ],
        ),
      ],
    );
  }
}

class _CommercialDemo extends StatelessWidget {
  const _CommercialDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ProBadge(),
            ProBadge(label: 'VIP', mini: true),
            StreakBadge(count: 7),
            TestTag(label: 'ETS 2024', tone: TestTagTone.info),
            TestTag(label: 'Chuẩn đề thi', tone: TestTagTone.success),
            TestTag(label: 'Nâng cao', tone: TestTagTone.danger),
          ],
        ),
        Gaps.v12,
        DailyMissionCard(
          completed: 2,
          total: 3,
          items: const [
            DailyMissionItem(title: 'Luyện 1 Part đề thi', isDone: true, trailing: 'Part 5'),
            DailyMissionItem(title: 'Ôn 10 từ vựng SRS', isDone: true, trailing: '10/10'),
            DailyMissionItem(title: 'Giải quyết 5 câu làm sai', isDone: false, trailing: '0/5'),
          ],
          onTap: () {},
        ),
        Gaps.v12,
        UpgradeBanner(
          title: 'Nâng cấp Bami PRO',
          description: 'Mở khoá đầy đủ đề thi ETS và giải thích chi tiết AI',
          onUpgrade: () {},
        ),
      ],
    );
  }
}
