import 'package:bami_toeic/core/design_system/design_system.dart';
import 'package:bami_toeic/module/theory/data/models/theory_models.dart';
import 'package:bami_toeic/module/theory/data/theory_repository.dart';
import 'package:bami_toeic/module/theory/presentation/controllers/theory_controller.dart';
import 'package:bami_toeic/module/theory/presentation/pages/theory_detail_page.dart';
import 'package:bami_toeic/module/theory/presentation/pages/theory_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('TheoryRepository Test', () {
    final repo = TheoryRepository();
    setUpAll(repo.loadTopics);

    test('Lấy toàn bộ chủ điểm lý thuyết 5 danh mục phong phú', () {
      final topics = repo.getAllTopics();
      expect(topics.length, 59);
      expect(topics.any((t) => t.category == TheoryCategory.tenses), true);
      expect(topics.any((t) => t.category == TheoryCategory.sentencePatterns), true);
      expect(topics.any((t) => t.category == TheoryCategory.partsOfSpeech), true);
      expect(topics.any((t) => t.category == TheoryCategory.strategy), true);
      expect(topics.any((t) => t.category == TheoryCategory.pronunciation), true);

      final patternTopics = repo.getTopicsByCategory(TheoryCategory.sentencePatterns);
      expect(patternTopics.length, 23);
    });

    test('Tìm bài học theo id', () {
      final topic = repo.getTopicById('tenses-present-simple-continuous');
      expect(topic, isNotNull);
      expect(topic!.title.contains('Hiện tại'), true);
      expect(topic.sections.isNotEmpty, true);
      expect(topic.examples.isNotEmpty, true);
      expect(topic.quiz.isNotEmpty, true);
    });

    test('Lưu và đọc tiến độ học tập (bookmark, complete, quiz)', () async {
      const topicId = 'tenses-present-simple-continuous';

      // Bookmark
      final bookmarked = await repo.toggleBookmark(topicId);
      expect(bookmarked, true);
      var bookmarks = await repo.getBookmarkedTopicIds();
      expect(bookmarks.contains(topicId), true);

      // Toggle lại -> xóa
      final unbookmarked = await repo.toggleBookmark(topicId);
      expect(unbookmarked, false);
      bookmarks = await repo.getBookmarkedTopicIds();
      expect(bookmarks.contains(topicId), false);

      // Complete
      await repo.setTopicCompleted(topicId, true);
      var completed = await repo.getCompletedTopicIds();
      expect(completed.contains(topicId), true);

      // Quiz score
      await repo.saveQuizScore(topicId, 3);
      final scores = await repo.getQuizScores();
      expect(scores[topicId], 3);
    });
  });

  group('Nội dung assets/theory/*.json', () {
    final repo = TheoryRepository();
    setUpAll(repo.loadTopics);

    test('toàn vẹn: id duy nhất, quiz hợp lệ, ví dụ khớp highlight', () {
      final topics = repo.getAllTopics();
      final topicIds = <String>{};
      final quizIds = <String>{};
      for (final t in topics) {
        expect(topicIds.add(t.id), true, reason: 'trùng id chủ điểm ${t.id}');
        expect(t.sections, isNotEmpty, reason: '${t.id} không có section');
        expect(['Cơ bản', 'Trung cấp', 'Nâng cao'], contains(t.difficulty), reason: t.id);
        // Nhóm ngữ pháp: highlight là cụm cần tô trong câu. Mẹo thi / Phát âm dùng highlight làm ghi chú.
        final grammar = t.category != TheoryCategory.strategy && t.category != TheoryCategory.pronunciation;
        for (final e in t.examples.where((_) => grammar)) {
          // Highlight dạng "a ... b" (mảnh rời) chỉ để tham khảo, không tô được → bỏ qua.
          if (e.highlight case final h? when !h.contains('...') && !h.contains('->')) {
            expect(e.english.contains(h), true, reason: '${t.id}: highlight "$h" không có trong câu');
          }
        }
        for (final q in t.quiz) {
          expect(quizIds.add(q.id), true, reason: 'trùng id quiz ${q.id}');
          expect(q.options.length, inInclusiveRange(2, 4), reason: q.id);
          expect(q.options.toSet().length, q.options.length, reason: '${q.id}: phương án trùng');
          expect(q.answerIndex, inInclusiveRange(0, q.options.length - 1), reason: q.id);
        }
      }
    });
  });

  group('TheoryController Test', () {
    test('Lọc theo danh mục và tìm kiếm từ khóa', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Nội dung đọc từ assets/theory/*.json (bất đồng bộ).
      container.read(theoryControllerProvider);
      await container.read(theoryRepositoryProvider).loadTopics();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final stateInitial = container.read(theoryControllerProvider);
      expect(stateInitial.filteredTopics.isNotEmpty, true);

      // Lọc danh mục Các thì
      container.read(theoryControllerProvider.notifier).selectCategory(TheoryCategory.tenses);
      var state = container.read(theoryControllerProvider);
      expect(state.selectedCategory, TheoryCategory.tenses);
      expect(state.filteredTopics.every((t) => t.category == TheoryCategory.tenses), true);

      // Tìm kiếm từ khóa "IPA" khi đang lọc thì -> rỗng
      container.read(theoryControllerProvider.notifier).setSearchQuery('IPA');
      state = container.read(theoryControllerProvider);
      expect(state.filteredTopics.isEmpty, true);

      // Xóa lọc category -> ra các bài phát âm IPA
      container.read(theoryControllerProvider.notifier).selectCategory(null);
      state = container.read(theoryControllerProvider);
      expect(state.filteredTopics.isNotEmpty, true);
      expect(state.filteredTopics.every((t) => t.category == TheoryCategory.pronunciation), true);

      // Đợi load tiến độ xong trước khi dispose
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
  });

  group('Theory UI Widget Test', () {
    testWidgets('TheoryHomePage render mượt mà danh sách bài học và thanh tìm kiếm', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final repo = TheoryRepository();
      await tester.runAsync(repo.loadTopics);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [theoryRepositoryProvider.overrideWithValue(repo)],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const TheoryHomePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sổ tay Lý thuyết & Mẹo thi'), findsOneWidget);
      expect(find.text('KHO LÝ THUYẾT & MẸO ETS'), findsOneWidget);
      expect(find.text('Hiện tại đơn & Hiện tại tiếp diễn'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('TheoryDetailPage hiển thị công thức và tương tác Mini Quiz', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final repo = TheoryRepository();
      await tester.runAsync(repo.loadTopics);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [theoryRepositoryProvider.overrideWithValue(repo)],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const TheoryDetailPage(topicId: 'tenses-present-simple-continuous'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hiện tại đơn & Hiện tại tiếp diễn'), findsWidgets);

      // Cuộn xuống tới Mini Quiz (độ dài bài thay đổi theo nội dung → cuộn tới khi thấy).
      final list = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(find.text('Kiểm tra nhanh (Mini Quiz)'), 300, scrollable: list);
      expect(find.text('Kiểm tra nhanh (Mini Quiz)'), findsOneWidget);

      // Chạm vào 1 đáp án của Câu 1
      final optionA = find.text('reviews');
      await tester.scrollUntilVisible(optionA, 200, scrollable: list);
      await tester.pumpAndSettle();
      await tester.tap(optionA);
      await tester.pumpAndSettle();

      // Giải thích chi tiết hiện ra sau khi chọn
      await tester.scrollUntilVisible(find.text('Giải thích chi tiết:').first, 200, scrollable: list);
      expect(find.text('Giải thích chi tiết:'), findsWidgets);
    });
  });
}
