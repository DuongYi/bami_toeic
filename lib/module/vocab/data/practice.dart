import 'dart:math';

import '../../../helper/word_match.dart';
import 'models/vocab_models.dart';

/// Các dạng luyện chủ động (bắt buộc nhớ lại, không chỉ lật thẻ).
enum PracticeMode {
  meaning('Chọn nghĩa', 'Xem từ tiếng Anh, chọn nghĩa đúng'),
  listen('Nghe chọn từ', 'Nghe phát âm, chọn từ vừa nghe'),
  cloze('Điền vào câu', 'Chọn từ hợp với chỗ trống – như Part 5'),
  spell('Gõ từ', 'Xem nghĩa, gõ lại từ tiếng Anh');

  const PracticeMode(this.label, this.description);
  final String label;
  final String description;

  bool get hasOptions => this != PracticeMode.spell;
}

/// Số câu mỗi lượt luyện.
const practiceLength = 10;

class PracticeQuestion {
  const PracticeQuestion({
    required this.item,
    required this.mode,
    this.options = const [],
    this.answerIndex = 0,
    this.cloze,
  });

  final VocabItem item;
  final PracticeMode mode;

  /// Đáp án để chọn (rỗng với dạng gõ từ).
  final List<String> options;
  final int answerIndex;

  /// Câu ví dụ đã che từ (dạng điền vào câu).
  final String? cloze;

  String get answer => mode.hasOptions ? options[answerIndex] : item.word;

  /// Dạng gõ từ: không phân biệt hoa thường, khoảng trắng thừa, dấu gạch nối.
  bool checkSpelling(String typed) => _loose(typed) == _loose(item.word);

  static String _loose(String s) =>
      s.toLowerCase().replaceAll('’', "'").replaceAll(RegExp(r'[\s\-]+'), ' ').trim();
}

/// Ký hiệu chỗ trống trong câu.
const blank = '_____';

/// Che từ (kể cả dạng chia: -s, -ed, -ing…) trong câu ví dụ; null nếu không tìm thấy.
String? clozeOf(VocabItem v) {
  final example = v.example;
  if (example == null || example.trim().isEmpty) return null;
  final word = WordMatch.normalize(v.word);
  if (word.isEmpty) return null;

  if (!word.contains(' ')) {
    for (final m in RegExp(r"[A-Za-z][A-Za-z'\-]*").allMatches(example)) {
      final token = m.group(0)!;
      // Sở hữu cách: "applicant's" → "applicant"
      final t = token.toLowerCase().replaceFirst(RegExp(r"'s$"), '');
      if (t == word || WordMatch.stems(t).contains(word)) {
        return example.replaceRange(m.start, m.end, blank);
      }
    }
    return null;
  }

  // Cụm từ: động từ đầu được chia, "one's / oneself / someone" là chỗ thay thế, "be" tuỳ dạng.
  final tokens = word.split(' ');
  final parts = <String>[];
  var prefix = '';
  for (final (i, t) in tokens.indexed) {
    if (i == 0 && t == 'be') {
      prefix = r'(?:(?:be|is|are|am|was|were|been|being)\s+)?';
      continue;
    }
    final last = i == tokens.length - 1;
    parts.add(switch (t) {
      "one's" => r"[a-z]+'s",
      'oneself' => r'[a-z]+sel(?:f|ves)',
      'someone' || 'something' => r'[a-z]+',
      // "place an order" ↔ "place our order"
      'a' || 'an' || 'the' => r'(?:a|an|the|our|their|your|my|his|her|its|this|these)',
      // Động từ đầu được chia, danh từ cuối có thể số nhiều: "meets deadlines", "light fixtures"
      _ when (parts.isEmpty || last) && t.length > 3 => '${RegExp.escape(_stemBase(t))}[a-z]*',
      _ => RegExp.escape(t),
    });
  }
  if (parts.isEmpty) return null;
  final re = RegExp('\\b$prefix${parts.join(r'\s+')}\\b', caseSensitive: false);
  final m = re.firstMatch(example);
  return m == null ? null : example.replaceRange(m.start, m.end, blank);
}

/// Gốc để khớp các dạng chia: "make" → "mak" (making), "apply" → "appl" (applied).
String _stemBase(String t) => t.endsWith('e') || t.endsWith('y') ? t.substring(0, t.length - 1) : t;

/// Chọn từ để luyện: ưu tiên từ đến hạn → đang học → đã thuộc; ít hơn 4 từ đã học
/// thì dùng [fallback] (từ trong bộ đang học) để người mới vẫn luyện được.
List<VocabItem> practicePool(
  List<VocabItem> items,
  List<VocabItem> fallback,
  PracticeMode mode,
  DateTime now,
  Random random,
) {
  bool usable(VocabItem v) => mode != PracticeMode.cloze || clozeOf(v) != null;
  final learned = items.where((v) => !v.isNew && usable(v)).toList();
  final source = learned.length >= 4 ? learned : fallback.where(usable).toList();
  int bucket(VocabItem v) =>
      v.isDue(now) ? 0 : (v.isLearning ? 1 : (v.isNew ? 1 : 2));
  return (source..shuffle(random))
    ..sort((a, b) => bucket(a).compareTo(bucket(b)));
}

/// Dựng [count] câu hỏi từ [pool]; đáp án nhiễu lấy từ cả [bank], ưu tiên cùng loại từ.
List<PracticeQuestion> buildPractice({
  required List<VocabItem> pool,
  required List<VocabItem> bank,
  required PracticeMode mode,
  required Random random,
  int count = practiceLength,
}) {
  String optionOf(VocabItem v) => mode == PracticeMode.meaning ? v.meaning : v.word;
  return [
    for (final v in pool.take(count))
      if (mode == PracticeMode.spell)
        PracticeQuestion(item: v, mode: mode)
      else
        () {
          final right = optionOf(v);
          final others = bank
              .where((o) => o.id != v.id && optionOf(o).toLowerCase() != right.toLowerCase())
              .toList()
            ..shuffle(random);
          others.sort((a, b) => (a.pos == v.pos ? 0 : 1).compareTo(b.pos == v.pos ? 0 : 1));
          final distractors = <String>{};
          for (final o in others) {
            if (distractors.length == 3) break;
            distractors.add(optionOf(o));
          }
          final options = [right, ...distractors]..shuffle(random);
          return PracticeQuestion(
            item: v,
            mode: mode,
            options: options,
            answerIndex: options.indexOf(right),
            cloze: mode == PracticeMode.cloze ? clozeOf(v) : null,
          );
        }(),
  ];
}
