import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import 'models/dict_models.dart';

part 'dictionary_api.g.dart';

/// Từ điển Anh–Việt trên Supabase (hàm SQL dict_suggest / dict_lookup, migration 008).
@RestApi()
abstract class DictionaryApi {
  factory DictionaryApi(Dio dio) = _DictionaryApi;

  @POST('/rest/v1/rpc/dict_suggest')
  Future<List<DictSuggestion>> suggest(@Body() DictSuggestQuery body);

  @POST('/rest/v1/rpc/dict_lookup')
  Future<List<DictEntry>> lookup(@Body() DictLookupQuery body);
}

/// Từ điển Anh–Anh miễn phí (định nghĩa, đồng nghĩa, audio phát âm thật).
@RestApi(baseUrl: 'https://api.dictionaryapi.dev/api/v2/')
abstract class FreeDictionaryApi {
  factory FreeDictionaryApi(Dio dio) = _FreeDictionaryApi;

  /// 404 khi không có từ.
  @GET('entries/en/{word}')
  Future<List<EnEntry>> entries(@Path('word') String word);
}

/// Google Dịch – endpoint KHÔNG chính thức (client=gtx), không cần key, có thể bị chặn bất cứ lúc
/// nào. Chỉ dùng qua [TranslateRepository] để dễ đổi sang dịch vụ khác.
/// Trả về mảng lồng nhau: `[[["câu dịch", "câu gốc", …], …], null, "en", …]`.
@RestApi(baseUrl: 'https://translate.googleapis.com/')
abstract class GoogleTranslateApi {
  factory GoogleTranslateApi(Dio dio) = _GoogleTranslateApi;

  @POST('translate_a/single')
  @FormUrlEncoded()
  Future<dynamic> translate(
    @Field('q') String text, {
    @Query('sl') String from = 'en',
    @Query('tl') String to = 'vi',
    @Query('client') String client = 'gtx',
    @Query('dt') String dt = 't',
  });
}
