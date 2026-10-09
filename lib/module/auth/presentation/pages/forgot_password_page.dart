import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../controllers/password_reset_controller.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Quên mật khẩu: (1) nhập email → nhận mã; (2) nhập mã + mật khẩu mới → đăng nhập luôn.
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  static const _minPassword = 8;

  /// Supabase mặc định chỉ cho gửi lại email sau 60 giây.
  static const _resendAfter = 60;

  final _emailForm = GlobalKey<FormState>();
  final _resetForm = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.initialEmail);
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _obscure = true;

  /// Email đã gửi mã; null = đang ở bước 1.
  String? _sentTo;
  int _cooldown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _cooldown = _resendAfter);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || _cooldown <= 1) {
        t.cancel();
        if (mounted) setState(() => _cooldown = 0);
        return;
      }
      setState(() => _cooldown--);
    });
  }

  Future<void> _sendCode() async {
    if (_sentTo == null && !_emailForm.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final email = _sentTo ?? _email.text.trim();
    final ok = await ref.read(passwordResetControllerProvider.notifier).sendCode(email);
    if (!ok || !mounted) return;
    final resend = _sentTo != null;
    setState(() => _sentTo = email);
    _startCooldown();
    if (resend) showAppSnackBar(context, 'Đã gửi lại mã', tone: AppTone.success);
  }

  void _reset() {
    if (!_resetForm.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    ref
        .read(passwordResetControllerProvider.notifier)
        .reset(email: _sentTo!, code: _code.text.trim(), password: _password.text);
  }

  void _changeEmail() {
    ref.read(passwordResetControllerProvider.notifier).clearError();
    _timer?.cancel();
    setState(() {
      _sentTo = null;
      _cooldown = 0;
      _code.clear();
    });
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Nhập email của bạn';
    if (!_emailPattern.hasMatch(value)) return 'Email không hợp lệ';
    return null;
  }

  // Độ dài mã OTP chỉnh được trong Supabase (mặc định 6) → nhận 6–10 chữ số.
  String? _validateCode(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Nhập mã trong email';
    if (!RegExp(r'^\d{6,10}$').hasMatch(value)) return 'Mã gồm 6 chữ số trở lên';
    return null;
  }

  String? _validatePassword(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Nhập mật khẩu mới';
    if (value.length < _minPassword) return 'Mật khẩu cần ít nhất $_minPassword ký tự';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(passwordResetControllerProvider);
    final loading = state.isLoading;
    final error = state.hasError ? AppException.from(state.error!).message : null;
    final sentTo = _sentTo;
    final muted = context.textStyles.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant);

    return Scaffold(
      appBar: AppBar(title: const Text('Quên mật khẩu')),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: AppInsets.screen,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.formMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  sentTo == null
                      ? 'Nhập email đã đăng ký. Bami TOEIC sẽ gửi mã để bạn đặt mật khẩu mới.'
                      : 'Đã gửi mã tới $sentTo. Mở email (kiểm tra cả mục Spam) rồi nhập mã '
                            'và mật khẩu mới bên dưới.',
                  style: muted,
                ),
                Gaps.v16,
                if (error != null) ...[AppBanner(message: error, tone: AppTone.danger), Gaps.v16],
                if (sentTo == null)
                  Form(
                    key: _emailForm,
                    onChanged: ref.read(passwordResetControllerProvider.notifier).clearError,
                    child: TextFormField(
                      controller: _email,
                      enabled: !loading,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.send,
                      onFieldSubmitted: (_) => _sendCode(),
                      validator: _validateEmail,
                    ),
                  )
                else
                  AutofillGroup(
                    child: Form(
                      key: _resetForm,
                      onChanged: ref.read(passwordResetControllerProvider.notifier).clearError,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _code,
                            enabled: !loading,
                            decoration: const InputDecoration(
                              labelText: 'Mã xác nhận',
                              prefixIcon: Icon(Icons.pin_outlined),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            autofillHints: const [AutofillHints.oneTimeCode],
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                            validator: _validateCode,
                          ),
                          Gaps.v16,
                          TextFormField(
                            controller: _password,
                            focusNode: _passwordFocus,
                            enabled: !loading,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              labelText: 'Mật khẩu mới',
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                tooltip: _obscure ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                            ),
                            autofillHints: const [AutofillHints.newPassword],
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _reset(),
                            validator: _validatePassword,
                          ),
                          Gaps.v8,
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              TextButton(
                                onPressed: loading ? null : _changeEmail,
                                child: const Text('Đổi email'),
                              ),
                              TextButton(
                                onPressed: loading || _cooldown > 0 ? null : _sendCode,
                                child: Text(
                                  _cooldown > 0 ? 'Gửi lại mã sau ${_cooldown}s' : 'Gửi lại mã',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        child: AppPrimaryButton(
          label: sentTo == null ? 'Gửi mã' : 'Đặt lại mật khẩu',
          icon: sentTo == null ? Icons.send_rounded : Icons.lock_reset_rounded,
          loading: loading,
          onPressed: sentTo == null ? _sendCode : _reset,
        ),
      ),
    );
  }
}
