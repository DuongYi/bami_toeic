/// Chấm bài chép chính tả: so từng từ (bỏ hoa/thường, dấu câu, nhãn "(A)", "W:"…).
abstract final class Dictation {
  static final _label = RegExp(r'^\s*(\([A-D]\)|[MW]\d?:|[A-Z][a-z]*:)\s*', multiLine: true);
  static final _word = RegExp(r"[a-z0-9]+(?:['’][a-z]+)?");

  /// Câu cần chép: bỏ nhãn đầu dòng.
  static List<String> lines(String transcript) => [
    for (final l in transcript.split('\n'))
      if (l.replaceFirst(_label, '').trim() case final t when t.isNotEmpty) t,
  ];

  static List<String> words(String s) => [
    for (final m in _word.allMatches(s.toLowerCase().replaceAll('’', "'"))) m.group(0)!,
  ];

  /// Đánh dấu từng từ của [target] là nghe đúng hay sai/thiếu, theo dãy con chung dài nhất.
  static DictationResult check(String target, String typed) {
    final display = target.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final t = [for (final w in display) words(w).join()];
    final u = words(typed);
    // LCS
    final dp = List.generate(t.length + 1, (_) => List.filled(u.length + 1, 0));
    for (var i = t.length - 1; i >= 0; i--) {
      for (var j = u.length - 1; j >= 0; j--) {
        dp[i][j] = t[i].isNotEmpty && t[i] == u[j]
            ? dp[i + 1][j + 1] + 1
            : (dp[i + 1][j] > dp[i][j + 1] ? dp[i + 1][j] : dp[i][j + 1]);
      }
    }
    final ok = List.filled(t.length, false);
    var i = 0, j = 0;
    while (i < t.length && j < u.length) {
      if (t[i].isNotEmpty && t[i] == u[j]) {
        ok[i] = true;
        i++;
        j++;
      } else if (dp[i + 1][j] >= dp[i][j + 1]) {
        i++;
      } else {
        j++;
      }
    }
    final counted = [
      for (var k = 0; k < t.length; k++)
        if (t[k].isNotEmpty) k,
    ];
    return DictationResult(
      tokens: [for (var k = 0; k < display.length; k++) (display[k], ok[k] || t[k].isEmpty)],
      correct: counted.where((k) => ok[k]).length,
      total: counted.length,
    );
  }
}

class DictationResult {
  const DictationResult({required this.tokens, required this.correct, required this.total});

  /// (từ hiển thị, nghe đúng?)
  final List<(String, bool)> tokens;
  final int correct;
  final int total;

  double get ratio => total == 0 ? 0 : correct / total;
}
