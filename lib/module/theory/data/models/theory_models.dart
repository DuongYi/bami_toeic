import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';

/// Phân loại chủ điểm lý thuyết tiếng Anh TOEIC riêng biệt rõ ràng
enum TheoryCategory {
  tenses,
  sentencePatterns,
  partsOfSpeech,
  strategy,
  pronunciation;

  String get label => switch (this) {
    TheoryCategory.tenses => '12 Thì ngữ pháp',
    TheoryCategory.sentencePatterns => 'Mẫu câu & Cấu trúc',
    TheoryCategory.partsOfSpeech => 'Từ loại & Ngữ pháp',
    TheoryCategory.strategy => 'Mẹo thi Part 1–7',
    TheoryCategory.pronunciation => 'Phát âm & IPA',
  };

  String get description => switch (this) {
    TheoryCategory.tenses => 'Hiện tại, Quá khứ, Tương lai, Hoàn thành & Sự phối hợp các thì',
    TheoryCategory.sentencePatterns => 'Câu điều kiện, Bị động, Đảo ngữ, Mệnh đề quan hệ & So sánh',
    TheoryCategory.partsOfSpeech => 'Danh - Tính - Động - Trạng, Hòa hợp S-V, Liên từ & Giới từ',
    TheoryCategory.strategy => 'Chiến thuật bóc tách bẫy ETS và kỹ thuật quản lý thời gian từng Part',
    TheoryCategory.pronunciation => 'Bảng 44 âm IPA, quy tắc trọng âm, nối âm & nuốt âm khi nghe',
  };

  IconData get icon => switch (this) {
    TheoryCategory.tenses => Icons.schedule_rounded,
    TheoryCategory.sentencePatterns => Icons.account_tree_rounded,
    TheoryCategory.partsOfSpeech => Icons.format_shapes_rounded,
    TheoryCategory.strategy => Icons.lightbulb_rounded,
    TheoryCategory.pronunciation => Icons.record_voice_over_rounded,
  };

  AppTone get tone => switch (this) {
    TheoryCategory.tenses => AppTone.info,
    TheoryCategory.sentencePatterns => AppTone.warning,
    TheoryCategory.partsOfSpeech => AppTone.info,
    TheoryCategory.strategy => AppTone.success,
    TheoryCategory.pronunciation => AppTone.warning,
  };
}

/// Ví dụ minh họa thực chiến trích từ đề ETS
class TheoryExample {
  const TheoryExample({
    required this.english,
    required this.vietnamese,
    required this.explanation,
    this.highlight,
    this.partTag,
  });

  final String english;
  final String vietnamese;
  final String explanation;
  final String? highlight;
  final String? partTag;
}

/// Khối nội dung / công thức trong bài lý thuyết
class TheorySection {
  const TheorySection({
    required this.title,
    required this.content,
    this.formula,
    this.bulletPoints = const [],
    this.tips = const [],
  });

  final String title;
  final String content;
  final String? formula;
  final List<String> bulletPoints;
  final List<String> tips;
}

/// Câu hỏi kiểm tra nhanh (Mini Quiz) cuối bài học
class TheoryQuizQuestion {
  const TheoryQuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.explanation,
  });

  final String id;
  final String question;
  final List<String> options;
  final int answerIndex;
  final String explanation;
}

/// Bài học lý thuyết hoàn chỉnh
class TheoryTopic {
  const TheoryTopic({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.readTimeMinutes,
    required this.difficulty,
    this.tags = const [],
    required this.overview,
    required this.sections,
    this.examples = const [],
    this.quiz = const [],
  });

  final String id;
  final TheoryCategory category;
  final String title;
  final String subtitle;
  final int readTimeMinutes;
  final String difficulty; // 'Cơ bản', 'Trung cấp', 'Nâng cao'
  final List<String> tags;
  final String overview;
  final List<TheorySection> sections;
  final List<TheoryExample> examples;
  final List<TheoryQuizQuestion> quiz;
}
