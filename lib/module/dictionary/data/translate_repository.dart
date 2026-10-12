import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/app_exception.dart';
import '../../../core/network/dio_client.dart';
import 'dictionary_api.dart';
import 'models/dict_models.dart';

part 'translate_repository.g.dart';

@Riverpod(keepAlive: true)
TranslateRepository translateRepository(Ref ref) =>
    TranslateRepository(GoogleTranslateApi(ref.watch(externalDioProvider)));

/// Dịch câu / đoạn Anh → Việt. Đổi nhà cung cấp chỉ cần sửa class này.
class TranslateRepository {
  TranslateRepository(this._api);

  final GoogleTranslateApi _api;

  /// Giới hạn độ dài 1 lần dịch (đủ cho 1 bài đọc Part 7).
  static const maxLength = 5000;

  Future<Translation> translate(String text) async {
    final source = text.trim().replaceAll(RegExp(r'[ \t]+'), ' ');
    if (source.isEmpty) return const Translation(source: '', sentences: []);
    if (source.length > maxLength) {
      throw const UnknownException('Đoạn quá dài, hãy chọn ít hơn $maxLength ký tự.');
    }
    final raw = await _api.translate(source);
    final parts = raw is List ? raw.firstOrNull : null;
    if (parts is! List) throw const UnknownException('Không đọc được kết quả dịch.');
    return Translation(
      source: source,
      sentences: [
        for (final p in parts)
          if (p case [final String text, final String src, ...]) (source: src, text: text),
      ],
    );
  }
}
