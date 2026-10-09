import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/app_exception.dart';
import 'app_log.dart';

/// Ghi log khi một provider lỗi (kể cả lỗi bị Riverpod tự thử lại → trước đây chỉ thấy vòng tải).
final class ProviderLogObserver extends ProviderObserver {
  const ProviderLogObserver();

  @override
  void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace) {
    final p = context.provider;
    final name = p.name ?? p.runtimeType.toString();
    final arg = p.argument == null ? '' : '(${p.argument})';
    AppLog.instance.add(
      LogEntry(
        level: LogLevel.error,
        kind: LogKind.provider,
        title: '$name$arg lỗi: ${Redact.text(AppException.from(error).message)}',
        details: [
          'error type: ${error.runtimeType}',
          'error: ${Redact.text(error.toString())}',
          AppLog.shortStack(stackTrace),
        ].join('\n'),
      ),
    );
  }
}
