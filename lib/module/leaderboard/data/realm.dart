/// Cảnh giới tu luyện theo điểm TOEIC – ranh giới bám theo dải chứng chỉ màu của ETS
/// (cam / nâu / xanh lá / xanh dương / vàng), tách thêm bậc cao nhất cho ≥ 945.
enum Realm {
  luyenKhi('Luyện Khí', 0),
  trucCo('Trúc Cơ', 220),
  ketDan('Kết Đan', 470),
  nguyenAnh('Nguyên Anh', 730),
  hoaThan('Hoá Thần', 860),
  doKiep('Độ Kiếp', 945);

  const Realm(this.label, this.minScore);

  final String label;
  final int minScore;

  static Realm of(int score) => values.lastWhere((r) => score >= r.minScore);

  /// Cảnh giới kế tiếp, null nếu đã cao nhất.
  Realm? get next => index + 1 < values.length ? values[index + 1] : null;
}
