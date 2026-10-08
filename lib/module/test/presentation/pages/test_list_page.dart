import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../routes/app_router.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/test_providers.dart';

class TestListPage extends ConsumerWidget {
  const TestListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(testListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đề thi'),
        actions: [
          if (kDebugMode)
            IconButton(
              tooltip: 'Design System',
              icon: const Icon(Icons.palette_outlined),
              onPressed: () => context.push(Routes.designSystem),
            ),
          IconButton(
            tooltip: 'Đăng xuất',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(testListProvider.future),
        child: AsyncView(
          value: tests,
          onRetry: () => ref.invalidate(testListProvider),
          data: (list) => list.isEmpty
              ? const ScrollableFill(
                  child: AppEmptyView(
                    icon: Icons.inbox_outlined,
                    message: 'Chưa có đề nào.\nDùng script tool/import_test.dart để thêm đề.',
                  ),
                )
              : ListView.separated(
                  padding: AppInsets.screen,
                  itemCount: list.length,
                  separatorBuilder: (_, _) => Gaps.v8,
                  itemBuilder: (context, i) {
                    final t = list[i];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${i + 1}')),
                        title: Text(t.title, style: context.textStyles.titleMedium),
                        subtitle: Text(
                          [if (t.source != null) t.source!, '${t.questionCount} câu'].join(' · '),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.go(Routes.testDetail(t.id)),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
