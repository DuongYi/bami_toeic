import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../helper/format.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../test/presentation/controllers/test_providers.dart';
import '../../data/models/plan_models.dart';
import '../controllers/plan_controller.dart';

/// Giới thiệu Bami PRO + cách được cấp (admin cấp thủ công theo email).
Future<void> showProSheet(BuildContext context) =>
    showAppBottomSheet<void>(context, builder: (_) => const _ProSheet());

class _ProSheet extends ConsumerStatefulWidget {
  const _ProSheet();

  @override
  ConsumerState<_ProSheet> createState() => _ProSheetState();
}

class _ProSheetState extends ConsumerState<_ProSheet> {
  bool _reloading = false;

  Future<void> _copyEmail(String email) async {
    await Clipboard.setData(ClipboardData(text: email));
    if (mounted) showAppSnackBar(context, 'Đã sao chép email', tone: AppTone.success);
  }

  Future<void> _reload() async {
    setState(() => _reloading = true);
    final MyPlan plan;
    try {
      plan = await ref.refresh(myPlanProvider.future);
    } catch (e) {
      if (!mounted) return;
      setState(() => _reloading = false);
      showAppSnackBar(context, AppException.from(e).message, tone: AppTone.danger);
      return;
    }
    ref.invalidate(testListProvider);
    if (!mounted) return;
    setState(() => _reloading = false);
    if (plan.isPro) {
      Navigator.pop(context);
      showAppSnackBar(context, 'Đã mở khoá Bami PRO', tone: AppTone.success);
    } else {
      showAppSnackBar(context, 'Tài khoản chưa được cấp PRO', tone: AppTone.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ref.watch(authControllerProvider).value?.user.email ?? '';
    final plan = ref.watch(myPlanProvider).value;
    final muted = context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Bami PRO', style: context.textStyles.titleLarge),
                Gaps.h8,
                const ProBadge(mini: true),
              ],
            ),
            Gaps.v4,
            Text(
              plan?.isPro == true
                  ? (plan!.isAdmin
                        ? 'Bạn là quản trị viên, có toàn quyền.'
                        : 'Đang dùng PRO đến ${Fmt.date(plan.proUntil!.toLocal())}.')
                  : 'Tài khoản miễn phí: đề mẫu đủ 7 Part, toàn bộ từ vựng và bảng xếp hạng chăm chỉ.',
              style: muted,
            ),
            Gaps.v16,
            const AppListGroup(
              children: [
                ListTile(
                  leading: IconBadge(icon: Icons.menu_book_rounded),
                  title: Text('Mọi đề ETS full 200 câu'),
                  subtitle: Text('Chấm điểm quy đổi TOEIC, xem lại giải thích từng câu'),
                ),
                ListTile(
                  leading: IconBadge(icon: Icons.headphones_rounded, tone: AppTone.info),
                  title: Text('Chép chính tả với mọi đề'),
                  subtitle: Text('Luyện nghe Part 1–4 bằng audio của tất cả đề'),
                ),
                ListTile(
                  leading: IconBadge(icon: Icons.workspace_premium_rounded, tone: AppTone.warning),
                  title: Text('Ghi danh Cảnh giới'),
                  subtitle: Text('Điểm full test được xếp hạng trên Thương Khung Bảng'),
                ),
              ],
            ),
            if (plan?.isPro != true) ...[
              Gaps.v16,
              Text('Cách nâng cấp', style: context.textStyles.titleSmall),
              Gaps.v4,
              Text(
                'Tài khoản PRO do quản trị viên Bami TOEIC cấp. Gửi email đăng nhập của bạn '
                'cho quản trị viên, sau khi được kích hoạt bấm "Tải lại".',
                style: muted,
              ),
              Gaps.v12,
              AppCard(
                padding: AppInsets.card,
                child: Row(
                  children: [
                    Expanded(child: SelectableText(email, style: context.textStyles.bodyLarge)),
                    IconButton(
                      tooltip: 'Sao chép email',
                      icon: const Icon(Icons.copy_rounded),
                      onPressed: email.isEmpty ? null : () => _copyEmail(email),
                    ),
                  ],
                ),
              ),
              Gaps.v16,
              AppPrimaryButton(
                label: 'Tải lại',
                icon: Icons.refresh_rounded,
                loading: _reloading,
                onPressed: _reloading ? null : _reload,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
