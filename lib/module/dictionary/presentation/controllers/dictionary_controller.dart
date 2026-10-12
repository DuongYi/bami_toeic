import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../helper/word_match.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../test/data/in_progress_store.dart';
import '../../../vocab/data/models/vocab_models.dart';
import '../../../vocab/presentation/controllers/vocab_controller.dart';
import '../../data/dictionary_repository.dart';
import '../../data/models/dict_models.dart';
import '../../data/translate_repository.dart';

part 'dictionary_controller.g.dart';

/// Gợi ý khi gõ (widget tự debounce trước khi đổi [query]).
@riverpod
Future<List<DictSuggestion>> dictSuggestions(Ref ref, String query) =>
    ref.watch(dictionaryRepositoryProvider).suggest(query);

/// Mục Anh–Việt của 1 từ.
@riverpod
Future<DictLookup> dictLookup(Ref ref, String query) =>
    ref.watch(dictionaryRepositoryProvider).lookup(query);

/// Định nghĩa Anh–Anh (API ngoài, có thể chậm/lỗi – chỉ là phần bổ sung).
@riverpod
Future<List<EnEntry>> enEntries(Ref ref, String word) =>
    ref.watch(dictionaryRepositoryProvider).english(word);

/// Dịch câu / đoạn Anh → Việt (Google Dịch).
@riverpod
Future<Translation> translation(Ref ref, String text) =>
    ref.watch(translateRepositoryProvider).translate(text);

/// Số từ trong đoạn chữ – từ 5 từ trở lên thì dịch thay vì tra từ điển.
int wordCount(String text) => text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;

/// Ngưỡng: cụm ≤ [maxLookupWords] từ vẫn tra từ điển được (cụm động từ, thành ngữ).
const maxLookupWords = 4;

/// Từ đã tra gần đây (lưu trên máy, theo user), mới nhất đứng đầu.
@Riverpod(keepAlive: true)
class DictHistory extends _$DictHistory {
  static const max = 30;
  static String _key(String? uid) => 'dict/history@${uid ?? 'anon'}';

  @override
  Future<List<String>> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getStringList(_key(ref.watch(currentUserIdProvider))) ?? const [];
  }

  Future<void> add(String word) async {
    final w = word.trim();
    if (w.isEmpty) return;
    final current = state.value ?? await future;
    await _save(
      [w, ...current.where((x) => x.toLowerCase() != w.toLowerCase())].take(max).toList(),
    );
  }

  Future<void> remove(String word) async => _save([...(state.value ?? await future)]..remove(word));

  Future<void> clear() => _save(const []);

  Future<void> _save(List<String> words) async {
    state = AsyncData(words);
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setStringList(_key(ref.read(currentUserIdProvider)), words);
  }
}

/// Sổ từ riêng của user (từ tự lưu), theo từ viết thường.
@riverpod
Future<Map<String, VocabItem>> notebookWords(Ref ref) async {
  final items = await ref.watch(vocabListProvider.future);
  return {
    for (final v in items)
      if (!v.isShared) WordMatch.normalize(v.word): v,
  };
}

/// Từ trong kho chung (ETS) khớp với chữ tra – hiện kèm để biết từ này có trong đề.
@riverpod
List<VocabItem> bankMatches(Ref ref, String query) {
  final items = ref.watch(vocabListProvider).value ?? const [];
  return WordMatch.find(items.where((v) => v.isShared), query, (v) => v.word).take(3).toList();
}
