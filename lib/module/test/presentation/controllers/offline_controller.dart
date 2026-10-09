import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/media/offline_store.dart';
import '../../data/test_repository.dart';

part 'offline_controller.g.dart';

/// Trạng thái tải offline của 1 đề.
sealed class OfflineState {
  const OfflineState();
}

class OfflineNone extends OfflineState {
  const OfflineNone();
}

class OfflineDownloading extends OfflineState {
  const OfflineDownloading(this.progress);
  final double progress;
}

class OfflineReady extends OfflineState {
  const OfflineReady(this.entry);
  final OfflineEntry entry;
}

/// keepAlive: rời trang chi tiết đề vẫn giữ tiến độ tải.
@Riverpod(keepAlive: true)
class OfflineTest extends _$OfflineTest {
  @override
  Future<OfflineState> build(String testId) async {
    final entry = (await ref.watch(offlineStoreProvider).index())[testId];
    return entry == null ? const OfflineNone() : OfflineReady(entry);
  }

  /// Ném lỗi để UI hiện thông báo; trạng thái quay về như trước.
  Future<void> download() async {
    final before = state.value ?? const OfflineNone();
    state = const AsyncData(OfflineDownloading(0));
    try {
      final entry = await ref
          .read(testRepositoryProvider)
          .downloadTest(
            testId,
            onProgress: (p) {
              if (ref.mounted) state = AsyncData(OfflineDownloading(p));
            },
          );
      if (ref.mounted) state = AsyncData(OfflineReady(entry));
    } catch (_) {
      if (ref.mounted) state = AsyncData(before);
      rethrow;
    }
  }

  Future<void> remove() async {
    await ref.read(testRepositoryProvider).removeOffline(testId);
    if (ref.mounted) state = const AsyncData(OfflineNone());
  }
}
