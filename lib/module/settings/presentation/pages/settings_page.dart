import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/notifications/reminder_service.dart';
import '../../../../core/tts/tts_service.dart';
import '../../../../routes/app_router.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../goals/data/study_store.dart';
import '../../../goals/presentation/widgets/goal_sheet.dart';
import '../../../leaderboard/data/models/leaderboard_models.dart';
import '../../../leaderboard/presentation/controllers/leaderboard_controller.dart';
import '../../../leaderboard/presentation/widgets/leaderboard_profile_sheet.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final ok = await showAppConfirmDialog(
      context,
      title: 'Đăng xuất?',
      message: 'Bạn sẽ cần nhập lại email và mật khẩu để tiếp tục học.',
      confirmLabel: 'Đăng xuất',
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    await ref.read(authControllerProvider.notifier).signOut();
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final ok = await showAppConfirmDialog(
      context,
      title: 'Xoá tài khoản?',
      message:
          'Toàn bộ bài làm, từ vựng riêng, mục tiêu và hạng của bạn sẽ bị xoá vĩnh viễn. '
          'Không thể hoàn tác.',
      confirmLabel: 'Xoá vĩnh viễn',
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    try {
      await ref.read(authControllerProvider.notifier).deleteAccount();
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, AppException.from(e).message, tone: AppTone.danger);
      }
    }
  }

  Future<void> _toggleReminder(
    BuildContext context,
    WidgetRef ref,
    bool on,
    GoalSettings goals,
  ) async {
    if (!on) {
      await ref.read(studyStoreProvider).saveGoals(goals.copyWith(reminderMinutes: null));
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: goals.reminderTime ?? const TimeOfDay(hour: 20, minute: 0),
      helpText: 'Giờ nhắc học TOEIC hằng ngày',
    );
    if (time == null || !context.mounted) return;
    final granted = await ref.read(reminderServiceProvider).requestPermission();
    if (!granted && context.mounted) {
      showAppSnackBar(
        context,
        'Cần cấp quyền thông báo trong Cài đặt hệ thống để nhận lời nhắc',
        tone: AppTone.warning,
      );
      return;
    }
    final minutes = time.hour * 60 + time.minute;
    await ref.read(studyStoreProvider).saveGoals(goals.copyWith(reminderMinutes: minutes));
    if (context.mounted) {
      showAppSnackBar(
        context,
        'Đã đặt lịch nhắc học vào ${time.format(context)} mỗi ngày',
        tone: AppTone.success,
      );
    }
  }

  Future<void> _pickReminderTime(BuildContext context, WidgetRef ref, GoalSettings goals) async {
    final time = await showTimePicker(
      context: context,
      initialTime: goals.reminderTime ?? const TimeOfDay(hour: 20, minute: 0),
      helpText: 'Đổi giờ nhắc học TOEIC',
    );
    if (time == null || !context.mounted) return;
    final minutes = time.hour * 60 + time.minute;
    await ref.read(studyStoreProvider).saveGoals(goals.copyWith(reminderMinutes: minutes));
    if (context.mounted) {
      showAppSnackBar(
        context,
        'Đã cập nhật giờ nhắc học thành ${time.format(context)}',
        tone: AppTone.success,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final selectedFont = ref.watch(appFontFamilyProvider);
    final ttsSpeed = ref.watch(ttsSpeedProvider);
    final autoPlay = ref.watch(autoPlayAudioProvider);
    final lbProfile = ref.watch(myLeaderboardProfileProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cài đặt',
          style: context.textStyles.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: FutureBuilder<GoalSettings>(
        future: ref.watch(studyStoreProvider).readGoals(),
        builder: (context, snapshot) {
          final goals = snapshot.data ?? const GoalSettings();
          final hasReminder = goals.reminderMinutes != null;
          final reminderTime = goals.reminderTime;

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.s8,
              AppSpacing.screen,
              AppSpacing.s48,
            ),
            children: [
              // 1. GIAO DIỆN & HIỂN THỊ
              const SectionHeader(
                title: 'Giao diện & hiển thị',
              ),
              _ThemeVisualSelector(
                currentMode: themeMode,
                onSelected: (mode) {
                  ref.read(appThemeModeProvider.notifier).setThemeMode(mode);
                },
              ),
              Gaps.v16,

              // 2. PHÔNG CHỮ ỨNG DỤNG
              const SectionHeader(
                title: 'Phông chữ ứng dụng',
              ),
              _FontFamilySelector(
                selectedFont: selectedFont,
                onSelected: (font) {
                  ref.read(appFontFamilyProvider.notifier).setFontFamily(font);
                },
              ),
              Gaps.v16,

              // 3. NHẮC NHỞ HỌC TẬP
              const SectionHeader(
                title: 'Nhắc nhở học tập',
              ),
              AppListGroup(
                children: [
                  SwitchListTile(
                    secondary: const IconBadge(
                      icon: Icons.notifications_active_outlined,
                      tone: AppTone.info,
                    ),
                    title: const Text('Nhắc học mỗi ngày'),
                    subtitle: Text(
                      hasReminder && reminderTime != null
                          ? 'Thông báo lúc ${reminderTime.format(context)}'
                          : 'Bật thông báo để không đứt chuỗi học tập',
                    ),
                    value: hasReminder,
                    onChanged: (on) => _toggleReminder(context, ref, on, goals),
                  ),
                  if (hasReminder && reminderTime != null)
                    ListTile(
                      leading: const IconBadge(
                        icon: Icons.access_time_rounded,
                        tone: AppTone.neutral,
                      ),
                      title: const Text('Giờ nhận thông báo'),
                      subtitle: const Text('Chạm để thay đổi giờ nhắc'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s12,
                          vertical: AppSpacing.s4,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.primaryContainer,
                          borderRadius: AppRadius.brSm,
                        ),
                        child: Text(
                          reminderTime.format(context),
                          style: context.textStyles.labelLarge?.copyWith(
                            color: context.colors.onPrimaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      onTap: () => _pickReminderTime(context, ref, goals),
                    ),
                  ListTile(
                    leading: const IconBadge(
                      icon: Icons.flag_outlined,
                      tone: AppTone.warning,
                    ),
                    title: const Text('Mục tiêu điểm số & chỉ tiêu'),
                    subtitle: Text(
                      '${goals.targetScore != null ? 'Mục tiêu ${goals.targetScore} điểm' : 'Chưa đặt điểm'} · ${goals.dailyQuestions} câu/ngày',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => showGoalSheet(context),
                  ),
                ],
              ),
              Gaps.v16,

              // 4. ÂM THANH & PHÁT ÂM
              const SectionHeader(
                title: 'Âm thanh & phát âm',
              ),
              AppListGroup(
                children: [
                  ListTile(
                    leading: const IconBadge(
                      icon: Icons.record_voice_over_outlined,
                      tone: AppTone.info,
                    ),
                    title: const Text('Tốc độ đọc tiếng Anh'),
                    subtitle: const Text('Áp dụng khi tra từ & luyện nghe từ vựng'),
                    trailing: OutlinedButton.icon(
                      onPressed: () {
                        ref
                            .read(ttsServiceProvider)
                            .speak('Welcome to Bami TOEIC');
                      },
                      icon: const Icon(Icons.play_arrow_rounded, size: AppSizes.iconSm),
                      label: const Text('Nghe thử'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s16,
                      0,
                      AppSpacing.s16,
                      AppSpacing.s12,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<double>(
                        segments: const [
                          ButtonSegment(
                            value: TtsSpeedNotifier.slowSpeed,
                            label: Text('0.35x Chậm'),
                          ),
                          ButtonSegment(
                            value: TtsSpeedNotifier.defaultSpeed,
                            label: Text('0.45x Chuẩn'),
                          ),
                          ButtonSegment(
                            value: TtsSpeedNotifier.fastSpeed,
                            label: Text('0.60x Nhanh'),
                          ),
                        ],
                        selected: {ttsSpeed},
                        showSelectedIcon: false,
                        onSelectionChanged: (val) {
                          ref.read(ttsSpeedProvider.notifier).setSpeed(val.first);
                        },
                      ),
                    ),
                  ),
                  SwitchListTile(
                    secondary: const IconBadge(
                      icon: Icons.volume_up_outlined,
                      tone: AppTone.neutral,
                    ),
                    title: const Text('Tự động phát âm flashcard'),
                    subtitle: const Text('Phát âm giọng đọc khi lật xem từ vựng mới'),
                    value: autoPlay,
                    onChanged: (v) {
                      ref.read(autoPlayAudioProvider.notifier).setAutoPlay(v);
                    },
                  ),
                ],
              ),
              Gaps.v16,

              // 5. HỒ SƠ & BẢNG XẾP HẠNG
              const SectionHeader(
                title: 'Hồ sơ & bảng xếp hạng',
              ),
              AppListGroup(
                children: [
                  ListTile(
                    leading: const IconBadge(
                      icon: Icons.badge_outlined,
                      tone: AppTone.neutral,
                    ),
                    title: const Text('Đạo hiệu hiển thị'),
                    subtitle: Text(
                      lbProfile?.displayName ?? 'Chưa đặt đạo hiệu (Học viên mặc định)',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => showLeaderboardProfileSheet(context),
                  ),
                  SwitchListTile(
                    secondary: const IconBadge(
                      icon: Icons.leaderboard_outlined,
                      tone: AppTone.info,
                    ),
                    title: const Text('Hiển thị trên bảng xếp hạng'),
                    subtitle: Text(
                      (lbProfile?.showOnLeaderboard ?? true)
                          ? 'Công khai thành tích và điểm full test cao nhất'
                          : 'Chỉ riêng bạn nhìn thấy vị trí của mình',
                    ),
                    value: lbProfile?.showOnLeaderboard ?? true,
                    onChanged: (show) async {
                      try {
                        await ref.read(myLeaderboardProfileProvider.notifier).save(
                              LeaderboardProfile(
                                displayName: lbProfile?.displayName,
                                showOnLeaderboard: show,
                              ),
                            );
                      } catch (e) {
                        if (context.mounted) {
                          showAppSnackBar(
                            context,
                            AppException.from(e).message,
                            tone: AppTone.danger,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
              Gaps.v16,

              // 6. DỮ LIỆU & BỘ NHỚ
              const SectionHeader(
                title: 'Dữ liệu & bộ nhớ',
              ),
              AppListGroup(
                children: [
                  ListTile(
                    leading: const IconBadge(
                      icon: Icons.cleaning_services_outlined,
                      tone: AppTone.neutral,
                    ),
                    title: const Text('Dọn dẹp bộ nhớ đệm'),
                    subtitle: const Text('Giải phóng dung lượng ảnh và audio tạm thời'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      showAppSnackBar(
                        context,
                        'Đã dọn dẹp bộ nhớ đệm an toàn',
                        tone: AppTone.success,
                      );
                    },
                  ),
                ],
              ),
              Gaps.v16,

              // 7. THÔNG TIN ỨNG DỤNG
              const SectionHeader(
                title: 'Thông tin ứng dụng',
              ),
              AppListGroup(
                children: [
                  ListTile(
                    leading: const IconBadge(
                      icon: Icons.info_outline_rounded,
                      tone: AppTone.neutral,
                    ),
                    title: const Text('Phiên bản Bami TOEIC'),
                    trailing: Text(
                      'v1.0.0 (Build 3)',
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (kDebugMode) ...[
                    ListTile(
                      leading: const IconBadge(
                        icon: Icons.palette_outlined,
                        tone: AppTone.neutral,
                      ),
                      title: const Text('Thư viện Design System'),
                      subtitle: const Text('Xem gallery token và component chuẩn M3'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push(Routes.designSystem),
                    ),
                    ListTile(
                      leading: const IconBadge(
                        icon: Icons.bug_report_outlined,
                        tone: AppTone.neutral,
                      ),
                      title: const Text('Nhật ký ứng dụng (Debug logs)'),
                      subtitle: const Text('Xem log mạng, lỗi và sự kiện phát sinh'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push(Routes.debugLogs),
                    ),
                  ],
                ],
              ),
              Gaps.v16,

              // 8. TÀI KHOẢN (VÙNG NGUY HIỂM)
              const SectionHeader(
                title: 'Tài khoản',
              ),
              AppListGroup(
                children: [
                  ListTile(
                    leading: const IconBadge(
                      icon: Icons.logout_rounded,
                      tone: AppTone.danger,
                    ),
                    title: Text(
                      'Đăng xuất',
                      style: TextStyle(
                        color: context.colors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text('Thoát phiên đăng nhập trên thiết bị này'),
                    onTap: () => _signOut(context, ref),
                  ),
                  ListTile(
                    leading: const IconBadge(
                      icon: Icons.delete_forever_outlined,
                      tone: AppTone.danger,
                    ),
                    title: Text(
                      'Xoá tài khoản',
                      style: TextStyle(
                        color: context.colors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text('Xoá vĩnh viễn toàn bộ bài làm và dữ liệu cá nhân'),
                    onTap: () => _deleteAccount(context, ref),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Bộ chọn theme trực quan với 3 thẻ thanh lịch, bo góc nhẹ nhàng và bóng êm.
class _ThemeVisualSelector extends StatelessWidget {
  const _ThemeVisualSelector({
    required this.currentMode,
    required this.onSelected,
  });

  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ThemeOptionCard(
            label: 'Hệ thống',
            icon: Icons.brightness_auto_outlined,
            selected: currentMode == ThemeMode.system,
            onTap: () => onSelected(ThemeMode.system),
          ),
        ),
        Gaps.h8,
        Expanded(
          child: _ThemeOptionCard(
            label: 'Sáng',
            icon: Icons.light_mode_outlined,
            selected: currentMode == ThemeMode.light,
            onTap: () => onSelected(ThemeMode.light),
          ),
        ),
        Gaps.h8,
        Expanded(
          child: _ThemeOptionCard(
            label: 'Tối',
            icon: Icons.dark_mode_outlined,
            selected: currentMode == ThemeMode.dark,
            onTap: () => onSelected(ThemeMode.dark),
          ),
        ),
      ],
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  const _ThemeOptionCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? context.colors.primaryContainer.withValues(alpha: 0.35)
          : context.surfaces.raised,
      elevation: selected ? 1.5 : 0.5,
      shadowColor: context.colors.shadow.withValues(alpha: selected ? 0.08 : 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.brMd,
        side: selected
            ? BorderSide(color: context.colors.primary, width: 1.5)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.brMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s12,
            horizontal: AppSpacing.s8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.badgeMd,
                height: AppSizes.badgeMd,
                decoration: BoxDecoration(
                  color: selected
                      ? context.colors.primary
                      : context.colors.surfaceContainerHighest,
                  borderRadius: AppRadius.brSm,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: AppSizes.iconSm,
                    color: selected ? context.colors.onPrimary : context.colors.onSurfaceVariant,
                  ),
                ),
              ),
              Gaps.v8,
              Text(
                label,
                style: context.textStyles.labelMedium?.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? context.colors.primary : context.colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bộ chọn phông chữ trực quan, tinh tế và gọn gàng.
class _FontFamilySelector extends StatelessWidget {
  const _FontFamilySelector({
    required this.selectedFont,
    required this.onSelected,
  });

  final String? selectedFont;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final fonts = [
      (
        key: AppFontFamilyNotifier.fontBeVietnamPro,
        name: 'Be Vietnam Pro',
        desc: 'Chuẩn Tiếng Việt · Cân đối, thanh thoát',
      ),
      (
        key: AppFontFamilyNotifier.fontManrope,
        name: 'Manrope',
        desc: 'Hiện đại · Tối ưu số và đề thi ETS',
      ),
      (
        key: AppFontFamilyNotifier.fontSystem,
        name: 'Mặc định hệ thống',
        desc: 'Phông gốc của thiết bị (SF Pro / Roboto)',
      ),
    ];

    return AppListGroup(
      children: [
        for (final item in fonts)
          _FontOptionTile(
            fontKey: item.key,
            fontName: item.name,
            fontDesc: item.desc,
            isSelected: (selectedFont ?? AppFontFamilyNotifier.fontManrope) == item.key,
            onTap: () => onSelected(item.key),
          ),
      ],
    );
  }
}

class _FontOptionTile extends StatelessWidget {
  const _FontOptionTile({
    required this.fontKey,
    required this.fontName,
    required this.fontDesc,
    required this.isSelected,
    required this.onTap,
  });

  final String fontKey;
  final String fontName;
  final String fontDesc;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSys = fontKey == AppFontFamilyNotifier.fontSystem;
    final family = isSys ? null : fontKey;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: AppSizes.badgeMd,
        height: AppSizes.badgeMd,
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primaryContainer
              : context.colors.surfaceContainerHighest,
          borderRadius: AppRadius.brSm,
        ),
        child: Center(
          child: Text(
            'Aa',
            style: TextStyle(
              fontFamily: family,
              fontWeight: FontWeight.w700,
              color: isSelected ? context.colors.onPrimaryContainer : context.colors.onSurface,
            ),
          ),
        ),
      ),
      title: Text(
        fontName,
        style: context.textStyles.titleMedium?.copyWith(
          fontFamily: family,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          color: isSelected ? context.colors.primary : context.colors.onSurface,
        ),
      ),
      subtitle: Text(
        fontDesc,
        style: context.textStyles.bodySmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle_rounded,
              color: context.colors.primary,
              size: AppSizes.iconMd,
            )
          : Icon(
              Icons.radio_button_unchecked_rounded,
              color: context.colors.outlineVariant,
              size: AppSizes.iconMd,
            ),
    );
  }
}

