import 'package:bami_toeic/core/media/media_api.dart';
import 'package:bami_toeic/core/media/media_repository.dart';
import 'package:bami_toeic/module/vocab/data/models/vocab_models.dart';
import 'package:bami_toeic/module/vocab/data/vocab_api.dart';
import 'package:bami_toeic/module/vocab/data/vocab_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Giả lập Supabase Max Rows = 1000 với tổng [total] từ.
class _PagedApi implements VocabApi {
  _PagedApi(this.total);

  final int total;
  final offsets = <int>[];

  @override
  Future<List<VocabItem>> getVocab({
    String select = '',
    String order = '',
    int offset = 0,
    int limit = VocabApi.pageSize,
  }) async {
    offsets.add(offset);
    final end = (offset + limit).clamp(0, total);
    return [
      for (var i = offset; i < end; i++)
        VocabItem(id: 'v$i', word: 'w$i', meaning: 'm', topic: 'General'),
    ];
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _NoSign implements MediaApi {
  @override
  Future<List<SignedObject>> signMany(String bucket, SignRequest body) async => const [];
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final total in [0, 999, 1000, 1250, 2500]) {
    test('lấy đủ $total từ qua nhiều trang', () async {
      final api = _PagedApi(total);
      final c = ProviderContainer(
        overrides: [
          vocabApiProvider.overrideWithValue(api),
          mediaApiProvider.overrideWithValue(_NoSign()),
        ],
      );
      addTearDown(c.dispose);
      final list = await c.read(vocabRepositoryProvider).fetchAll();
      expect(list.length, total);
      expect(list.map((v) => v.id).toSet().length, total);
      expect(api.offsets.last, (total ~/ 1000) * 1000);
    });
  }
}
