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
    ref
        .read(loginControllerProvider.notifier)
        .submit(email: _email.text.trim(), password: _password.text);
  }

  void _fillDemoAccount() {
    setState(() {
      _email.text = 'me@example.com';
      _password.text = '123456';
    });
    _submit();
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
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Semantics(
                                        header: true,
                                        child: Text(
                                          'Đăng nhập học viên',
                                          style: context.textStyles.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Gaps.v4,
                                      Text(
                                        'Mở khoá toàn bộ 100+ đề ETS & giải thích AI',
                                        style: context.textStyles.bodySmall?.copyWith(
                                          color: context.colors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Gaps.h8,
                                const ProBadge(label: 'VIP', mini: true),
                              ],
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
                                labelText: 'Email học viên',
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
                            Gaps.v8,
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  showAppSnackBar(
                                    context,
                                    'Vui lòng liên hệ ban quản trị để cấp lại mật khẩu.',
                                    tone: AppTone.info,
                                  );
                                },
                                child: const Text('Quên mật khẩu?'),
                              ),
                            ),
                            Gaps.v12,
                            AppPrimaryButton(
                              label: 'Đăng nhập',
                              icon: Icons.arrow_forward_rounded,
                              loading: loading,
                              onPressed: _submit,
                            ),
                            Gaps.v24,
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
                                  child: Text(
                                    'Hoặc học thử nhanh',
                                    style: context.textStyles.bodySmall?.copyWith(
                                      color: context.colors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            Gaps.v16,
                            FilledButton.tonal(
                              onPressed: loading ? null : _fillDemoAccount,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.bolt_rounded, size: AppSizes.iconSm),
                                  Gaps.h8,
                                  Text('Trải nghiệm tài khoản mẫu (1-Click)'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.s24,
                    AppSpacing.s8,
                    AppSpacing.s24,
                    AppSpacing.s24,
                  ),
                  child: _CommercialTrustNote(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Header thương hiệu thương mại: Nền gradient rực rỡ, logo nổi bật, huy hiệu uy tín.
class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    final fg = context.surfaces.onHero;
    final decor = fg.withValues(alpha: 0.12);

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
            Positioned(
              top: -AppSizes.brandMark * 0.8,
              right: -AppSizes.brandMark * 0.8,
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s12,
                          vertical: AppSpacing.s4,
                        ),
                        decoration: BoxDecoration(
                          color: fg.withValues(alpha: 0.2),
                          borderRadius: AppRadius.brFull,
                          border: Border.all(color: fg.withValues(alpha: 0.35)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.workspace_premium_rounded, size: AppSizes.iconSm, color: fg),
                            Gaps.h4,
                            Text(
                              'ỨNG DỤNG LUYỆN THI TOEIC SỐ 1',
                              style: context.textStyles.labelSmall?.copyWith(
                                color: fg,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gaps.v16,
                      Container(
                        width: AppSizes.brandMark,
                        height: AppSizes.brandMark,
                        decoration: BoxDecoration(
                          color: fg,
                          borderRadius: AppRadius.brXl,
                          boxShadow: [
                            BoxShadow(
                              color: context.colors.shadow.withValues(alpha: 0.15),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.school_rounded,
                          size: AppSizes.iconHero,
                          color: context.surfaces.hero.first,
                          semanticLabel: 'Logo Bami TOEIC',
                        ),
                      ),
                      Gaps.v16,
                      Text(
                        'Bami TOEIC',
                        style: context.textStyles.headlineMedium?.copyWith(
                          color: fg,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Gaps.v4,
                      Text(
                        'Chinh phục 800+ TOEIC cùng Trí tuệ Nhân tạo',
                        textAlign: TextAlign.center,
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: fg.withValues(alpha: 0.95),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gaps.v16,
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: AppSpacing.s8,
                        runSpacing: AppSpacing.s8,
                        children: const [
                          _FeaturePill(icon: Icons.quiz_outlined, label: 'Đề ETS 2024'),
                          _FeaturePill(icon: Icons.auto_awesome_rounded, label: 'Giải thích AI'),
                          _FeaturePill(icon: Icons.psychology_rounded, label: 'Flashcard SRS'),
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
        color: onPrimary.withValues(alpha: 0.18),
        borderRadius: AppRadius.brFull,
        border: Border.all(color: onPrimary.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSizes.iconSm, color: onPrimary),
          Gaps.h4,
          Text(
            label,
            style: context.textStyles.labelLarge?.copyWith(
              color: onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ghi chú uy tín thương mại ở cuối form đăng nhập.
class _CommercialTrustNote extends StatelessWidget {
  const _CommercialTrustNote();

  @override
  Widget build(BuildContext context) {
    final color = context.colors.onSurfaceVariant;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.verified_user_rounded, size: AppSizes.iconSm, color: color),
        Gaps.h8,
        Flexible(
          child: Text(
            'Hơn 50,000 học viên tin dùng · Dữ liệu chuẩn hoá theo format ETS',
            textAlign: TextAlign.center,
            style: context.textStyles.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
