/// Quy đổi điểm TOEIC ƯỚC TÍNH (ETS không công bố bảng chính thức, mỗi đề một bảng).
/// Chỉ có ý nghĩa khi làm đủ 100 câu của phần tương ứng.
class ToeicScore {
  static int listening(int correct) => _scale(correct, offset: 10);
  static int reading(int correct) => _scale(correct, offset: -5);

  static int _scale(int correct, {required int offset}) {
    if (correct <= 0) return 5;
    final raw = correct * 4.9 + offset;
    final rounded = (raw / 5).round() * 5;
    return rounded.clamp(5, 495);
  }

  static bool isListening(int part) => part <= 4;
}
