/// Thuật toán SM-2 rút gọn cho flashcard.
enum ReviewGrade {
  again(0, 'Quên'),
  hard(3, 'Khó'),
  good(4, 'Nhớ'),
  easy(5, 'Dễ');

  const ReviewGrade(this.quality, this.label);
  final int quality;
  final String label;
}

class SrsState {
  const SrsState({this.ease = 2.5, this.intervalDays = 0, this.repetitions = 0, this.due});

  final double ease;
  final int intervalDays;
  final int repetitions;

  /// null = chưa từng học
  final DateTime? due;

  DateTime get dueAt => due ?? DateTime.fromMillisecondsSinceEpoch(0);

  SrsState review(ReviewGrade grade, {DateTime? now}) {
    now ??= DateTime.now();
    final q = grade.quality;
    final newEase = (ease + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))).clamp(1.3, 3.0);

    if (q < 3) {
      // Quên: học lại sau 10 phút
      return SrsState(
        ease: newEase,
        intervalDays: 0,
        repetitions: 0,
        due: now.add(const Duration(minutes: 10)),
      );
    }
    final reps = repetitions + 1;
    final interval = switch (reps) {
      1 => q == 5 ? 3 : 1,
      2 => 6,
      _ => (intervalDays * newEase).round(),
    };
    return SrsState(
      ease: newEase,
      intervalDays: interval,
      repetitions: reps,
      due: now.add(Duration(days: interval)),
    );
  }
}
