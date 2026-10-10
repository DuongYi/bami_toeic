import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/env.dart';
import 'core/design_system/design_system.dart';
import 'core/logging/app_log.dart';
import 'core/logging/provider_log_observer.dart';
import 'core/network/app_exception.dart';
import 'module/debug/presentation/widgets/debug_log_button.dart';
import 'module/settings/presentation/controllers/settings_controller.dart';
import 'routes/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _captureErrors();
  if (!Env.isConfigured) {
    runApp(const _MissingEnvApp());
    return;
  }
  runApp(
    const ProviderScope(
      retry: providerRetry,
      observers: [ProviderLogObserver()],
      child: BamiToeicApp(),
    ),
  );
}

/// Lỗi Flutter (build/layout…) và lỗi async không ai bắt → ghi vào nhật ký.
void _captureErrors() {
  final presentError = FlutterError.onError;
  FlutterError.onError = (details) {
    AppLog.e(
      'Flutter: ${details.exceptionAsString().split('\n').first}',
      error: details.exception,
      stackTrace: details.stack,
      kind: LogKind.crash,
    );
    presentError?.call(details); // vẫn in khung lỗi đỏ như cũ
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLog.e('Lỗi chưa xử lý: $error', error: error, stackTrace: stack, kind: LogKind.crash);
    return false; // để Flutter in tiếp như mặc định
  };
}

/// Nút mở Nhật ký debug: bản debug/profile, trừ khi chạy test (giữ ảnh golden ổn định).
final _showDebugButton =
    !kReleaseMode && !kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST');

/// Riverpod 3 mặc định tự thử lại MỌI exception 10 lần (~40 giây + timeout mạng),
/// trong lúc đó màn hình chỉ hiện vòng tải → trông như "load vô hạn", lỗi thật bị che.
/// Chỉ thử lại lỗi mạng tạm thời (tối đa 2 lần); lỗi khác hiện ngay kèm nút Thử lại.
Duration? providerRetry(int retryCount, Object error) {
  if (retryCount >= 2 || AppException.from(error) is! NetworkException) return null;
  return Duration(seconds: 1 << retryCount);
}

class BamiToeicApp extends ConsumerWidget {
  const BamiToeicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final font = ref.watch(appFontFamilyProvider);
    final effectiveFont = font == AppFontFamilyNotifier.fontSystem ? null : font;

    return MaterialApp.router(
      title: 'Bami TOEIC',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light(fontFamily: effectiveFont),
      darkTheme: AppTheme.dark(fontFamily: effectiveFont),
      highContrastTheme: AppTheme.lightHighContrast(fontFamily: effectiveFont),
      highContrastDarkTheme: AppTheme.darkHighContrast(fontFamily: effectiveFont),
      routerConfig: ref.watch(routerProvider),
      builder: _showDebugButton
          ? (context, child) => DebugLogButton(
              onOpen: () => ref.read(routerProvider).push(Routes.debugLogs),
              child: child ?? const SizedBox.shrink(),
            )
          : null,
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
