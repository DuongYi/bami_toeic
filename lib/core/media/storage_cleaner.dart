import 'dart:io';

import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../logging/app_log.dart';
import 'offline_store.dart';

part 'storage_cleaner.g.dart';

/// Dung lượng app đang dùng trên máy (hiện ở Cài đặt → Dữ liệu & bộ nhớ).
class StorageUsage {
  const StorageUsage({required this.cacheBytes, required this.offlineTests, required this.offlineBytes});

  /// File tạm của app và plugin (audio, ảnh, giọng đọc…), xoá thoải mái.
  final int cacheBytes;

  /// Đề đã tải để làm khi mất mạng.
  final int offlineTests;
  final int offlineBytes;
}

@riverpod
Future<StorageUsage> storageUsage(Ref ref) => ref.watch(storageCleanerProvider).usage();

@Riverpod(keepAlive: true)
StorageCleaner storageCleaner(Ref ref) => StorageCleaner(ref.watch(offlineStoreProvider));

/// Đo và dọn bộ nhớ: thư mục tạm (tmp/, Library/Caches) + cache ảnh trong RAM; đề offline xoá riêng.
class StorageCleaner {
  StorageCleaner(this._offline);

  final OfflineStore _offline;

  /// Thư mục tạm + Library/Caches (iOS); Android có thể trùng nhau thì bỏ trùng.
  Future<List<Directory>> _cacheDirs() async {
    final tmp = await getTemporaryDirectory();
    final caches = await getApplicationCacheDirectory();
    return [tmp, if (caches.path != tmp.path) caches];
  }

  Future<StorageUsage> usage() async {
    var cache = 0;
    for (final d in await _cacheDirs()) {
      cache += _sizeOf(d);
    }
    final index = await _offline.index();
    return StorageUsage(
      cacheBytes: cache,
      offlineTests: index.length,
      offlineBytes: index.values.fold(0, (s, e) => s + e.bytes),
    );
  }

  /// Xoá nội dung các thư mục tạm (giữ lại thư mục gốc) và cache ảnh. Trả về số byte đã giải phóng.
  Future<int> clearCache() async {
    var freed = 0;
    for (final d in await _cacheDirs()) {
      if (!d.existsSync()) continue;
      for (final e in d.listSync(followLinks: false)) {
        final size = e is File ? _fileSize(e) : (e is Directory ? _sizeOf(e) : 0);
        try {
          await e.delete(recursive: true);
          freed += size;
        } catch (err) {
          AppLog.w('Không xoá được file tạm', details: '${e.path}: $err'); // file đang được dùng → bỏ qua
        }
      }
    }
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
    return freed;
  }

  /// Xoá mọi đề đã tải offline. Trả về số byte đã giải phóng.
  Future<int> clearOffline() async {
    final index = Map.of(await _offline.index());
    for (final id in index.keys) {
      await _offline.remove(id);
    }
    return index.values.fold<int>(0, (s, e) => s + e.bytes);
  }

  static int _sizeOf(Directory d) {
    if (!d.existsSync()) return 0;
    var total = 0;
    try {
      for (final e in d.listSync(recursive: true, followLinks: false)) {
        if (e is File) total += _fileSize(e);
      }
    } catch (_) {
      // Thư mục bị xoá / không có quyền giữa chừng → tính phần đã đếm được.
    }
    return total;
  }

  static int _fileSize(File f) {
    try {
      return f.lengthSync();
    } catch (_) {
      return 0;
    }
  }
}
