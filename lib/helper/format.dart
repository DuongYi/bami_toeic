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
}
