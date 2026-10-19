import 'package:flutter/widgets.dart';

/// Nơi người học bôi đen để tra từ (câu trong đề + vị trí), dùng làm câu ví dụ khi lưu sổ từ.
class LookupOrigin {
  const LookupOrigin({required this.sentence, this.testId, this.label});

  final String sentence;
  final String? testId;

  /// Vị trí trong đề, vd. "Part 7 · câu 147".
  final String? label;
}

/// Truyền [LookupOrigin] xuống sheet từ điển mà không phải đi qua từng widget.
class LookupOriginScope extends InheritedWidget {
  const LookupOriginScope({super.key, required this.origin, required super.child});

  final LookupOrigin? origin;

  /// Đọc trong callback (không đăng ký rebuild).
  static LookupOrigin? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<LookupOriginScope>()?.origin;

  @override
  bool updateShouldNotify(LookupOriginScope old) => old.origin != origin;
}
