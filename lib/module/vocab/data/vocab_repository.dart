import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/media/media_repository.dart';
import '../../../core/network/app_exception.dart';
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
    // Lấy hết các trang (mỗi trang ≤ 1000 dòng, giới hạn Max Rows của Supabase).
    final all = <VocabItem>[];
    while (true) {
      final page = await _api.getVocab(offset: all.length);
      all.addAll(page);
      if (page.length < VocabApi.pageSize) break;
    }
    // Từ riêng trùng (word, topic) với bộ chung → hiện bản riêng, ẩn bản chung.
    final own = {
      for (final v in all)
        if (!v.isShared) (v.word.toLowerCase(), v.topic),
    };
    final items = [
      for (final v in all)
        if (!v.isShared || !own.contains((v.word.toLowerCase(), v.topic))) v,
    ];
    // Audio phát âm nằm trong bucket media riêng tư → ký URL tạm.
    final signed = await _media.signAll([for (final v in items) ?v.audioUrl]);
    return [
      for (final v in items) v.audioUrl == null ? v : v.copyWith(audioUrl: signed[v.audioUrl]),
    ];
  }

  /// Thêm từ (thành từ riêng của user). Sửa từ bộ chung mà không có quyền
  /// → tạo bản riêng thay thế (bộ chung giữ nguyên cho người khác).
  Future<void> save(VocabInput input, {String? id}) async {
    if (id == null) return _api.createVocab(input);
    final updated = await _api.updateVocab(input, id: Pg.eq(id));
    if (updated.isEmpty) await _api.createVocab(input);
  }

  Future<void> delete(String id) async {
    final deleted = await _api.deleteVocab(id: Pg.eq(id));
    if (deleted.isEmpty) {
      throw const ForbiddenException('Từ này thuộc bộ từ chung, chỉ admin mới xoá được.');
    }
  }

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
