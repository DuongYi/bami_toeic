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

    /// Người học đánh dấu "đã biết" → không đưa vào phiên học nữa.
    @Default(false) bool known,

    /// Lần đầu học từ này (giới hạn số từ mới mỗi ngày).
    DateTime? learnedAt,
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

    /// Nguồn trong đề, vd. "ETS 2026 Test 3 · câu 147" (null = từ thêm tay).
    String? source,

    /// null = từ trong bộ chung (vd. ETS 2026); có giá trị = từ riêng của user này
    String? userId,

    /// Embed `vocab_reviews(*)`; RLS chỉ trả về lịch ôn của user hiện tại (0 hoặc 1 dòng).
    @JsonKey(name: 'vocab_reviews', includeToJson: false)
    @Default(<VocabReview>[])
    List<VocabReview> reviews,
  }) = _VocabItem;

  factory VocabItem.fromJson(Map<String, dynamic> json) => _$VocabItemFromJson(json);

  VocabReview? get review => reviews.firstOrNull;

  bool get isShared => userId == null;

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

  /// Chưa học lần nào.
  bool get isNew => review == null;

  bool get isKnown => review?.known ?? false;

  /// Đã thuộc: tự đánh dấu "đã biết" hoặc khoảng ôn ≥ [masteredDays] ngày.
  bool get isMastered => isKnown || (review?.intervalDays ?? 0) >= masteredDays;

  /// Đã học nhưng chưa thuộc.
  bool get isLearning => review != null && !isMastered;

  bool isDue(DateTime now) => review != null && !isKnown && !review!.dueAt.isAfter(now);

  /// Bắt đầu học trong ngày [now] (theo giờ máy) – đếm vào chỉ tiêu từ mới hôm nay.
  bool learnedOn(DateTime now) {
    final at = review?.learnedAt?.toLocal();
    return at != null && !isKnown && at.year == now.year && at.month == now.month && at.day == now.day;
  }

  static final _testRe = RegExp(r'Test (\d+)');
  static final _questionRe = RegExp(r'câu (\d+)');

  /// Số đề ETS chứa từ này (Test N), null nếu không rõ.
  int? get sourceTest => switch (source) {
    final s? => int.tryParse(_testRe.firstMatch(s)?.group(1) ?? ''),
    null => null,
  };

  /// Số câu đầu tiên trong đề có từ này – dùng để học theo thứ tự xuất hiện.
  int? get sourceQuestion => switch (source) {
    final s? => int.tryParse(_questionRe.firstMatch(s)?.group(1) ?? ''),
    null => null,
  };
}

/// Khoảng ôn (ngày) từ đó coi như đã thuộc.
const masteredDays = 21;

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
    this.source,
  });

  final String word;
  final String? ipa;
  final String? pos;
  final String meaning;
  final String? example;
  final String? exampleMeaning;
  final String topic;
  final String? source;

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
    this.known = false,
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

  final bool known;

  Map<String, dynamic> toJson() => _$VocabReviewUpsertToJson(this);
}
