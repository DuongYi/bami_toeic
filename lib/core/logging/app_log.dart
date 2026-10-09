import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

enum LogKind {
  /// Request/response qua Dio
  network,

  /// Provider Riverpod lỗi
  provider,

  /// Lỗi Flutter / Dart không bắt được
  crash,

  /// Log chủ động trong code
  app,
}

class LogEntry {
  LogEntry({
    required this.level,
    required this.kind,
    required this.title,
    this.details,
    this.statusCode,
    this.durationMs,
  }) : time = DateTime.now();

  final DateTime time;
  final LogLevel level;
  final LogKind kind;

  /// Một dòng tóm tắt, vd. "GET /rest/v1/vocab → 400 (98 ms)"
  final String title;

  /// Chi tiết nhiều dòng (header, body, stack trace…), đã che thông tin nhạy cảm.
  final String? details;
  final int? statusCode;
  final int? durationMs;

  bool get isError => level == LogLevel.error;

  String get _clock {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(time.hour)}:${two(time.minute)}:${two(time.second)}.'
        '${time.millisecond.toString().padLeft(3, '0')}';
  }

  static const _levelTag = {
    LogLevel.debug: 'DEBUG',
    LogLevel.info: 'INFO ',
    LogLevel.warning: 'WARN ',
    LogLevel.error: 'ERROR',
  };
  static const _kindTag = {
    LogKind.network: 'NET',
    LogKind.provider: 'PROVIDER',
    LogKind.crash: 'CRASH',
    LogKind.app: 'APP',
  };

  String get header => '[$_clock] ${_levelTag[level]} ${_kindTag[kind]} $title';

  /// Dạng văn bản để in ra console / sao chép gửi đi.
  String format() {
    final d = details?.trimRight();
    if (d == null || d.isEmpty) return header;
    return '$header\n${d.split('\n').map((l) => '    $l').join('\n')}';
  }
}

/// Nhật ký của app: giữ ~800 dòng gần nhất trong bộ nhớ (xem ở màn "Nhật ký debug"),
/// đồng thời in ra debug console ở bản debug/profile.
class AppLog extends ChangeNotifier {
  AppLog._();

  static final instance = AppLog._();
  static const _capacity = 800;

  final _entries = <LogEntry>[];

  /// Mới nhất ở cuối.
  List<LogEntry> get entries => List.unmodifiable(_entries);
  int get errorCount => _entries.where((e) => e.isError).length;

  /// In ra console (tắt trong test để output gọn).
  static bool printToConsole = kDebugMode || kProfileMode;

  void add(LogEntry entry) {
    _entries.add(entry);
    if (_entries.length > _capacity) _entries.removeRange(0, _entries.length - _capacity);
    if (printToConsole) _print(entry);
    // Có thể được gọi giữa lúc build (vd. provider lỗi) → báo UI ở microtask sau.
    scheduleMicrotask(notifyListeners);
  }

  void clear() {
    _entries.clear();
    notifyListeners();
  }

  /// Toàn bộ (hoặc [only]) dưới dạng văn bản, kèm phần đầu mô tả môi trường.
  String export([Iterable<LogEntry>? only]) {
    final list = only ?? _entries;
    return [
      '=== Bami TOEIC log · ${DateTime.now().toIso8601String()} · '
          '${kReleaseMode
              ? 'release'
              : kProfileMode
              ? 'profile'
              : 'debug'} · '
          '${defaultTargetPlatform.name} · ${list.length} dòng ===',
      for (final e in list) e.format(),
    ].join('\n');
  }

  static void _print(LogEntry e) {
    // debugPrint tự chia nhỏ dòng dài, không làm rớt log trên Android.
    final text = e.isError || e.level == LogLevel.warning ? e.format() : e.header;
    for (final line in text.split('\n')) {
      debugPrint(line);
    }
  }

  // ---------- Viết tắt ----------

  static void d(String title, {String? details}) => instance.add(
    LogEntry(level: LogLevel.debug, kind: LogKind.app, title: title, details: details),
  );

  static void i(String title, {String? details}) => instance.add(
    LogEntry(level: LogLevel.info, kind: LogKind.app, title: title, details: details),
  );

  static void w(String title, {String? details}) => instance.add(
    LogEntry(level: LogLevel.warning, kind: LogKind.app, title: title, details: details),
  );

  static void e(
    String title, {
    Object? error,
    StackTrace? stackTrace,
    LogKind kind = LogKind.app,
  }) => instance.add(
    LogEntry(
      level: LogLevel.error,
      kind: kind,
      title: title,
      details: [
        if (error != null) 'error: ${Redact.text(error.toString())}',
        if (stackTrace != null) shortStack(stackTrace),
      ].join('\n'),
    ),
  );

  /// Stack trace rút gọn: bỏ frame của Flutter/Dart SDK, giữ tối đa [max] dòng.
  static String shortStack(StackTrace s, {int max = 14}) {
    final lines = s.toString().split('\n').where((l) => l.trim().isNotEmpty).toList();
    final app = lines.where((l) => l.contains('package:bami_toeic/')).toList();
    final picked = (app.isNotEmpty ? app : lines).take(max).toList();
    return 'stack:\n${picked.join('\n')}';
  }
}

/// Che thông tin nhạy cảm trước khi ghi log (token, mật khẩu, khoá API).
abstract final class Redact {
  static const _secretKeys = {
    'password',
    'access_token',
    'refresh_token',
    'token',
    'apikey',
    'authorization',
    'provider_token',
    'provider_refresh_token',
  };

  static bool isSecret(String key) => _secretKeys.contains(key.toLowerCase());

  /// Giữ 4 ký tự cuối để còn đối chiếu được token nào.
  static String mask(Object? v) {
    final s = v?.toString() ?? '';
    return s.length <= 8 ? '***' : '***${s.substring(s.length - 4)}';
  }

  static Object? json(Object? data) => switch (data) {
    Map() => {
      for (final e in data.entries) e.key: isSecret('${e.key}') ? mask(e.value) : json(e.value),
    },
    List() => [for (final v in data) json(v)],
    _ => data,
  };

  static final _jwt = RegExp(r'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+');
  static final _token = RegExp(r'((?:token|password|apikey)=)[^&\s]+', caseSensitive: false);

  /// Che JWT và tham số bí mật trong chuỗi bất kỳ (URL, message lỗi…).
  static String text(String s) =>
      s.replaceAllMapped(_jwt, (m) => mask(m[0])).replaceAllMapped(_token, (m) => '${m[1]}***');

  /// JSON đẹp, đã che, cắt bớt nếu quá dài.
  static String pretty(Object? data, {int maxChars = 2500}) {
    String out;
    try {
      out = const JsonEncoder.withIndent('  ').convert(json(data));
    } catch (_) {
      out = text('$data');
    }
    return out.length <= maxChars
        ? out
        : '${out.substring(0, maxChars)}\n… (cắt, tổng ${out.length} ký tự)';
  }
}
