/// Tra từ trong sổ từ vựng theo đoạn chữ người dùng bôi đen trong đề.
/// Thử cả dạng gốc đơn giản (bỏ -s/-es/-ed/-ing/-ly…) và cụm từ chứa từ đó.
abstract final class WordMatch {
  static final _edge = RegExp(r"^[^a-z0-9]+|[^a-z0-9]+$");

  /// Chuẩn hoá: chữ thường, bỏ dấu câu ở hai đầu, gộp khoảng trắng.
  static String normalize(String s) => s
      .toLowerCase()
      .replaceAll('’', "'")
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll(_edge, '');

  /// Các dạng gốc có thể của 1 từ tiếng Anh (không cần chính xác tuyệt đối).
  static Set<String> stems(String word) {
    final w = normalize(word);
    final out = {w};
    void add(String suffix, String replace, {int min = 3}) {
      if (w.endsWith(suffix) && w.length - suffix.length >= min) {
        out.add(w.substring(0, w.length - suffix.length) + replace);
      }
    }

    add('ies', 'y');
    add('ied', 'y');
    add('es', '');
    add('s', '');
    add('ed', '');
    add('ed', 'e');
    add('d', '');
    add('ing', '');
    add('ing', 'e');
    add('ily', 'y');
    add('ly', '');
    // nhân đôi phụ âm: planned → plan, shipping → ship
    for (final suffix in ['ed', 'ing']) {
      final base = w.length > suffix.length + 2 ? w.substring(0, w.length - suffix.length) : '';
      if (w.endsWith(suffix) &&
          base.length >= 3 &&
          base[base.length - 1] == base[base.length - 2]) {
        out.add(base.substring(0, base.length - 1));
      }
    }
    return out;
  }

  /// Trả về các mục khớp, mục khớp chính xác đứng trước, sau đó là cụm từ chứa từ đó.
  static List<T> find<T>(Iterable<T> items, String query, String Function(T) wordOf) {
    final q = normalize(query);
    if (q.isEmpty) return const [];
    final tokens = q.split(' ');
    final candidates = tokens.length == 1 ? stems(q) : {q};
    final exact = <T>[], phrase = <T>[];
    for (final item in items) {
      final w = normalize(wordOf(item));
      if (candidates.contains(w)) {
        exact.add(item);
      } else if (w.contains(' ') && tokens.length == 1) {
        final parts = w.split(' ');
        if (parts.any(candidates.contains)) phrase.add(item);
      } else if (tokens.length > 1 && (w.contains(q) || q.contains(w)) && w.contains(' ')) {
        phrase.add(item);
      }
    }
    return [...exact, ...phrase];
  }
}
