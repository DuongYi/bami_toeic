import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/env.dart';
import 'core/design_system/design_system.dart';
import 'routes/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Env.isConfigured) {
    runApp(const _MissingEnvApp());
    return;
  }
  runApp(const ProviderScope(child: BamiToeicApp()));
}

class BamiToeicApp extends ConsumerWidget {
  const BamiToeicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Bami TOEIC',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      highContrastTheme: AppTheme.lightHighContrast(),
      highContrastDarkTheme: AppTheme.darkHighContrast(),
      routerConfig: ref.watch(routerProvider),
    );
  }
}

class _MissingEnvApp extends StatelessWidget {
  const _MissingEnvApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: const Scaffold(
        body: Center(
          child: Padding(
            padding: AppInsets.cardLarge,
            child: Text(
              'Thiếu cấu hình Supabase.\n\nChạy app với:\nflutter run --dart-define-from-file=env.json',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
