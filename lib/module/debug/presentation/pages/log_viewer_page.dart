import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/logging/app_log.dart';

enum _Filter { all, network, errors }

/// Nhật ký debug: xem request mạng, lỗi provider, crash; sao chép để gửi khi báo lỗi.
class LogViewerPage extends StatefulWidget {
  const LogViewerPage({super.key});

  @override
  State<LogViewerPage> createState() => _LogViewerPageState();
}

class _LogViewerPageState extends State<LogViewerPage> {
  _Filter _filter = _Filter.all;
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  List<LogEntry> _visible(List<LogEntry> all) {
    final q = _query.text.trim().toLowerCase();
    return [
      for (final e in all.reversed)
        if ((switch (_filter) {
              _Filter.all => true,
              _Filter.network => e.kind == LogKind.network,
              _Filter.errors => e.level == LogLevel.error || e.level == LogLevel.warning,
            }) &&
            (q.isEmpty || e.format().toLowerCase().contains(q)))
          e,
    ];
  }

  Future<void> _copy(String text, String what) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) showAppSnackBar(context, 'Đã sao chép $what', tone: AppTone.success);
  }

  Future<void> _clear() async {
    final ok = await showAppConfirmDialog(
      context,
      title: 'Xoá nhật ký?',
      message: 'Xoá toàn bộ log đang lưu trong bộ nhớ.',
      confirmLabel: 'Xoá',
      destructive: true,
    );
    if (ok) AppLog.instance.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLog.instance,
      builder: (context, _) {
        final all = AppLog.instance.entries;
        final shown = _visible(all);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Nhật ký debug'),
            actions: [
              IconButton(
                tooltip: 'Xoá nhật ký',
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: all.isEmpty ? null : _clear,
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.s8,
                  AppSpacing.screen,
                  AppSpacing.s8,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _query,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        hintText: 'Tìm theo đường dẫn, mã lỗi, nội dung…',
                      ),
                    ),
                    Gaps.v8,
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<_Filter>(
                        segments: [
                          ButtonSegment(value: _Filter.all, label: Text('Tất cả (${all.length})')),
                          const ButtonSegment(value: _Filter.network, label: Text('Mạng')),
                          ButtonSegment(
                            value: _Filter.errors,
                            label: Text('Lỗi (${AppLog.instance.errorCount})'),
                          ),
                        ],
                        selected: {_filter},
                        showSelectedIcon: false,
                        onSelectionChanged: (v) => setState(() => _filter = v.first),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: shown.isEmpty
                    ? const AppEmptyView(
                        icon: Icons.receipt_long_outlined,
                        message: 'Chưa có log nào khớp.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: AppSpacing.s24),
                        itemCount: shown.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, i) => _EntryTile(
                          entry: shown[i],
                          onCopy: () => _copy(shown[i].format(), '1 dòng log'),
                        ),
                      ),
              ),
            ],
          ),
          bottomNavigationBar: AppBottomBar(
            child: AppPrimaryButton(
              icon: Icons.copy_all_rounded,
              label: 'Sao chép ${shown.length} dòng đang hiện',
              onPressed: shown.isEmpty
                  ? null
                  : () => _copy(AppLog.instance.export(shown.reversed), '${shown.length} dòng log'),
            ),
          ),
        );
      },
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.entry, required this.onCopy});

  final LogEntry entry;
  final VoidCallback onCopy;

  AppTone get _tone => switch (entry.level) {
    LogLevel.error => AppTone.danger,
    LogLevel.warning => AppTone.warning,
    LogLevel.info => entry.kind == LogKind.network ? AppTone.success : AppTone.info,
    LogLevel.debug => AppTone.neutral,
  };

  IconData get _icon => switch (entry.kind) {
    LogKind.network => Icons.swap_vert_rounded,
    LogKind.provider => Icons.account_tree_outlined,
    LogKind.crash => Icons.bug_report_outlined,
    LogKind.app => Icons.notes_rounded,
  };

  void _open(BuildContext context) => showAppBottomSheet<void>(
    context,
    builder: (ctx) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(entry.title, style: ctx.textStyles.titleMedium),
            Gaps.v8,
            SelectableText(entry.format(), style: ctx.textStyles.bodySmall),
            Gaps.v16,
            OutlinedButton.icon(
              icon: const Icon(Icons.copy_rounded),
              label: const Text('Sao chép'),
              onPressed: () {
                Navigator.pop(ctx);
                onCopy();
              },
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final c = _tone.colorsOf(context);
    final e = entry;
    final meta = e.header.substring(1, 13); // giờ:phút:giây.ms
    return ListTile(
      leading: Icon(_icon, color: c.main, semanticLabel: e.level.name),
      title: Text(e.title, maxLines: 3, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        [
          meta,
          e.kind.name,
          if (e.durationMs != null && e.durationMs! >= 0) '${e.durationMs} ms',
        ].join(' · '),
      ),
      onTap: () => _open(context),
      onLongPress: onCopy,
    );
  }
}
