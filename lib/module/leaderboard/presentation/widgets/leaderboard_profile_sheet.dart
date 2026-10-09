import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../data/models/leaderboard_models.dart';
import '../controllers/leaderboard_controller.dart';

/// Đặt tên hiển thị và bật/tắt hiện trên Thương Khung Bảng.
Future<void> showLeaderboardProfileSheet(BuildContext context) =>
    showAppBottomSheet<void>(context, builder: (_) => const _ProfileSheet());

class _ProfileSheet extends ConsumerStatefulWidget {
  const _ProfileSheet();

  @override
  ConsumerState<_ProfileSheet> createState() => _ProfileSheetState();
}

class _ProfileSheetState extends ConsumerState<_ProfileSheet> {
  static const _minName = 2;
  static const _maxName = 24;

  final _name = TextEditingController();
  bool? _visible;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    ref
        .read(myLeaderboardProfileProvider.future)
        .then(
          (p) {
            if (!mounted) return;
            _name.text = p.displayName ?? '';
            setState(() => _visible = p.showOnLeaderboard);
          },
          onError: (Object _) {
            if (mounted) setState(() => _visible = true);
          },
        );
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isNotEmpty && name.length < _minName) {
      setState(() => _error = 'Tên cần ít nhất $_minName ký tự, hoặc để trống để dùng tên tự đặt.');
      return;
    }
    setState(() {
      _error = null;
      _saving = true;
    });
    try {
      await ref
          .read(myLeaderboardProfileProvider.notifier)
          .save(
            LeaderboardProfile(
              displayName: name.isEmpty ? null : name,
              showOnLeaderboard: _visible ?? true,
            ),
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showAppSnackBar(context, AppException.from(e).message, tone: AppTone.danger);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    if (visible == null) return const SizedBox(height: AppSizes.ringLg, child: AppLoadingView());
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Hồ sơ xếp hạng', style: context.textStyles.titleLarge),
            Gaps.v16,
            TextField(
              controller: _name,
              maxLength: _maxName,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
              decoration: InputDecoration(
                labelText: 'Đạo hiệu (tên hiển thị)',
                hintText: 'Để trống để dùng "Học viên ABCD"',
                errorText: _error,
              ),
            ),
            Gaps.v8,
            AppListGroup(
              children: [
                SwitchListTile(
                  secondary: const IconBadge(icon: Icons.leaderboard_outlined),
                  title: const Text('Hiện trên bảng xếp hạng'),
                  subtitle: Text(
                    visible
                        ? 'Người khác thấy tên, điểm full test cao nhất và số câu 7 ngày của bạn'
                        : 'Chỉ mình bạn thấy hạng của mình',
                  ),
                  value: visible,
                  onChanged: (v) => setState(() => _visible = v),
                ),
              ],
            ),
            Gaps.v16,
            AppPrimaryButton(label: 'Lưu', loading: _saving, onPressed: _saving ? null : _save),
          ],
        ),
      ),
    );
  }
}
