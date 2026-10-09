import 'package:bami_toeic/core/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppSliverListGroup chỉ dựng các dòng đang hiện (1000 dòng)', (tester) async {
    var built = 0;
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: CustomScrollView(
            controller: scroll,
            slivers: [
              AppSliverListGroup(
                itemCount: 1000,
                itemBuilder: (context, i) {
                  built++;
                  return ListTile(title: Text('từ $i'), onTap: () {});
                },
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.text('từ 0'), findsOneWidget);
    expect(find.text('từ 999'), findsNothing);
    expect(built, lessThan(40)); // trước đây: dựng đủ 1000

    // Cuộn xuống giữa danh sách: các dòng ở đó được dựng khi cần
    scroll.jumpTo(scroll.position.maxScrollExtent / 2);
    await tester.pump();
    final mid = find.textContaining(RegExp(r'^từ [45]\d\d$'));
    expect(mid, findsWidgets);
    await tester.tap(mid.first); // chạm được (có Material cho ripple)
    await tester.pump();
  });
}
