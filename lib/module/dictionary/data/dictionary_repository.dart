import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../helper/word_match.dart';
import 'dictionary_api.dart';
import 'models/dict_models.dart';

part 'dictionary_repository.g.dart';

@Riverpod(keepAlive: true)
DictionaryRepository dictionaryRepository(Ref ref) => DictionaryRepository(
  DictionaryApi(ref.watch(dioProvider)),
  FreeDictionaryApi(ref.watch(externalDioProvider)),
);

class DictionaryRepository {
  DictionaryRepository(this._api, this._en);

  final DictionaryApi _api;
  final FreeDictionaryApi _en;

  Future<List<DictSuggestion>> suggest(String query) {
    final q = WordMatch.normalize(query);
    if (q.isEmpty) return Future.value(const []);
    return _api.suggest(DictSuggestQuery(q));
  }

  /// Tra chính xác; từ đơn thử thêm dạng gốc (invoices → invoice, planned → plan),
  /// lấy mục khớp dạng gần với chữ gốc nhất.
  Future<DictLookup> lookup(String query) async {
    final q = WordMatch.normalize(query);
    if (q.isEmpty) return DictLookup(query: query);
    final candidates = q.contains(' ') ? [q] : WordMatch.stems(q).toList();
    final found = {for (final e in await _api.lookup(DictLookupQuery(candidates))) e.wordKey: e};
    return DictLookup(query: q, entry: candidates.map((c) => found[c]).nonNulls.firstOrNull);
  }

  /// Định nghĩa Anh–Anh; rỗng khi API không có từ này.
  Future<List<EnEntry>> english(String word) async {
    try {
      return await _en.entries(WordMatch.normalize(word));
    } on Object catch (e) {
      if (AppException.from(e) is NotFoundException) return const [];
      rethrow;
    }
  }
}
