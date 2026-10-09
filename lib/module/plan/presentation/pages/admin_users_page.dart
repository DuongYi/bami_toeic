import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../helper/format.dart';
import '../../data/models/plan_models.dart';
import '../../data/plan_repository.dart';
import '../controllers/plan_controller.dart';

/// Admin: tìm học viên theo email, cấp / gia hạn / thu hồi PRO.
class AdminUsersPage extends ConsumerStatefulWidget {
  const AdminUsersPage({super.key});

  @override
  ConsumerState<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends ConsumerState<AdminUsersPage> {
  final _search = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(AppMotion.long, () => setState(() => _query = v.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(adminUsersProvider(_query));
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý học viên')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(adminUsersProvider(_query).future),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: AppInsets.screen,
              sliver: SliverToBoxAdapter(
                child: TextField(
                  controller: _search,
                  onChanged: _onChanged,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    labelText: 'Tìm theo email',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),
            ),
            ...users.when(
              skipLoadingOnRefresh: true,
              loading: () => const [SliverFillRemaining(child: AppLoadingView())],
              error: (e, _) => [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppErrorView(
                    message: AppException.from(e).message,
                    onRetry: () => ref.invalidate(adminUsersProvider(_query)),
                  ),
                ),
              ],
              data: (list) => list.isEmpty
                  ? const [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: AppEmptyView(
                          icon: Icons.person_search_outlined,
                          message: 'Không có học viên nào khớp email này.',
                        ),
                      ),
                    ]
                  : [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screen,
                          0,
                          AppSpacing.screen,
                          AppSpacing.s32,
                        ),
                        sliver: AppSliverListGroup(
                          itemCount: list.length,
                          dividerIndent: AppSpacing.s16 + AppSizes.badgeMd + AppSpacing.s16,
                          itemBuilder: (_, i) => _UserTile(user: list[i], query: _query),
                        ),
                      ),
                    ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user, required this.query});

  final AdminUser user;
  final String query;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final (label, tone) = switch (user) {
      AdminUser(isAdmin: true) => ('Admin', AppTone.info),
      _ when user.isProAt(now) => ('PRO', AppTone.warning),
      _ => ('Free', AppTone.neutral),
    };
    final subtitle = [
      if (!user.isAdmin && user.proUntil != null)
        user.isProAt(now)
            ? 'PRO đến ${Fmt.date(user.proUntil!.toLocal())}'
            : 'PRO hết hạn ${Fmt.date(user.proUntil!.toLocal())}',
      'Tạo ${Fmt.date(user.createdAt.toLocal())}',
    ].join(' · ');

    return ListTile(
      leading: IconBadge(icon: Icons.person_rounded, tone: tone),
      title: Text(user.email ?? user.userId, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle),
      trailing: StatusBadge(label: label, tone: tone),
      onTap: user.isAdmin
          ? null
          : () => showAppBottomSheet<void>(
              context,
              builder: (_) => _GrantSheet(user: user, query: query),
            ),
    );
  }
}

class _GrantSheet extends ConsumerStatefulWidget {
  const _GrantSheet({required this.user, required this.query});

  final AdminUser user;
  final String query;

  @override
  ConsumerState<_GrantSheet> createState() => _GrantSheetState();
}

class _GrantSheetState extends ConsumerState<_GrantSheet> {
  static const _options = [30, 90, 180, 365];
  int? _busyDays;

  Future<void> _grant(int days) async {
    if (days <= 0) {
      final ok = await showAppConfirmDialog(
        context,
        title: 'Thu hồi PRO?',
        message: '${widget.user.email} sẽ chỉ còn dùng được đề miễn phí.',
        confirmLabel: 'Thu hồi',
        destructive: true,
      );
      if (!ok || !mounted) return;
    }
    setState(() => _busyDays = days);
    try {
      final until = await ref.read(planRepositoryProvider).grantPro(widget.user.userId, days);
      ref.invalidate(adminUsersProvider(widget.query));
      if (!mounted) return;
      Navigator.pop(context);
      showAppSnackBar(
        context,
        until == null ? 'Đã thu hồi PRO' : 'PRO có hạn đến ${Fmt.date(until.toLocal())}',
        tone: AppTone.success,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _busyDays = null);
      showAppSnackBar(context, AppException.from(e).message, tone: AppTone.danger);
    }
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.user;
    final active = u.isProAt(DateTime.now());
    final busy = _busyDays != null;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.s16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(active ? 'Gia hạn PRO' : 'Cấp PRO', style: context.textStyles.titleLarge),
            Gaps.v4,
            Text(
              active
                  ? '${u.email} · đang có PRO đến ${Fmt.date(u.proUntil!.toLocal())}. '
                        'Số ngày được cộng thêm vào hạn hiện tại.'
                  : '${u.email} · đang dùng gói miễn phí.',
              style: context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
            ),
            Gaps.v16,
            Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: [
                for (final d in _options)
                  FilledButton.tonal(
                    onPressed: busy ? null : () => _grant(d),
                    child: _busyDays == d ? const AppInlineSpinner() : Text('+$d ngày'),
                  ),
              ],
            ),
            if (active) ...[
              Gaps.v16,
              OutlinedButton.icon(
                onPressed: busy ? null : () => _grant(0),
                icon: const Icon(Icons.block_rounded),
                label: const Text('Thu hồi PRO'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
