import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/storage/token_storage.dart';
import 'auth_api.dart';
import 'models/session.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthApi authApi(Ref ref) => AuthApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(authApiProvider), ref.watch(tokenStorageProvider));

class AuthRepository {
  AuthRepository(this._api, this._storage);

  final AuthApi _api;
  final TokenStorage _storage;

  Future<Session?> currentSession() => _storage.read();

  Future<Session> signIn({required String email, required String password}) async {
    final session = await _api.signInWithPassword({'email': email, 'password': password});
    await _storage.save(session);
    return session;
  }

  Future<void> signOut() async {
    try {
      await _api.signOut();
    } catch (_) {
      // Vẫn xoá phiên cục bộ dù server lỗi / offline.
    }
    await _storage.clear();
  }
}
