import 'dart:convert';
import 'dart:typed_data';

import 'package:bami_toeic/core/logging/app_log.dart';
import 'package:bami_toeic/core/network/error_interceptor.dart';
import 'package:bami_toeic/core/network/network_log_interceptor.dart';
import 'package:bami_toeic/module/debug/presentation/widgets/debug_log_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Trả về 1 phản hồi cố định, không ra mạng.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.status, this.body);

  final int status;
  final Object body;

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? s, Future<void>? c) async =>
      ResponseBody.fromString(
        jsonEncode(body),
        status,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
          'sb-request-id': ['req-123'],
        },
      );

  @override
  void close({bool force = false}) {}
}

Dio _dio(int status, Object body) =>
    Dio(
        BaseOptions(
          baseUrl: 'https://x.supabase.co',
          headers: {'apikey': 'sb_publishable_ABCDEFGH1234'},
        ),
      )
      ..httpClientAdapter = _FakeAdapter(status, body)
      ..interceptors.addAll([ErrorInterceptor(), NetworkLogInterceptor()]);

void main() {
  setUp(() {
    AppLog.printToConsole = false;
    AppLog.instance.clear();
  });

  group('Redact', () {
    test('che mật khẩu/token theo khoá, giữ dữ liệu thường', () {
      final r = Redact.json({
        'email': 'a@b.c',
        'password': 'secret123',
        'nested': {'refresh_token': 'abcdefghijkl'},
      }) as Map;
      expect(r['email'], 'a@b.c');
      expect(r['password'], '***t123');
      expect((r['nested'] as Map)['refresh_token'], '***ijkl');
    });

    test('che JWT và tham số bí mật trong chuỗi', () {
      final s = Redact.text('Bearer eyJhbGciOi.eyJzdWIiOi.c2lnbmF0dXJl ?token=abc&x=1');
      expect(s, isNot(contains('eyJhbGciOi')));
      expect(s, contains('token=***'));
      expect(s, contains('x=1'));
    });
  });

  group('NetworkLogInterceptor', () {
    test('lỗi PostgREST: ghi mã lỗi, message, request id; che apikey', () async {
      final dio = _dio(400, {
        'code': 'PGRST100',
        'message': 'failed to parse filter',
        'details': 'unexpected "x"',
        'hint': null,
      });
      await expectLater(
        dio.get<dynamic>('/rest/v1/vocab', queryParameters: {'select': '*'}),
        throwsA(isA<DioException>()),
      );
      final e = AppLog.instance.entries.single;
      expect(e.level, LogLevel.error);
      expect(e.kind, LogKind.network);
      expect(e.statusCode, 400);
      expect(e.title, contains('GET /rest/v1/vocab → 400'));
      expect(e.details, contains('code: PGRST100'));
      expect(e.details, contains('message: failed to parse filter'));
      expect(e.details, contains('sb-request-id'));
      expect(e.details, isNot(contains('ABCDEFGH1234'))); // apikey đã che
      expect(e.details, contains('***1234'));
    });

    test('thành công: dòng tóm tắt có số dòng trả về', () async {
      await _dio(200, List.generate(5, (i) => {'id': i})).get<dynamic>('/rest/v1/vocab');
      final e = AppLog.instance.entries.single;
      expect(e.level, LogLevel.info);
      expect(e.title, contains('→ 200'));
      expect(e.title, contains('5 dòng'));
    });

    test('đăng nhập: không lộ mật khẩu', () async {
      await _dio(200, {
        'access_token': 'eyJa.eyJb.sig',
        'user': {'email': 'a@b.c'},
      }).post<dynamic>('/auth/v1/token', data: {'email': 'a@b.c', 'password': 'hunter2pass'});
      final text = AppLog.instance.export();
      expect(text, isNot(contains('hunter2pass')));
      expect(text, isNot(contains('eyJa.eyJb.sig')));
      expect(text, contains('a@b.c'));
    });
  });

  testWidgets('nút nhật ký nằm ngoài Navigator vẫn dựng được và mở được', (tester) async {
    var opened = 0;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => DebugLogButton(onOpen: () => opened++, child: child!),
        home: const Scaffold(body: Text('home')),
      ),
    );
    AppLog.e('boom');
    await tester.pump();
    expect(find.text('1'), findsOneWidget); // badge số lỗi
    await tester.tap(find.byIcon(Icons.receipt_long_rounded));
    expect(opened, 1);
  });
}
