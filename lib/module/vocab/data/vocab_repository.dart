import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/media/media_repository.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/postgrest.dart';
import '../../../helper/srs.dart';
import 'models/vocab_models.dart';
import 'vocab_api.dart';

part 'vocab_repository.g.dart';

@Riverpod(keepAlive: true)
VocabApi vocabApi(Ref ref) => VocabApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
VocabRepository vocabRepository(Ref ref) =>
    VocabRepository(ref.watch(vocabApiProvider), ref.watch(mediaRepositoryProvider));

class VocabRepository {
  VocabRepository(this._api, this._media);

  final VocabApi _api;
  final MediaRepository _media;

  Future<List<VocabItem>> fetchAll() async {
    final items = await _api.getVocab();
    // Audio phát âm nằm trong bucket media riêng tư → ký URL tạm.
    final signed = await _media.signAll([for (final v in items) ?v.audioUrl]);
    return [
      for (final v in items) v.audioUrl == null ? v : v.copyWith(audioUrl: signed[v.audioUrl]),
    ];
  }

  Future<void> save(VocabInput input, {String? id}) =>
      id == null ? _api.createVocab(input) : _api.updateVocab(input, id: Pg.eq(id));

  Future<void> delete(String id) => _api.deleteVocab(id: Pg.eq(id));

  Future<void> saveReview({
    required String userId,
    required String vocabId,
    required SrsState state,
  }) => _api.upsertReview(
    VocabReviewUpsert(
      userId: userId,
      vocabId: vocabId,
      ease: state.ease,
      intervalDays: state.intervalDays,
      repetitions: state.repetitions,
      dueAt: state.dueAt.toUtc(),
      lastReviewedAt: DateTime.now().toUtc(),
    ),
  );
}
