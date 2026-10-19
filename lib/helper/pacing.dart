/// Báo cáo nhịp làm bài phần Reading: thời gian trung bình mỗi câu theo Part và các câu tốn
/// thời gian nhất. Listening đi theo audio nên không chấm nhịp.
abstract final class Pacing {
  /// Thời gian chuẩn (giây/câu) để làm kịp 75 phút Reading: Part 5 nhanh, dồn giờ cho Part 7.
  static const targetSeconds = {5: 25, 6: 35, 7: 60};

  /// Cần ghi được thời gian ít nhất bấy nhiêu phần câu Reading thì báo cáo mới đáng tin.
  static const minCoverage = 0.5;

  /// Câu "quá lâu" = gấp bấy nhiêu lần chuẩn của Part.
  static const slowFactor = 2.0;

  static PacingReport? of(List<TimedAnswer> answers, {int maxSlow = 5}) {
    final reading = answers.where((a) => targetSeconds.containsKey(a.part)).toList();
    final timed = reading.where((a) => a.ms != null && a.ms! > 0).toList();
    if (reading.isEmpty || timed.length < reading.length * minCoverage) return null;
    final parts = <PartPace>[];
    for (final MapEntry(key: part, value: target) in targetSeconds.entries) {
      final list = timed.where((a) => a.part == part).toList();
      if (list.isEmpty) continue;
      final avg = list.fold(0, (s, a) => s + a.ms!) / list.length / 1000;
      parts.add(PartPace(part: part, avgSeconds: avg, targetSeconds: target, count: list.length));
    }
    final slow =
        timed.where((a) => a.ms! / 1000 >= targetSeconds[a.part]! * slowFactor).toList()
          ..sort((a, b) => b.ms!.compareTo(a.ms!));
    return PacingReport(
      parts: parts,
      slow: slow.take(maxSlow).toList(),
      slowWrongCount: slow.where((a) => !a.correct).length,
    );
  }
}

/// Sức bền phần Reading: so tỉ lệ đúng nửa đầu với nửa sau (theo số câu). Đề thật 100 câu đọc
/// trong 75 phút – tụt mạnh ở nửa sau là dấu hiệu mệt hoặc hết giờ.
class Stamina {
  const Stamina({required this.first, required this.last});

  /// Đề có ít nhất bấy nhiêu câu Reading mới đánh giá (đề ngắn chưa đủ dài để mệt).
  static const minQuestions = 40;

  /// Tụt từ mức này (tỉ lệ đúng) trở lên thì cảnh báo.
  static const dropWarning = 0.1;

  final StaminaHalf first;
  final StaminaHalf last;

  /// > 0 = nửa sau kém hơn nửa đầu.
  double get drop => first.ratio - last.ratio;
  bool get dropped => drop >= dropWarning;

  static Stamina? of(List<TimedAnswer> answers) {
    final reading = answers.where((a) => Pacing.targetSeconds.containsKey(a.part)).toList()
      ..sort((a, b) => a.number.compareTo(b.number));
    if (reading.length < minQuestions) return null;
    final half = reading.length ~/ 2;
    return Stamina(
      first: StaminaHalf.of(reading.sublist(0, half)),
      last: StaminaHalf.of(reading.sublist(half)),
    );
  }
}

class StaminaHalf {
  const StaminaHalf({
    required this.from,
    required this.to,
    required this.correct,
    required this.total,
    required this.skipped,
  });

  factory StaminaHalf.of(List<TimedAnswer> list) => StaminaHalf(
    from: list.first.number,
    to: list.last.number,
    correct: list.where((a) => a.correct).length,
    total: list.length,
    skipped: list.where((a) => a.skipped).length,
  );

  final int from;
  final int to;
  final int correct;
  final int total;
  final int skipped;

  double get ratio => total == 0 ? 0 : correct / total;
}

class TimedAnswer {
  const TimedAnswer({
    required this.questionId,
    required this.part,
    required this.number,
    required this.ms,
    required this.correct,
    this.skipped = false,
  });

  final String questionId;
  final int part;
  final int number;
  final int? ms;
  final bool correct;
  final bool skipped;
}

class PartPace {
  const PartPace({
    required this.part,
    required this.avgSeconds,
    required this.targetSeconds,
    required this.count,
  });

  final int part;
  final double avgSeconds;
  final int targetSeconds;
  final int count;

  /// > 1 = chậm hơn chuẩn.
  double get ratio => avgSeconds / targetSeconds;
}

class PacingReport {
  const PacingReport({required this.parts, required this.slow, required this.slowWrongCount});

  final List<PartPace> parts;

  /// Các câu lâu nhất (≥ 2 lần chuẩn), lâu nhất trước.
  final List<TimedAnswer> slow;

  /// Trong số câu quá lâu, bao nhiêu câu vẫn sai – thời gian bỏ ra không đáng.
  final int slowWrongCount;
}
