import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../module/auth/data/models/session.dart';

part 'token_storage.g.dart';

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) => TokenStorage(const FlutterSecureStorage());

/// Lưu phiên đăng nhập trong Keychain / Keystore. Có cache trong bộ nhớ.
class TokenStorage {
  TokenStorage(this._storage);

  static const _key = 'auth_session';
  final FlutterSecureStorage _storage;
  Session? _cache;
  bool _loaded = false;

  Future<Session?> read() async {
    if (_loaded) return _cache;
    final raw = await _storage.read(key: _key);
    _cache = raw == null ? null : Session.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    _loaded = true;
    return _cache;
  }

  Future<void> save(Session session) async {
    _cache = session;
    _loaded = true;
    await _storage.write(key: _key, value: jsonEncode(session.toJson()));
  }

  Future<void> clear() async {
    _cache = null;
    _loaded = true;
    await _storage.delete(key: _key);
  }
}
