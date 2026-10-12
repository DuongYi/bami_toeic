import 'package:bami_toeic/core/network/error_interceptor.dart';
import 'package:bami_toeic/module/dictionary/data/dictionary_api.dart';
import 'package:bami_toeic/module/dictionary/data/dictionary_repository.dart';
import 'package:bami_toeic/module/dictionary/data/translate_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../core/fake_adapter.dart';

Dio _dio(FakeAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'https://x.supabase.co'))
      ..httpClientAdapter = adapter
      ..interceptors.add(ErrorInterceptor());

void main() {
  group('TranslateRepository', () {
    test('ghép bản dịch từng câu, gửi câu gốc trong body form', () async {
      final adapter = FakeAdapter(
        (_) => (
          200,
          [
            [
              ['Xin chào. ', 'Hello. ', null, null, 3],
              ['Hẹn gặp lại.', 'See you.', null, null, 3],
            ],
            null,
            'en',
          ],
        ),
      );
      final repo = TranslateRepository(GoogleTranslateApi(_dio(adapter)));

      final t = await repo.translate('  Hello.   See you. ');

      expect(t.text, 'Xin chào. Hẹn gặp lại.');
      expect(t.sentences.map((s) => s.source), ['Hello. ', 'See you.']);
      final req = adapter.requests.single;
      expect(req.uri.host, 'translate.googleapis.com');
      expect(req.uri.queryParameters, containsPair('tl', 'vi'));
      expect(req.data, {'q': 'Hello. See you.'});
    });

    test('kết quả sai định dạng → báo lỗi dễ hiểu', () async {
      final repo = TranslateRepository(GoogleTranslateApi(_dio(FakeAdapter((_) => (200, {})))));
      expect(
        () => repo.translate('Hello world'),
        throwsA(isA<Exception>().having((e) => '$e', 'message', contains('kết quả dịch'))),
      );
    });
  });

  group('DictionaryRepository.lookup', () {
    test('thử dạng gốc, ưu tiên dạng gần chữ gốc nhất', () async {
      final adapter = FakeAdapter(
        (_) => (
          200,
          [
            {'word_key': 'plan', 'word': 'plan', 'senses': []},
          ],
        ),
      );
      final repo = DictionaryRepository(
        DictionaryApi(_dio(adapter)),
        FreeDictionaryApi(_dio(adapter)),
      );

      final l = await repo.lookup('Planned,');

      expect(l.entry?.word, 'plan');
      expect(l.query, 'planned');
      expect((adapter.requests.single.data as Map)['p_words'], containsAll(['planned', 'plan']));
    });

    test('Anh–Anh không có từ (404) → danh sách rỗng', () async {
      final adapter = FakeAdapter((_) => (404, {'title': 'No Definitions Found'}));
      final repo = DictionaryRepository(
        DictionaryApi(_dio(adapter)),
        FreeDictionaryApi(_dio(adapter)),
      );
      expect(await repo.english('qwxz'), isEmpty);
    });
  });
}
