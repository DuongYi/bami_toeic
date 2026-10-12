import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/theory_models.dart';
import '../../data/theory_repository.dart';

class TheoryState {
  const TheoryState({
    required this.allTopics,
    this.selectedCategory,
    this.searchQuery = '',
    this.completedIds = const {},
    this.bookmarkedIds = const {},
    this.quizScores = const {},
    this.showOnlyBookmarks = false,
    this.isLoading = false,
  });

  final List<TheoryTopic> allTopics;
  final TheoryCategory? selectedCategory;
  final String searchQuery;
  final Set<String> completedIds;
  final Set<String> bookmarkedIds;
  final Map<String, int> quizScores;
  final bool showOnlyBookmarks;
  final bool isLoading;

  List<TheoryTopic> get filteredTopics {
    return allTopics.where((topic) {
      if (showOnlyBookmarks && !bookmarkedIds.contains(topic.id)) {
        return false;
      }
      if (selectedCategory != null && topic.category != selectedCategory) {
        return false;
      }
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase().trim();
        final matchesTitle = topic.title.toLowerCase().contains(q);
        final matchesSubtitle = topic.subtitle.toLowerCase().contains(q);
        final matchesTags = topic.tags.any((t) => t.toLowerCase().contains(q));
        final matchesOverview = topic.overview.toLowerCase().contains(q);
        if (!matchesTitle && !matchesSubtitle && !matchesTags && !matchesOverview) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  int get completedCount => completedIds.length;
  int get totalCount => allTopics.length;
  double get progressRatio => totalCount == 0 ? 0.0 : (completedCount / totalCount).clamp(0.0, 1.0);

  bool isCompleted(String id) => completedIds.contains(id);
  bool isBookmarked(String id) => bookmarkedIds.contains(id);
  int? getQuizScore(String id) => quizScores[id];

  TheoryState copyWith({
    List<TheoryTopic>? allTopics,
    TheoryCategory? Function()? selectedCategory,
    String? searchQuery,
    Set<String>? completedIds,
    Set<String>? bookmarkedIds,
    Map<String, int>? quizScores,
    bool? showOnlyBookmarks,
    bool? isLoading,
  }) {
    return TheoryState(
      allTopics: allTopics ?? this.allTopics,
      selectedCategory: selectedCategory != null ? selectedCategory() : this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      completedIds: completedIds ?? this.completedIds,
      bookmarkedIds: bookmarkedIds ?? this.bookmarkedIds,
      quizScores: quizScores ?? this.quizScores,
      showOnlyBookmarks: showOnlyBookmarks ?? this.showOnlyBookmarks,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final theoryControllerProvider = NotifierProvider<TheoryController, TheoryState>(
  TheoryController.new,
);

class TheoryController extends Notifier<TheoryState> {
  @override
  TheoryState build() {
    final repo = ref.watch(theoryRepositoryProvider);
    _loadUserProgress();
    return TheoryState(allTopics: repo.getAllTopics(), isLoading: true);
  }

  TheoryRepository get _repo => ref.read(theoryRepositoryProvider);

  Future<void> _loadUserProgress() async {
    try {
      final topics = await _repo.loadTopics();
      final completed = await _repo.getCompletedTopicIds();
      final bookmarks = await _repo.getBookmarkedTopicIds();
      final scores = await _repo.getQuizScores();
      if (!ref.mounted) return;
      state = state.copyWith(
        allTopics: topics,
        completedIds: completed,
        bookmarkedIds: bookmarks,
        quizScores: scores,
        isLoading: false,
      );
    } catch (_) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false);
    }
  }

  void selectCategory(TheoryCategory? category) {
    if (state.selectedCategory == category) {
      state = state.copyWith(selectedCategory: () => null);
    } else {
      state = state.copyWith(selectedCategory: () => category);
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleBookmarksFilter() {
    state = state.copyWith(showOnlyBookmarks: !state.showOnlyBookmarks);
  }

  Future<void> toggleBookmark(String topicId) async {
    final willBookmark = await _repo.toggleBookmark(topicId);
    final updated = Set<String>.from(state.bookmarkedIds);
    if (willBookmark) {
      updated.add(topicId);
    } else {
      updated.remove(topicId);
    }
    state = state.copyWith(bookmarkedIds: updated);
  }

  Future<void> toggleCompleted(String topicId) async {
    final isDone = state.isCompleted(topicId);
    final nextDone = !isDone;
    await _repo.setTopicCompleted(topicId, nextDone);
    final updated = Set<String>.from(state.completedIds);
    if (nextDone) {
      updated.add(topicId);
    } else {
      updated.remove(topicId);
    }
    state = state.copyWith(completedIds: updated);
  }

  Future<void> recordQuizResult(String topicId, int correctCount) async {
    await _repo.saveQuizScore(topicId, correctCount);
    await _repo.setTopicCompleted(topicId, true);
    final updatedScores = Map<String, int>.from(state.quizScores)..[topicId] = correctCount;
    final updatedCompleted = Set<String>.from(state.completedIds)..add(topicId);
    state = state.copyWith(
      quizScores: updatedScores,
      completedIds: updatedCompleted,
    );
  }
}
