import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../controllers/login_controller.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _obscure = true;
  bool _submitted = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    TextInput.finishAutofillContext(); // gợi ý lưu mật khẩu vào trình quản lý mật khẩu
    // Router tự chuyển trang khi đăng nhập thành công.
    ref
        .read(loginControllerProvider.notifier)
        .submit(email: _email.text.trim(), password: _password.text);
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Nhập email của bạn';
    if (!_emailPattern.hasMatch(value)) return 'Email không hợp lệ';
    return null;
  }

  String? _validatePassword(String? v) => (v ?? '').isEmpty ? 'Nhập mật khẩu' : null;

  @override
  Widget build(BuildContext context) {
    final login = ref.watch(loginControllerProvider);
    final loading = login.isLoading;
    final error = login.hasError ? AppException.from(login.error!).message : null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, // icon status bar sáng trên header màu primary
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const _BrandHeader(),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: AppSizes.formMaxWidth),
                        child: Padding(
                          padding: AppInsets.cardLarge,
                          child: AutofillGroup(
                            child: Form(
                              key: _formKey,
                              autovalidateMode: _submitted
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              onChanged: ref.read(loginControllerProvider.notifier).clearError,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Semantics(
                                    header: true,
                                    child: Text(
                                      'Đăng nhập',
                                      style: context.textStyles.headlineSmall,
                                    ),
                                  ),
                                  Gaps.v4,
                                  Text(
                                    'Dùng tài khoản đã được cấp để tiếp tục ôn luyện.',
                                    style: context.textStyles.bodyMedium?.copyWith(
                                      color: context.colors.onSurfaceVariant,
                                    ),
                                  ),
                                  Gaps.v24,
                                  AnimatedSize(
                                    duration: AppMotion.of(context, AppMotion.medium),
                                    curve: AppMotion.standard,
                                    child: error == null
                                        ? const SizedBox(width: double.infinity)
                                        : Padding(
                                            padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                                            child: AppBanner(message: error, tone: AppTone.danger),
                                          ),
                                  ),
                                  TextFormField(
                                    controller: _email,
                                    enabled: !loading,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      hintText: 'ban@example.com',
                                      prefixIcon: Icon(Icons.mail_outline_rounded),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    autofillHints: const [
                                      AutofillHints.email,
                                      AutofillHints.username,
                                    ],
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                                    validator: _validateEmail,
                                  ),
                                  Gaps.v16,
                                  TextFormField(
                                    controller: _password,
                                    focusNode: _passwordFocus,
                                    enabled: !loading,
                                    obscureText: _obscure,
                                    decoration: InputDecoration(
                                      labelText: 'Mật khẩu',
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
                                    autofillHints: const [AutofillHints.password],
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => _submit(),
                                    validator: _validatePassword,
                                  ),
                                  Gaps.v24,
                                  AppPrimaryButton(
                                    label: 'Đăng nhập',
                                    icon: Icons.login_rounded,
                                    loading: loading,
                                    onPressed: _submit,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SafeArea(
                      top: false,
                      child: Padding(padding: AppInsets.cardLarge, child: _PrivateAppNote()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Header thương hiệu: nền primary, logo, tên app, các tính năng chính.
class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    final fg = context.surfaces.onHero;
    final decor = fg.withValues(alpha: 0.08);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppRadius.xl)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: context.surfaces.hero,
          ),
        ),
        child: Stack(
          children: [
            // Hoạ tiết trang trí, ẩn với screen reader.
            Positioned(
              top: -AppSizes.brandMark,
              right: -AppSizes.brandMark,
              child: ExcludeSemantics(
                child: _Circle(size: AppSizes.brandMark * 3, color: decor),
              ),
            ),
            Positioned(
              bottom: -AppSizes.brandMark / 2,
              left: -AppSizes.brandMark / 2,
              child: ExcludeSemantics(
                child: _Circle(size: AppSizes.brandMark * 1.5, color: decor),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s24,
                  AppSpacing.s32,
                  AppSpacing.s24,
                  AppSpacing.s32,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: AppSizes.brandMark,
                        height: AppSizes.brandMark,
                        decoration: BoxDecoration(color: fg, borderRadius: AppRadius.brXl),
                        child: Icon(
                          Icons.school_rounded,
                          size: AppSizes.iconXl,
                          color: context.surfaces.hero.first,
                          semanticLabel: 'Logo Bami TOEIC',
                        ),
                      ),
                      Gaps.v16,
                      Text(
                        'Bami TOEIC',
                        style: context.textStyles.headlineMedium?.copyWith(
                          color: fg,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Gaps.v4,
                      Text(
                        'Ôn luyện mỗi ngày, chinh phục mục tiêu TOEIC',
                        textAlign: TextAlign.center,
                        style: context.textStyles.bodyMedium?.copyWith(color: fg),
                      ),
                      Gaps.v24,
                      const Wrap(
                        alignment: WrapAlignment.center,
                        spacing: AppSpacing.s8,
                        runSpacing: AppSpacing.s8,
                        children: [
                          _FeaturePill(icon: Icons.quiz_outlined, label: 'Luyện đề'),
                          _FeaturePill(icon: Icons.style_outlined, label: 'Từ vựng'),
                          _FeaturePill(icon: Icons.insights_outlined, label: 'Tiến độ'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.surfaces.onHero;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s4),
      decoration: BoxDecoration(
        color: onPrimary.withValues(alpha: 0.16),
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.full)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSizes.iconSm, color: onPrimary),
          Gaps.h4,
          Text(label, style: context.textStyles.labelLarge?.copyWith(color: onPrimary)),
        ],
      ),
    );
  }
}

/// Ghi chú cuối form: app cá nhân, không có đăng ký.
class _PrivateAppNote extends StatelessWidget {
  const _PrivateAppNote();

  @override
  Widget build(BuildContext context) {
    final color = context.colors.onSurfaceVariant;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.verified_user_outlined, size: AppSizes.iconSm, color: color),
        Gaps.h8,
        Flexible(
          child: Text(
            'Ứng dụng cá nhân · không mở đăng ký tài khoản mới',
            textAlign: TextAlign.center,
            style: context.textStyles.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
