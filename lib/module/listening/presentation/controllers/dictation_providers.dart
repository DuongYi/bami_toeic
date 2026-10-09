import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../test/data/models/test_models.dart';
import '../../../test/data/test_repository.dart';

part 'dictation_providers.g.dart';

/// Các đoạn audio có transcript của 1 Part (1–4) trong 1 đề, dùng để chép chính tả.
@riverpod
Future<List<QuestionGroup>> dictationClips(Ref ref, String testId, int part) async {
  final detail = await ref.watch(testRepositoryProvider).fetchTest(testId);
  return [
    for (final g in detail.groups)
      if (g.part == part && g.audioUrl != null && (g.transcript?.trim().isNotEmpty ?? false)) g,
  ];
}
