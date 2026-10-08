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
          _Section('Trạng thái màn hình', _StatesDemo()),
          _Section('Phản hồi (dialog, snackbar, sheet)', _FeedbackDemo()),
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
