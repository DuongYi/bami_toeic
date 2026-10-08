import 'package:bami_toeic/core/network/app_exception.dart';
import 'package:bami_toeic/core/network/auth_interceptor.dart';
import 'package:bami_toeic/core/network/error_interceptor.dart';
import 'package:bami_toeic/core/storage/token_storage.dart';
import 'package:bami_toeic/module/auth/data/models/session.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_adapter.dart';

/// TokenStorage chỉ giữ trong bộ nhớ.
class MemoryTokenStorage extends TokenStorage {
  MemoryTokenStorage(this.session) : super(const FlutterSecureStorage());

  Session? session;

  @override
  Future<Session?> read() async => session;
  @override
  Future<void> save(Session s) async => session = s;
  @override
  Future<void> clear() async => session = null;
}

Session _session(String access, {int expiresInSec = 3600}) => Session(
  accessToken: access,
  refreshToken: 'refresh-$access',
  expiresAt: DateTime.now().millisecondsSinceEpoch ~/ 1000 + expiresInSec,
  user: const AuthUser(id: 'u1'),
);

Map<String, dynamic> _tokenJson(String access) => {
  'access_token': access,
  'refresh_token': 'refresh-$access',
  'expires_at': DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
  'user': {'id': 'u1'},
};

void main() {
  late MemoryTokenStorage storage;
  late FakeAdapter adapter;
  late Dio dio;
  var expired = 0;

  void setUpDio(FakeHandler handler) {
    adapter = FakeAdapter(handler);
    final options = BaseOptions(baseUrl: 'https://x.supabase.co');
    final plain = Dio(options)..httpClientAdapter = adapter;
    dio = Dio(options)
      ..httpClientAdapter = adapter
      ..interceptors.addAll([
        AuthInterceptor(storage: storage, refreshDio: plain, onSessionExpired: () => expired++),
        ErrorInterceptor(),
      ]);
  }

  setUp(() => expired = 0);

  test('gắn Bearer token vào request', () async {
    storage = MemoryTokenStorage(_session('A'));
    setUpDio((_) => (200, []));
    await dio.get<dynamic>('/rest/v1/tests');
    expect(adapter.requests.single.headers['Authorization'], 'Bearer A');
  });

  test('401 → refresh token → gửi lại request với token mới', () async {
    storage = MemoryTokenStorage(_session('A'));
    setUpDio((o) {
      if (o.path == '/auth/v1/token') return (200, _tokenJson('B'));
      return o.headers['Authorization'] == 'Bearer B'
          ? (200, ['ok'])
          : (401, {'message': 'JWT expired'});
    });

    final res = await dio.get<dynamic>('/rest/v1/tests');

    expect(res.data, ['ok']);
    expect(storage.session!.accessToken, 'B');
    expect(adapter.requests.map((r) => r.path), [
      '/rest/v1/tests',
      '/auth/v1/token',
      '/rest/v1/tests',
    ]);
  });

  test('nhiều request cùng 401 chỉ refresh 1 lần', () async {
    storage = MemoryTokenStorage(_session('A'));
    setUpDio((o) {
      if (o.path == '/auth/v1/token') return (200, _tokenJson('B'));
      return o.headers['Authorization'] == 'Bearer B' ? (200, []) : (401, null);
    });

    await Future.wait([dio.get<dynamic>('/a'), dio.get<dynamic>('/b'), dio.get<dynamic>('/c')]);

    expect(adapter.requests.where((r) => r.path == '/auth/v1/token'), hasLength(1));
  });

  test('token sắp hết hạn → refresh trước khi gửi', () async {
    storage = MemoryTokenStorage(_session('A', expiresInSec: 10));
    setUpDio((o) => o.path == '/auth/v1/token' ? (200, _tokenJson('B')) : (200, []));

    await dio.get<dynamic>('/rest/v1/tests');

    expect(adapter.requests.last.headers['Authorization'], 'Bearer B');
  });

  test('refresh token bị từ chối → xoá phiên và báo hết hạn', () async {
    storage = MemoryTokenStorage(_session('A'));
    setUpDio(
      (o) => o.path == '/auth/v1/token' ? (400, {'msg': 'Invalid Refresh Token'}) : (401, null),
    );

    await expectLater(
      dio.get<dynamic>('/rest/v1/tests'),
      throwsA(isA<DioException>().having((e) => e.error, 'error', isA<UnauthorizedException>())),
    );
    expect(storage.session, isNull);
    expect(expired, 1);
  });

  test('lỗi PostgREST được map sang AppException với message của server', () async {
    storage = MemoryTokenStorage(null);
    setUpDio((_) => (409, {'code': '23505', 'message': 'duplicate key value'}));

    try {
      await dio.post<dynamic>('/rest/v1/vocab');
      fail('phải throw');
    } on DioException catch (e) {
      final ex = AppException.from(e);
      expect(ex, isA<ServerException>());
      expect(ex.message, 'duplicate key value');
    }
  });

  test('thiếu bảng (PGRST205) → hướng dẫn chạy schema.sql', () async {
    storage = MemoryTokenStorage(null);
    setUpDio(
      (_) => (404, {'code': 'PGRST205', 'message': "Could not find the table 'public.tests'"}),
    );
    try {
      await dio.get<dynamic>('/rest/v1/tests');
      fail('phải throw');
    } on DioException catch (e) {
      expect(AppException.from(e).message, contains('schema.sql'));
    }
  });
}
