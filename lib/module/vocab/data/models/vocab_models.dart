import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../helper/srs.dart';

part 'vocab_models.freezed.dart';
part 'vocab_models.g.dart';

@freezed
abstract class VocabReview with _$VocabReview {
  const factory VocabReview({
    required double ease,
    required int intervalDays,
    required int repetitions,
    required DateTime dueAt,
  }) = _VocabReview;

  factory VocabReview.fromJson(Map<String, dynamic> json) => _$VocabReviewFromJson(json);
}

@freezed
abstract class VocabItem with _$VocabItem {
  const VocabItem._();

  const factory VocabItem({
    required String id,
    required String word,
    String? ipa,
    String? pos,
    required String meaning,
    String? example,
    String? exampleMeaning,
    required String topic,
    String? audioUrl,

    /// Embed `vocab_reviews(*)`; RLS chỉ trả về lịch ôn của user hiện tại (0 hoặc 1 dòng).
    @JsonKey(name: 'vocab_reviews', includeToJson: false)
    @Default(<VocabReview>[])
    List<VocabReview> reviews,
  }) = _VocabItem;

  factory VocabItem.fromJson(Map<String, dynamic> json) => _$VocabItemFromJson(json);

  VocabReview? get review => reviews.firstOrNull;

  /// null = từ mới, chưa học
  SrsState? get srs => switch (review) {
    null => null,
    final r => SrsState(
      ease: r.ease,
      intervalDays: r.intervalDays,
      repetitions: r.repetitions,
      due: r.dueAt.toLocal(),
    ),
  };

  bool get isNew => review == null;
  bool isDue(DateTime now) => review != null && !review!.dueAt.isAfter(now);
}

// ---------- Gửi lên API ----------

@JsonSerializable(createFactory: false)
class VocabInput {
  const VocabInput({
    required this.word,
    this.ipa,
    this.pos,
    required this.meaning,
    this.example,
    this.exampleMeaning,
    required this.topic,
  });

  final String word;
  final String? ipa;
  final String? pos;
  final String meaning;
  final String? example;
  final String? exampleMeaning;
  final String topic;

  Map<String, dynamic> toJson() => _$VocabInputToJson(this);
}

@JsonSerializable(createFactory: false)
class VocabReviewUpsert {
  const VocabReviewUpsert({
    required this.userId,
    required this.vocabId,
    required this.ease,
    required this.intervalDays,
    required this.repetitions,
    required this.dueAt,
    required this.lastReviewedAt,
  });

  final String userId;
  final String vocabId;
  final double ease;
  final int intervalDays;
  final int repetitions;

  /// UTC
  final DateTime dueAt;

  /// UTC
  final DateTime lastReviewedAt;

  Map<String, dynamic> toJson() => _$VocabReviewUpsertToJson(this);
}
