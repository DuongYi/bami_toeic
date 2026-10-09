import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/env.dart';
import '../network/dio_client.dart';
import 'media_api.dart';
import 'offline_store.dart';

part 'media_repository.g.dart';

@Riverpod(keepAlive: true)
MediaApi mediaApi(Ref ref) => MediaApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
MediaRepository mediaRepository(Ref ref) => MediaRepository(
  ref.watch(mediaApiProvider),
  ref.watch(offlineStoreProvider),
  ref.watch(dioProvider),
);

/// Bucket `media` là riêng tư: DB vẫn lưu URL dạng public (`…/object/public/media/<path>`),
/// app đổi sang URL ký tạm (không cần header → dùng được cho just_audio, Image.network).
class MediaRepository {
  MediaRepository(this._api, this._offline, this._dio);

  final MediaApi _api;
  final OfflineStore _offline;
  final Dio _dio;

  static const bucket = 'media';
  static const _ttl = Duration(hours: 12);

  /// Ký lại khi URL còn dưới mức này (đủ cho 1 bài thi 2 tiếng).
  static const _minRemaining = Duration(hours: 3);
  static final _publicPrefix = '${Env.supabaseUrl}/storage/v1/object/public/$bucket/';

  final _cache = <String, ({String url, DateTime expiresAt})>{};

  /// Đường dẫn object trong bucket, hoặc null nếu không phải file của bucket này.
  static String? objectPath(String url) => url.startsWith(_publicPrefix)
      ? Uri.decodeFull(url.substring(_publicPrefix.length).split('?').first)
      : null;

  /// Ký hàng loạt; trả map URL gốc → URL đã ký (URL không thuộc bucket giữ nguyên).
  /// File đã tải offline → `file://…` (không cần mạng).
  Future<Map<String, String>> signAll(Iterable<String> urls, {bool preferLocal = true}) async {
    final now = DateTime.now();
    final out = <String, String>{};
    final pending = <String, String>{}; // path → url gốc
    final local = preferLocal ? await _offline.localFiles() : const <String, String>{};
    for (final url in urls.toSet()) {
      final cached = _cache[url];
      final path = objectPath(url);
      final file = path == null ? null : local[path];
      if (file != null && File(file).existsSync()) {
        out[url] = Uri.file(file).toString();
      } else if (path == null) {
        out[url] = url;
      } else if (cached != null && cached.expiresAt.difference(now) > _minRemaining) {
        out[url] = cached.url;
      } else {
        pending[path] = url;
      }
    }
    final paths = pending.keys.toList();
    for (var i = 0; i < paths.length; i += 200) {
      final chunk = paths.sublist(i, (i + 200).clamp(0, paths.length));
      final signed = await _api.signMany(
        bucket,
        SignRequest(paths: chunk, expiresIn: _ttl.inSeconds),
      );
      for (final s in signed) {
        final original = pending[s.path];
        if (original == null || s.signedUrl == null) continue;
        final rel = s.signedUrl!;
        final full = '${Env.supabaseUrl}${rel.startsWith('/storage/v1') ? '' : '/storage/v1'}$rel';
        _cache[original] = (url: full, expiresAt: now.add(_ttl));
        out[original] = full;
      }
    }
    // Ký lỗi (file không tồn tại…) → giữ URL gốc, widget tự báo lỗi tải.
    for (final url in pending.values) {
      out.putIfAbsent(url, () => url);
    }
    return out;
  }

  /// Tải 1 file (URL đã ký) về [savePath]; trả về số byte.
  Future<int> download(String signedUrl, String savePath) async {
    await _dio.download(signedUrl, savePath);
    return File(savePath).lengthSync();
  }
}
