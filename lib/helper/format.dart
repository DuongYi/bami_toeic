/// Định dạng hiển thị theo chuẩn vi-VN, dùng chung toàn app.
abstract final class Fmt {
  static String _pad(int n) => n.toString().padLeft(2, '0');

  /// 08/10/2026
  static String date(DateTime d) => '${_pad(d.day)}/${_pad(d.month)}/${d.year}';

  /// 08/10/2026 14:05
  static String dateTime(DateTime d) => '${date(d)} ${_pad(d.hour)}:${_pad(d.minute)}';

  /// 05:09 hoặc 1:05:09
  static String clock(Duration d) {
    final h = d.inHours, m = d.inMinutes.remainder(60), s = d.inSeconds.remainder(60);
    return h > 0 ? '$h:${_pad(m)}:${_pad(s)}' : '${_pad(m)}:${_pad(s)}';
  }

  /// 75%
  static String percent(double ratio) => '${(ratio * 100).round()}%';

  /// 0 KB · 340 KB · 12,3 MB · 1,2 GB (dấu phẩy thập phân kiểu Việt).
  static String bytes(int n) {
    const kb = 1024, mb = kb * 1024, gb = mb * 1024;
    String one(double v) => v.toStringAsFixed(1).replaceAll('.', ',');
    if (n >= gb) return '${one(n / gb)} GB';
    if (n >= mb) return '${one(n / mb)} MB';
    return '${(n / kb).round()} KB';
  }
}
