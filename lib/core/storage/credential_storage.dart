import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'credential_storage.g.dart';

@Riverpod(keepAlive: true)
CredentialStorage credentialStorage(Ref ref) => CredentialStorage(
  const FlutterSecureStorage(
    // Chỉ đọc được khi máy đang mở khoá, không theo bản sao lưu sang máy khác.
    iOptions: IOSOptions(accessibility: KeychainAccessibility.unlocked_this_device),
  ),
);

/// Email + mật khẩu cho đăng nhập bằng Face ID / vân tay, lưu trong Keychain / Keystore.
/// Chỉ ghi khi người dùng chủ động bật; chỉ đọc sau khi đã xác thực sinh trắc thành công.
class CredentialStorage {
  CredentialStorage(this._storage);

  static const _key = 'biometric_credentials';
  final FlutterSecureStorage _storage;

  Future<({String email, String password})?> read() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw == null) return null;
      final m = jsonDecode(raw) as Map<String, dynamic>;
      return (email: m['email'] as String, password: m['password'] as String);
    } catch (_) {
      return null; // dữ liệu hỏng / Keychain lỗi → coi như chưa bật
    }
  }

  Future<void> save({required String email, required String password}) =>
      _storage.write(key: _key, value: jsonEncode({'email': email, 'password': password}));

  Future<void> clear() => _storage.delete(key: _key);
}
