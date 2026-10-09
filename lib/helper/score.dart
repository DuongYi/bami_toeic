/// Quy đổi điểm TOEIC. Đề có bảng quy đổi riêng ([ScoreTable], cột `tests.score_table`)
/// thì dùng bảng đó; không có thì ƯỚC TÍNH tuyến tính.
/// Chỉ có ý nghĩa khi làm đủ 100 câu của phần tương ứng.
class ToeicScore {
  static int listening(int correct, [ScoreTable? table]) =>
      table?.listening(correct) ?? _scale(correct, offset: 10);
  static int reading(int correct, [ScoreTable? table]) =>
      table?.reading(correct) ?? _scale(correct, offset: -5);

  static int _scale(int correct, {required int offset}) {
    if (correct <= 0) return 5;
    final raw = correct * 4.9 + offset;
    final rounded = (raw / 5).round() * 5;
    return rounded.clamp(5, 495);
  }

  static bool isListening(int part) => part <= 4;
}

/// Bảng quy đổi của 1 đề: `{"listening": [[minĐúng, maxĐúng, minĐiểm, maxĐiểm], ...], "reading": [...]}`.
/// Khoảng điểm (vd. 96–100 câu → 475–495) lấy điểm giữa, làm tròn 5.
class ScoreTable {
  const ScoreTable._(this._listening, this._reading);

  final List<List<int>> _listening;
  final List<List<int>> _reading;

  /// null nếu dữ liệu thiếu / sai định dạng → quay về ước tính.
  static ScoreTable? tryParse(Object? json) {
    if (json is! Map) return null;
    List<List<int>>? rows(Object? v) {
      if (v is! List || v.isEmpty) return null;
      final out = <List<int>>[];
      for (final r in v) {
        if (r is! List || r.length != 4 || r.any((x) => x is! num)) return null;
        out.add([for (final x in r) (x as num).toInt()]);
      }
      return out;
    }

    final l = rows(json['listening']), r = rows(json['reading']);
    return l == null || r == null ? null : ScoreTable._(l, r);
  }

  int? listening(int correct) => _lookup(_listening, correct);
  int? reading(int correct) => _lookup(_reading, correct);

  static int? _lookup(List<List<int>> rows, int correct) {
    for (final [lo, hi, minScore, maxScore] in rows) {
      if (correct >= lo && correct <= hi) return ((minScore + maxScore) / 2 / 5).round() * 5;
    }
    return null;
  }
}
