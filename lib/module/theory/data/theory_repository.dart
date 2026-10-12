import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/theory_models.dart';

final theoryRepositoryProvider = Provider<TheoryRepository>((ref) {
  return TheoryRepository();
});

class TheoryRepository {
  TheoryRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const _keyCompleted = 'theory_completed_topics';
  static const _keyBookmarks = 'theory_bookmarked_topics';
  static const _keyScores = 'theory_quiz_scores';

  /// Nội dung lý thuyết: mỗi nhóm 1 file JSON (sửa nội dung không cần sửa code).
  static const assetFiles = [
    'assets/theory/tenses.json',
    'assets/theory/sentence_patterns.json',
    'assets/theory/parts_of_speech.json',
    'assets/theory/strategy.json',
    'assets/theory/pronunciation.json',
  ];

  final AssetBundle _bundle;
  List<TheoryTopic> _topics = const [];
  Future<List<TheoryTopic>>? _loading;

  /// Đọc toàn bộ chủ điểm (1 lần, lưu lại trong bộ nhớ).
  Future<List<TheoryTopic>> loadTopics() => _loading ??= () async {
    final all = <TheoryTopic>[];
    for (final f in assetFiles) {
      final list = jsonDecode(await _bundle.loadString(f)) as List;
      all.addAll(list.map((j) => TheoryTopic.fromJson(j as Map<String, dynamic>)));
    }
    return _topics = all;
  }();

  // ==================== CÁC PHƯƠNG THỨC TRUY XUẤT DỮ LIỆU (sau loadTopics) ====================

  List<TheoryTopic> getAllTopics() => _topics;

  List<TheoryTopic> getTopicsByCategory(TheoryCategory category) {
    return _topics.where((t) => t.category == category).toList();
  }

  TheoryTopic? getTopicById(String id) => _topics.where((t) => t.id == id).firstOrNull;

  /// Tìm chủ đề liên quan đến tag câu hỏi sai (vd: 'word-form', 'verb-form', 'tenses')
  TheoryTopic? findTopicByQuestionTag(String tag) =>
      _topics.where((t) => t.tags.contains(tag)).firstOrNull;

  // ==================== LƯU TRỮ TRẠNG THÁI HỌC TẬP (LOCAL) ====================

  Future<Set<String>> getCompletedTopicIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyCompleted) ?? [];
    return list.toSet();
  }

  Future<void> setTopicCompleted(String id, bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    final set = (prefs.getStringList(_keyCompleted) ?? []).toSet();
    if (completed) {
      set.add(id);
    } else {
      set.remove(id);
    }
    await prefs.setStringList(_keyCompleted, set.toList());
  }

  Future<Set<String>> getBookmarkedTopicIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyBookmarks) ?? [];
    return list.toSet();
  }

  Future<bool> toggleBookmark(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final set = (prefs.getStringList(_keyBookmarks) ?? []).toSet();
    final willBookmark = !set.contains(id);
    if (willBookmark) {
      set.add(id);
    } else {
      set.remove(id);
    }
    await prefs.setStringList(_keyBookmarks, set.toList());
    return willBookmark;
  }

  Future<Map<String, int>> getQuizScores() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyScores);
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, (v as num).toInt()));
    } catch (_) {
      return {};
    }
  }

  Future<void> saveQuizScore(String topicId, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = await getQuizScores();
    scores[topicId] = score;
    await prefs.setString(_keyScores, jsonEncode(scores));
  }
}
