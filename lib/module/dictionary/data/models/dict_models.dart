import 'package:freezed_annotation/freezed_annotation.dart';

part 'dict_models.freezed.dart';
part 'dict_models.g.dart';

// ---------- Anh–Việt (bảng dict_entries trên Supabase) ----------

/// 1 nghĩa: loại từ (n, v, adj…), nghĩa tiếng Việt, câu ví dụ.
@freezed
abstract class DictSense with _$DictSense {
  const factory DictSense({
    @JsonKey(name: 'p') String? pos,
    @JsonKey(name: 'm') required String meaning,
    @JsonKey(name: 'e') String? example,
  }) = _DictSense;

  factory DictSense.fromJson(Map<String, dynamic> json) => _$DictSenseFromJson(json);
}

@freezed
abstract class DictEntry with _$DictEntry {
  const DictEntry._();

  const factory DictEntry({
    required String wordKey,
    required String word,
    String? ipa,
    @Default(<DictSense>[]) List<DictSense> senses,
  }) = _DictEntry;

  factory DictEntry.fromJson(Map<String, dynamic> json) => _$DictEntryFromJson(json);

  /// Nghĩa theo loại từ, giữ thứ tự xuất hiện.
  Map<String?, List<DictSense>> get byPos {
    final out = <String?, List<DictSense>>{};
    for (final s in senses) {
      (out[s.pos] ??= []).add(s);
    }
    return out;
  }
}

/// Kết quả gợi ý khi gõ; [fuzzy] = tìm gần đúng (gõ sai chính tả).
@freezed
abstract class DictSuggestion with _$DictSuggestion {
  const factory DictSuggestion({
    required String word,
    String? ipa,
    String? meaning,
    @Default(false) bool fuzzy,
  }) = _DictSuggestion;

  factory DictSuggestion.fromJson(Map<String, dynamic> json) => _$DictSuggestionFromJson(json);
}

/// Kết quả tra 1 từ: [entry] null = không có trong từ điển Anh–Việt.
/// [query] là chữ người dùng tra, khác `entry.word` khi khớp dạng gốc (invoices → invoice).
class DictLookup {
  const DictLookup({required this.query, this.entry});

  final String query;
  final DictEntry? entry;

  String get word => entry?.word ?? query;
}

// ---------- Anh–Anh (dictionaryapi.dev, JSON camelCase) ----------

@freezed
abstract class EnEntry with _$EnEntry {
  const EnEntry._();

  const factory EnEntry({
    required String word,
    String? phonetic,
    @Default(<EnPhonetic>[]) List<EnPhonetic> phonetics,
    @Default(<EnMeaning>[]) List<EnMeaning> meanings,
  }) = _EnEntry;

  factory EnEntry.fromJson(Map<String, dynamic> json) => _$EnEntryFromJson(json);
}

@freezed
abstract class EnPhonetic with _$EnPhonetic {
  const factory EnPhonetic({String? text, String? audio}) = _EnPhonetic;

  factory EnPhonetic.fromJson(Map<String, dynamic> json) => _$EnPhoneticFromJson(json);
}

@freezed
abstract class EnMeaning with _$EnMeaning {
  const factory EnMeaning({
    @JsonKey(name: 'partOfSpeech') required String partOfSpeech,
    @Default(<EnDefinition>[]) List<EnDefinition> definitions,
    @Default(<String>[]) List<String> synonyms,
    @Default(<String>[]) List<String> antonyms,
  }) = _EnMeaning;

  factory EnMeaning.fromJson(Map<String, dynamic> json) => _$EnMeaningFromJson(json);
}

@freezed
abstract class EnDefinition with _$EnDefinition {
  const factory EnDefinition({
    required String definition,
    String? example,
    @Default(<String>[]) List<String> synonyms,
  }) = _EnDefinition;

  factory EnDefinition.fromJson(Map<String, dynamic> json) => _$EnDefinitionFromJson(json);
}

/// Các mục Anh–Anh của 1 từ (API có thể trả nhiều mục đồng âm).
extension EnEntries on List<EnEntry> {
  /// File phát âm thật, ưu tiên giọng Mỹ.
  String? get audioUrl {
    final all = [
      for (final e in this)
        for (final p in e.phonetics)
          if (p.audio case final a? when a.isNotEmpty) a,
    ];
    return all.where((a) => a.contains('-us')).firstOrNull ?? all.firstOrNull;
  }
}

// ---------- Gửi lên API ----------

@JsonSerializable(createFactory: false)
class DictSuggestQuery {
  const DictSuggestQuery(this.query, {this.limit = 20});

  @JsonKey(name: 'p_query')
  final String query;
  @JsonKey(name: 'p_limit')
  final int limit;

  Map<String, dynamic> toJson() => _$DictSuggestQueryToJson(this);
}

@JsonSerializable(createFactory: false)
class DictLookupQuery {
  const DictLookupQuery(this.words);

  @JsonKey(name: 'p_words')
  final List<String> words;

  Map<String, dynamic> toJson() => _$DictLookupQueryToJson(this);
}

// ---------- Dịch câu / đoạn ----------

/// 1 câu gốc và bản dịch của nó.
typedef TranslatedSentence = ({String source, String text});

class Translation {
  const Translation({required this.source, required this.sentences});

  final String source;
  final List<TranslatedSentence> sentences;

  String get text => sentences.map((s) => s.text).join().trim();
}
