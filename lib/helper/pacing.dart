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

class TimedAnswer {
  const TimedAnswer({
    required this.questionId,
    required this.part,
    required this.number,
    required this.ms,
    required this.correct,
  });

  final String questionId;
  final int part;
  final int number;
  final int? ms;
  final bool correct;
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
