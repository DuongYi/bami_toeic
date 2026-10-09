import 'dart:math';

import 'models/vocab_models.dart';

/// Tên tiếng Việt của chủ đề (DB giữ khoá tiếng Anh).
const topicLabels = {
  'Office': 'Văn phòng',
  'Finance': 'Tài chính',
  'Hiring': 'Tuyển dụng',
  'Marketing': 'Marketing',
  'Sales': 'Bán hàng',
  'Travel': 'Du lịch',
  'Purchasing': 'Mua hàng',
  'Manufacturing': 'Sản xuất',
  'Real Estate': 'Bất động sản',
  'Health': 'Sức khoẻ',
  'Events': 'Sự kiện',
  'Technology': 'Công nghệ',
  'Dining': 'Ăn uống',
  'Transportation': 'Giao thông',
  'Customer Service': 'Chăm sóc khách hàng',
  'General': 'Thông dụng',
};

String topicLabel(String topic) => topicLabels[topic] ?? topic;

enum DeckKind { topic, test }

/// Bộ từ: theo chủ đề hoặc theo đề ETS. Khoá lưu được: "topic:Office", "test:3".
class VocabDeck {
  const VocabDeck.topic(String this.topic) : kind = DeckKind.topic, test = null;
  const VocabDeck.test(int this.test) : kind = DeckKind.test, topic = null;

  final DeckKind kind;
  final String? topic;
  final int? test;

  String get key => switch (kind) {
    DeckKind.topic => 'topic:$topic',
    DeckKind.test => 'test:$test',
  };

  String get label => switch (kind) {
    DeckKind.topic => topicLabel(topic!),
    DeckKind.test => 'Đề ETS 2026 · Test $test',
  };

  bool contains(VocabItem v) => switch (kind) {
    DeckKind.topic => v.topic == topic,
    DeckKind.test => v.sourceTest == test,
  };

  /// null nếu khoá sai / bộ không còn.
  static VocabDeck? parse(String? key) {
    if (key == null) return null;
    final i = key.indexOf(':');
    if (i < 0) return null;
    final value = key.substring(i + 1);
    return switch (key.substring(0, i)) {
      'topic' when value.isNotEmpty => VocabDeck.topic(value),
      'test' => switch (int.tryParse(value)) {
        final n? => VocabDeck.test(n),
        null => null,
      },
      _ => null,
    };
  }

  @override
  bool operator ==(Object other) => other is VocabDeck && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

/// Thống kê 1 bộ (hoặc cả kho khi [deck] = null).
class DeckStats {
  const DeckStats({
    required this.deck,
    required this.total,
    required this.mastered,
    required this.learning,
  });

  factory DeckStats.of(VocabDeck? deck, Iterable<VocabItem> items) {
    var total = 0, mastered = 0, learning = 0;
    for (final v in items) {
      if (deck != null && !deck.contains(v)) continue;
      total++;
      if (v.isMastered) {
        mastered++;
      } else if (v.isLearning) {
        learning++;
      }
    }
    return DeckStats(deck: deck, total: total, mastered: mastered, learning: learning);
  }

  final VocabDeck? deck;
  final int total;
  final int mastered;
  final int learning;

  int get fresh => total - mastered - learning;
  double get progress => total == 0 ? 0 : mastered / total;
}

/// Mọi bộ có trong kho: chủ đề (nhiều từ trước) rồi đề ETS (Test 1 → 10).
List<DeckStats> allDecks(List<VocabItem> items) {
  final topics = items.map((v) => v.topic).toSet();
  final tests = {for (final v in items) ?v.sourceTest}.toList()..sort();
  return [
    ...([for (final t in topics) DeckStats.of(VocabDeck.topic(t), items)]
      ..sort((a, b) => b.total.compareTo(a.total))),
    for (final t in tests) DeckStats.of(VocabDeck.test(t), items),
  ];
}

/// Thứ tự học từ mới: theo đề, rồi theo câu xuất hiện trong đề (từ không rõ nguồn xếp cuối).
int compareLearningOrder(VocabItem a, VocabItem b) {
  final t = (a.sourceTest ?? 1 << 20).compareTo(b.sourceTest ?? 1 << 20);
  if (t != 0) return t;
  final q = (a.sourceQuestion ?? 1 << 20).compareTo(b.sourceQuestion ?? 1 << 20);
  return q != 0 ? q : a.word.toLowerCase().compareTo(b.word.toLowerCase());
}

/// Số từ mới còn được học hôm nay theo chỉ tiêu [dailyNew].
int newQuotaLeft(List<VocabItem> items, DateTime now, int dailyNew) =>
    max(0, dailyNew - items.where((v) => v.learnedOn(now)).length);

/// Phiên học = mọi từ đến hạn (mọi bộ) + tối đa [newLimit] từ mới của [deck] theo thứ tự đề.
/// Từ "đã biết" không bao giờ vào phiên.
List<VocabItem> buildSession(
  List<VocabItem> items,
  DateTime now, {
  VocabDeck? deck,
  required int newLimit,
  Random? random,
}) {
  final due = items.where((v) => v.isDue(now)).toList()..shuffle(random ?? Random());
  final fresh =
      (items.where((v) => v.isNew && (deck == null || deck.contains(v))).toList()
            ..sort(compareLearningOrder))
          .take(max(0, newLimit))
          .toList();
  // Ôn từ cũ trước, từ mới sau: đỡ quá tải khi vừa mở phiên.
  return [...due, ...fresh];
}
