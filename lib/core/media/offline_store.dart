import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../module/test/data/in_progress_store.dart';

part 'offline_store.g.dart';

/// Thông tin 1 đề đã tải về máy.
class OfflineEntry {
  const OfflineEntry({required this.bytes, required this.savedAt, required this.files});

  final int bytes;
  final DateTime savedAt;

  /// Đường dẫn object trong bucket → tên file trong thư mục của đề
  final Map<String, String> files;

  factory OfflineEntry.fromJson(Map<String, dynamic> j) => OfflineEntry(
    bytes: j['bytes'] as int,
    savedAt: DateTime.parse(j['saved_at'] as String),
    files: (j['files'] as Map).cast<String, String>(),
  );

  Map<String, dynamic> toJson() => {
    'bytes': bytes,
    'saved_at': savedAt.toIso8601String(),
    'files': files,
  };
}

@Riverpod(keepAlive: true)
OfflineStore offlineStore(Ref ref) => OfflineStore(ref);

/// Media + nội dung đề lưu trên máy (thư mục `Application Support/offline/<testId>/`).
/// Chỉ mục nằm trong SharedPreferences.
class OfflineStore {
  OfflineStore(this._ref);

  final Ref _ref;
  static const _indexKey = 'offline/index';
  Map<String, OfflineEntry>? _index;

  Future<Directory> dirOf(String testId) async {
    final base = await getApplicationSupportDirectory();
    return Directory('${base.path}/offline/$testId');
  }

  Future<Map<String, OfflineEntry>> index() async {
    if (_index != null) return _index!;
    final raw = (await _ref.read(sharedPreferencesProvider.future)).getString(_indexKey);
    try {
      _index = raw == null
          ? {}
          : {
              for (final e in (jsonDecode(raw) as Map<String, dynamic>).entries)
                e.key: OfflineEntry.fromJson(e.value as Map<String, dynamic>),
            };
    } catch (_) {
      _index = {};
    }
    return _index!;
  }

  Future<void> _saveIndex() async => (await _ref.read(sharedPreferencesProvider.future))
      .setString(_indexKey, jsonEncode({for (final e in _index!.entries) e.key: e.value.toJson()}));

  /// Đường dẫn object → file trên máy, của mọi đề đã tải.
  Future<Map<String, String>> localFiles() async {
    final out = <String, String>{};
    for (final e in (await index()).entries) {
      final dir = await dirOf(e.key);
      for (final f in e.value.files.entries) {
        out[f.key] = '${dir.path}/${f.value}';
      }
    }
    return out;
  }

  Future<void> put(String testId, OfflineEntry entry) async {
    (await index())[testId] = entry;
    await _saveIndex();
  }

  Future<void> remove(String testId) async {
    (await index()).remove(testId);
    await _saveIndex();
    final dir = await dirOf(testId);
    if (dir.existsSync()) await dir.delete(recursive: true);
  }

  /// Nội dung đề (JSON) để mở khi mất mạng.
  Future<File> contentFile(String testId) async => File('${(await dirOf(testId)).path}/test.json');
}
