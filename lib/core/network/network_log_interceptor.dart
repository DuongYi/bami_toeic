import 'package:dio/dio.dart';

import '../logging/app_log.dart';
import 'app_exception.dart';

/// Ghi log mọi request/response vào [AppLog]: dòng tóm tắt + chi tiết (query, header,
/// body, thời gian, mã lỗi PostgREST…). Token/mật khẩu được che.
///
/// Đặt SAU AuthInterceptor (thấy header thật) và ErrorInterceptor (có message đã dịch).
class NetworkLogInterceptor extends Interceptor {
  NetworkLogInterceptor({this.tag});

  /// Phân biệt Dio phụ, vd. "refresh"
  final String? tag;
  static const _startKey = 'log_start_us';

  /// Header phản hồi có ích khi tra log phía Supabase.
  static const _usefulResponseHeaders = [
    'content-type',
    'content-length',
    'content-range',
    'sb-request-id',
    'x-request-id',
    'sb-gateway-version',
    'cf-ray',
    'retry-after',
  ];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startKey] = DateTime.now().microsecondsSinceEpoch;
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final o = response.requestOptions;
    final ms = _elapsed(o);
    AppLog.instance.add(
      LogEntry(
        level: LogLevel.info,
        kind: LogKind.network,
        title: '${_line(o)} → ${response.statusCode} ($ms ms${_size(response.data)})',
        statusCode: response.statusCode,
        durationMs: ms,
        details: [
          ..._request(o),
          ..._responseHeaders(response),
          'response body: ${_preview(response.data)}',
        ].join('\n'),
      ),
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final o = err.requestOptions;
    final ms = _elapsed(o);
    final res = err.response;
    final status = res?.statusCode;
    final data = res?.data;
    final appError = AppException.from(err);
    // PostgREST / Supabase Auth trả lỗi dạng {code, message, details, hint} hoặc {error, msg}
    final pg = data is Map
        ? [
            for (final k in [
              'code',
              'error_code',
              'message',
              'msg',
              'error',
              'error_description',
              'details',
              'hint',
            ])
              if (data[k] != null && '${data[k]}'.isNotEmpty) '$k: ${data[k]}',
          ]
        : const <String>[];
    AppLog.instance.add(
      LogEntry(
        level: LogLevel.error,
        kind: LogKind.network,
        title:
            '${_line(o)} → ${status ?? err.type.name} ($ms ms) · ${Redact.text(appError.message)}',
        statusCode: status,
        durationMs: ms,
        details: [
          'dio: ${err.type.name}${err.message == null ? '' : ' · ${Redact.text(err.message!)}'}',
          if (err.error != null && err.error is! AppException)
            'cause: ${Redact.text('${err.error}')}',
          'app message: ${appError.message} (${appError.runtimeType})',
          ...pg.map(Redact.text),
          ..._request(o),
          if (res != null) ..._responseHeaders(res),
          if (data != null) 'response body: ${_preview(data, max: 4000)}',
        ].join('\n'),
      ),
    );
    handler.next(err);
  }

  // ---------- định dạng ----------

  int _elapsed(RequestOptions o) {
    final start = o.extra[_startKey];
    return start is int ? ((DateTime.now().microsecondsSinceEpoch - start) / 1000).round() : -1;
  }

  String _line(RequestOptions o) {
    final retry = o.extra['authRetried'] == true ? ' (gửi lại sau refresh)' : '';
    return '${tag == null ? '' : '[$tag] '}${o.method} ${o.uri.path}$retry';
  }

  List<String> _request(RequestOptions o) => [
    'url: ${Redact.text(o.uri.toString())}',
    if (o.queryParameters.isNotEmpty)
      'query: ${o.queryParameters.entries.map((e) => '${e.key}=${Redact.isSecret(e.key) ? '***' : e.value}').join('&')}',
    'request headers: ${{for (final h in o.headers.entries) h.key: Redact.isSecret(h.key) ? Redact.mask(h.value) : h.value}}',
    if (o.data != null) 'request body: ${_preview(o.data)}',
  ];

  List<String> _responseHeaders(Response<dynamic> r) {
    final picked = <String, String>{};
    for (final h in _usefulResponseHeaders) {
      final v = r.headers.value(h);
      if (v != null) picked[h] = v;
    }
    return [if (picked.isNotEmpty) 'response headers: $picked'];
  }

  String _size(Object? data) => switch (data) {
    List() => ', ${data.length} dòng',
    String() when data.length > 1024 => ', ${(data.length / 1024).toStringAsFixed(1)} KB',
    _ => '',
  };

  /// Danh sách dài chỉ in vài phần tử đầu để log không quá nặng.
  String _preview(Object? data, {int max = 2500}) {
    if (data is List && data.length > 3) {
      return '${data.length} phần tử, 2 phần tử đầu:\n${Redact.pretty(data.take(2).toList(), maxChars: max)}';
    }
    return Redact.pretty(data, maxChars: max);
  }
}
