/// Hằng số và helper cho Supabase PostgREST (`/rest/v1`).
abstract final class Pg {
  /// Trả về 1 object thay vì mảng (lỗi 406 nếu không đúng 1 dòng).
  static const single = 'application/vnd.pgrst.object+json';
  static const returnRepresentation = 'return=representation';
  static const returnMinimal = 'return=minimal';
  static const upsert = 'resolution=merge-duplicates,return=minimal';

  static String eq(Object value) => 'eq.$value';
}
