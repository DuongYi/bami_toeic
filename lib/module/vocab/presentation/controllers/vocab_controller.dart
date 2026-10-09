import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../goals/data/study_store.dart';
import '../../../test/data/in_progress_store.dart';
import '../../data/models/vocab_models.dart';
import '../../data/vocab_decks.dart';
import '../../data/vocab_repository.dart';

part 'vocab_controller.g.dart';

/// Số từ mới thêm mỗi lần bấm "Học thêm".
const extraNewWords = 10;

/// Nguồn ngẫu nhiên để xáo thẻ (override bằng seed cố định trong test).
@Riverpod(keepAlive: true)
Random sessionRandom(Ref ref) => Random();

/// Toàn bộ kho từ + lịch ôn của user. Giữ trong bộ nhớ (hơn 1000 từ) – làm mới khi cần.
@Riverpod(keepAlive: true)
class VocabList extends _$VocabList {
  @override
  Future<List<VocabItem>> build() {
    ref.watch(currentUserIdProvider);
    return ref.watch(vocabRepositoryProvider).fetchAll();
  }

  /// Admin thêm / sửa từ trong bộ chung.
  Future<void> save(VocabInput input, {String? id}) async {
    await ref.read(vocabRepositoryProvider).save(input, id: id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> delete(String id) async {
    await ref.read(vocabRepositoryProvider).delete(id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> markKnown(VocabItem item) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    await ref.read(vocabRepositoryProvider).markKnown(userId: userId, item: item);
    ref.invalidateSelf();
    await future;
  }

  /// Học lại từ đầu (bỏ "đã biết" và lịch ôn).
  Future<void> resetWord(String vocabId) async {
    await ref.read(vocabRepositoryProvider).resetWord(vocabId);
    ref.invalidateSelf();
    await future;
  }
}

/// Bộ từ đang học (lưu trên máy). null = học từ mọi bộ theo thứ tự đề.
@Riverpod(keepAlive: true)
class CurrentDeck extends _$CurrentDeck {
  static String _key(String? uid) => 'vocab/deck@${uid ?? 'anon'}';

  @override
  Future<VocabDeck?> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return VocabDeck.parse(prefs.getString(_key(ref.watch(currentUserIdProvider))));
  }

  Future<void> select(VocabDeck? deck) async {
    state = AsyncData(deck);
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final key = _key(ref.read(currentUserIdProvider));
    if (deck == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, deck.key);
    }
  }
}

/// Số liệu cho màn Từ vựng.
class VocabOverview {
  const VocabOverview({
    required this.items,
    required this.deck,
    required this.deckStats,
    required this.bank,
    required this.decks,
    required this.dueCount,
    required this.dailyNew,
    required this.newToday,
    required this.newLeft,
    required this.deckFreshLeft,
  });

  final List<VocabItem> items;

  /// Bộ đang học (null = mọi bộ).
  final VocabDeck? deck;
  final DeckStats deckStats;

  /// Cả kho.
  final DeckStats bank;
  final List<DeckStats> decks;

  /// Từ đến hạn ôn (mọi bộ).
  final int dueCount;

  /// Chỉ tiêu từ mới mỗi ngày (Mục tiêu → "từ mới mỗi ngày").
  final int dailyNew;
  final int newToday;

  /// Từ mới còn học được hôm nay (đã trừ chỉ tiêu và số từ mới còn lại trong bộ).
  final int newLeft;

  /// Số từ chưa học còn lại trong bộ đang học.
  final int deckFreshLeft;

  int get todayCount => dueCount + newLeft;
  bool get doneToday => todayCount == 0;
}

@riverpod
Future<VocabOverview> vocabOverview(Ref ref) async {
  final items = await ref.watch(vocabListProvider.future);
  final deck = await ref.watch(currentDeckProvider.future);
  final dailyNew = (await ref.watch(goalSettingsProvider.future)).dailyWords;
  final now = DateTime.now();
  final deckStats = DeckStats.of(deck, items);
  final quota = newQuotaLeft(items, now, dailyNew);
  return VocabOverview(
    items: items,
    deck: deck,
    deckStats: deckStats,
    bank: DeckStats.of(null, items),
    decks: allDecks(items),
    dueCount: items.where((v) => v.isDue(now)).length,
    dailyNew: dailyNew,
    newToday: items.where((v) => v.learnedOn(now)).length,
    newLeft: min(quota, deckStats.fresh),
    deckFreshLeft: deckStats.fresh,
  );
}

/// Bộ lọc của màn danh sách từ.
enum WordFilter {
  all('Tất cả'),
  due('Cần ôn'),
  fresh('Chưa học'),
  learning('Đang học'),
  mastered('Đã thuộc');

  const WordFilter(this.label);
  final String label;

  bool test(VocabItem v, DateTime now) => switch (this) {
    WordFilter.all => true,
    WordFilter.due => v.isDue(now),
    WordFilter.fresh => v.isNew,
    WordFilter.learning => v.isLearning,
    WordFilter.mastered => v.isMastered,
  };
}

/// Lọc theo bộ + trạng thái + từ khoá (khớp từ hoặc nghĩa, không phân biệt hoa thường).
List<VocabItem> filterWords(
  List<VocabItem> items, {
  VocabDeck? deck,
  WordFilter filter = WordFilter.all,
  String query = '',
  DateTime? now,
}) {
  final at = now ?? DateTime.now();
  final q = query.trim().toLowerCase();
  final out = [
    for (final v in items)
      if ((deck == null || deck.contains(v)) &&
          filter.test(v, at) &&
          (q.isEmpty || v.word.toLowerCase().contains(q) || v.meaning.toLowerCase().contains(q)))
        v,
  ];
  // Bộ theo đề: theo thứ tự câu; còn lại theo ABC.
  return deck?.kind == DeckKind.test
      ? (out..sort(compareLearningOrder))
      : (out..sort((a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase())));
}
