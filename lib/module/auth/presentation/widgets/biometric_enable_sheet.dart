import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../controllers/biometric_login_controller.dart';

/// Bật đăng nhập bằng Face ID / vân tay từ Cài đặt: nhập lại mật khẩu để kiểm tra rồi lưu.
/// Trả về true khi đã bật.
Future<bool> showBiometricEnableSheet(BuildContext context, BiometricStatus status) async =>
    await showAppBottomSheet<bool>(context, builder: (_) => _BiometricEnableSheet(status)) ?? false;

class _BiometricEnableSheet extends ConsumerStatefulWidget {
  const _BiometricEnableSheet(this.status);

  final BiometricStatus status;

  @override
  ConsumerState<_BiometricEnableSheet> createState() => _BiometricEnableSheetState();
}

class _BiometricEnableSheetState extends ConsumerState<_BiometricEnableSheet> {
  final _password = TextEditingController();
  bool _obscure = true;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_password.text.isEmpty) {
      setState(() => _error = 'Nhập mật khẩu tài khoản');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final ok = await ref.read(biometricLoginProvider.notifier).enableWithPassword(_password.text);
      if (!mounted) return;
      if (ok) {
        Navigator.of(context).pop(true);
      } else {
        setState(() => _saving = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = AppException.from(e).message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.status.label;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Bật đăng nhập bằng $label', style: context.textStyles.titleLarge),
            Gaps.v4,
            Text(
              'Nhập mật khẩu một lần. Lần sau chỉ cần $label, mật khẩu được lưu an toàn trong máy.',
              style: context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
            ),
            Gaps.v16,
            if (_error case final e?) ...[
              AppBanner(message: e, tone: AppTone.danger),
              Gaps.v12,
            ],
            TextField(
              controller: _password,
              enabled: !_saving,
              autofocus: true,
              obscureText: _obscure,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  tooltip: _obscure ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            Gaps.v16,
            AppPrimaryButton(label: 'Bật', loading: _saving, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
