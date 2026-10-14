import 'package:bami_toeic/core/biometric/biometric_auth.dart';
import 'package:bami_toeic/core/network/app_exception.dart';
import 'package:bami_toeic/core/storage/credential_storage.dart';
import 'package:bami_toeic/module/auth/data/models/session.dart';
import 'package:bami_toeic/module/auth/presentation/controllers/auth_controller.dart';
import 'package:bami_toeic/module/auth/presentation/controllers/biometric_login_controller.dart';
import 'package:bami_toeic/module/auth/presentation/controllers/login_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';

class _FakeBiometric extends BiometricAuth {
  _FakeBiometric() : super(LocalAuthentication());

  BiometricKind? kind = BiometricKind.faceId;
  bool hardware = false;
  bool approve = true;
  int prompts = 0;

  @override
  Future<BiometricKind?> availableKind() async => kind;

  @override
  Future<bool> hasHardware() async => hardware || kind != null;

  @override
  Future<bool> authenticate(String reason) async {
    prompts++;
    return approve;
  }
}

class _MemoryCredentials extends CredentialStorage {
  _MemoryCredentials() : super(const FlutterSecureStorage());

  ({String email, String password})? saved;

  @override
  Future<({String email, String password})?> read() async => saved;

  @override
  Future<void> save({required String email, required String password}) async =>
      saved = (email: email, password: password);

  @override
  Future<void> clear() async => saved = null;
}

/// Máy chủ giả: chỉ chấp nhận mật khẩu [password].
class _FakeAuth extends AuthController {
  static String password = 'secret123';

  @override
  Future<Session?> build() async => null;

  @override
  Future<void> signIn({required String email, required String password}) async {
    if (password != _FakeAuth.password) {
      throw const UnauthorizedException('Email hoặc mật khẩu không đúng.');
    }
    state = AsyncData(
      Session(
        accessToken: 'a',
        refreshToken: 'r',
        expiresAt: 4102444800,
        user: AuthUser(id: 'u1', email: email),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // AppLifecycleListener cần binding
  late _FakeBiometric bio;
  late _MemoryCredentials store;
  late ProviderContainer c;

  setUp(() async {
    _FakeAuth.password = 'secret123';
    bio = _FakeBiometric();
    store = _MemoryCredentials();
    c = ProviderContainer(
      overrides: [
        biometricAuthProvider.overrideWithValue(bio),
        credentialStorageProvider.overrideWithValue(store),
        authControllerProvider.overrideWith(_FakeAuth.new),
      ],
    );
    addTearDown(c.dispose);
    // Như lúc mở app: trạng thái đăng nhập đã đọc xong trước khi người dùng thao tác.
    await c.read(authControllerProvider.future);
  });

  Future<void> login(String password, {bool enable = true}) async {
    final sub = c.listen(loginControllerProvider, (_, _) {});
    await c
        .read(loginControllerProvider.notifier)
        .submit(email: 'me@x.com', password: password, enableBiometric: enable);
    sub.close();
  }

  test('máy không có sinh trắc → ẩn tính năng', () async {
    bio.kind = null;
    final s = await c.read(biometricLoginProvider.future);
    expect(s.available, isFalse);
    expect(s.enabled, isFalse);
    expect(s.needsEnrollment, isFalse);
  });

  test('có phần cứng nhưng chưa cài Face ID → cần hướng dẫn cài', () async {
    bio
      ..kind = null
      ..hardware = true;
    final s = await c.read(biometricLoginProvider.future);
    expect(s.available, isFalse);
    expect(s.needsEnrollment, isTrue);
  });

  test('tick bật khi đăng nhập → lưu sau khi đăng nhập thành công', () async {
    await login('secret123');
    expect(store.saved?.password, 'secret123');
    expect((await c.read(biometricLoginProvider.future)).email, 'me@x.com');
  });

  test('sai mật khẩu → không lưu gì', () async {
    await login('wrong');
    expect(store.saved, isNull);
    expect(c.read(authControllerProvider).value, isNull);
  });

  test('huỷ Face ID khi bật → vẫn đăng nhập, không lưu', () async {
    bio.approve = false;
    await login('secret123');
    expect(c.read(authControllerProvider).value, isNotNull);
    expect(store.saved, isNull);
  });

  test('đăng nhập bằng Face ID dùng thông tin đã lưu', () async {
    store.saved = (email: 'me@x.com', password: 'secret123');
    expect(await c.read(biometricLoginProvider.notifier).signIn(), isTrue);
    expect(c.read(authControllerProvider).value?.user.email, 'me@x.com');
  });

  test('huỷ Face ID khi đăng nhập → không đăng nhập', () async {
    store.saved = (email: 'me@x.com', password: 'secret123');
    bio.approve = false;
    expect(await c.read(biometricLoginProvider.notifier).signIn(), isFalse);
    expect(c.read(authControllerProvider).value, isNull);
  });

  test('mật khẩu đã đổi ở nơi khác → xoá thông tin đã lưu và báo lỗi rõ', () async {
    store.saved = (email: 'me@x.com', password: 'old-pass');
    await expectLater(
      c.read(biometricLoginProvider.notifier).signIn(),
      throwsA(isA<UnauthorizedException>().having((e) => e.message, 'message', contains('Face ID'))),
    );
    expect(store.saved, isNull);
    expect((await c.read(biometricLoginProvider.future)).enabled, isFalse);
  });

  test('đổi mật khẩu → cập nhật mật khẩu đã lưu cho đúng email', () async {
    store.saved = (email: 'me@x.com', password: 'old-pass');
    final n = c.read(biometricLoginProvider.notifier);
    await n.onPasswordChanged(email: 'other@x.com', password: 'new-pass');
    expect(store.saved?.password, 'old-pass');
    await n.onPasswordChanged(email: 'me@x.com', password: 'new-pass');
    expect(store.saved?.password, 'new-pass');
  });

  test('bật từ Cài đặt kiểm tra mật khẩu với máy chủ', () async {
    await login('secret123', enable: false);
    final n = c.read(biometricLoginProvider.notifier);
    await expectLater(n.enableWithPassword('wrong'), throwsA(isA<UnauthorizedException>()));
    expect(store.saved, isNull);
    expect(await n.enableWithPassword('secret123'), isTrue);
    expect(store.saved?.email, 'me@x.com');
  });
}
