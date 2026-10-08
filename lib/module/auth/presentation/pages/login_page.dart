import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../controllers/login_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    // Router tự chuyển trang khi đăng nhập thành công.
    ref
        .read(loginControllerProvider.notifier)
        .submit(email: _email.text.trim(), password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final login = ref.watch(loginControllerProvider);
    final loading = login.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppInsets.cardLarge,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSizes.formMaxWidth),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      size: AppSizes.iconHero,
                      color: context.colors.primary,
                    ),
                    Gaps.v12,
                    Text(
                      'Bami TOEIC',
                      textAlign: TextAlign.center,
                      style: context.textStyles.headlineMedium,
                    ),
                    Gaps.v32,
                    TextField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                    ),
                    Gaps.v12,
                    TextField(
                      controller: _password,
                      decoration: const InputDecoration(labelText: 'Mật khẩu'),
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => _submit(),
                    ),
                    if (login case AsyncError(:final error)) ...[
                      Gaps.v12,
                      Text(
                        AppException.from(error).message,
                        style: TextStyle(color: context.colors.error),
                      ),
                    ],
                    Gaps.v24,
                    AppPrimaryButton(label: 'Đăng nhập', loading: loading, onPressed: _submit),
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
