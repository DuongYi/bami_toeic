import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/notifications/reminder_service.dart';
import '../../../../helper/format.dart';
import '../../data/study_store.dart';

/// Đặt mục tiêu: điểm, ngày thi, chỉ tiêu mỗi ngày, giờ nhắc học.
Future<void> showGoalSheet(BuildContext context) =>
    showAppBottomSheet<void>(context, builder: (_) => const _GoalSheet());

class _GoalSheet extends ConsumerStatefulWidget {
  const _GoalSheet();

  @override
  ConsumerState<_GoalSheet> createState() => _GoalSheetState();
}

class _GoalSheetState extends ConsumerState<_GoalSheet> {
  GoalSettings? _goals;
  bool _saving = false;

  static const _targets = [450, 550, 650, 750, 850, 950];
  static const _questionOptions = [10, 20, 40, 60];
  static const _wordOptions = [10, 15, 30, 50];

  @override
  void initState() {
    super.initState();
    ref.read(studyStoreProvider).readGoals().then((g) {
      if (mounted) setState(() => _goals = g);
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _goals!.examDate ?? now.add(const Duration(days: 60)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 730)),
      helpText: 'Ngày thi TOEIC',
    );
    if (picked != null) setState(() => _goals = _goals!.copyWith(examDate: picked));
  }

  Future<void> _toggleReminder(bool on) async {
    if (!on) {
      setState(() => _goals = _goals!.copyWith(reminderMinutes: null));
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: _goals!.reminderTime ?? const TimeOfDay(hour: 20, minute: 0),
      helpText: 'Giờ nhắc học',
    );
    if (time == null || !mounted) return;
    final granted = await ref.read(reminderServiceProvider).requestPermission();
    if (!mounted) return;
    if (!granted) {
      showAppSnackBar(
        context,
        'Chưa có quyền gửi thông báo. Bật trong Cài đặt của máy rồi thử lại.',
        tone: AppTone.warning,
      );
      return;
    }
    setState(() => _goals = _goals!.copyWith(reminderMinutes: time.hour * 60 + time.minute));
  }

  Future<void> _save() async {
    final g = _goals!;
    setState(() => _saving = true);
    try {
      await ref.read(studyStoreProvider).saveGoals(g);
      await ref.read(reminderServiceProvider).schedule(g.reminderTime);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showAppSnackBar(context, AppException.from(e).message, tone: AppTone.danger);
    }
  }

  Widget _chips<T>(
    List<T> values,
    T? selected,
    String Function(T) label,
    ValueChanged<T> onSelect,
  ) => Wrap(
    spacing: AppSpacing.s8,
    runSpacing: AppSpacing.s8,
    children: [
      for (final v in values)
        ChoiceChip(
          label: Text(label(v)),
          selected: v == selected,
          onSelected: (_) => setState(() => onSelect(v)),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final g = _goals;
    if (g == null) return const SizedBox(height: AppSizes.ringLg, child: AppLoadingView());
    final muted = context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Mục tiêu học tập', style: context.textStyles.titleLarge),
            Gaps.v16,
            Text('Điểm mục tiêu', style: context.textStyles.titleSmall),
            Gaps.v8,
            _chips(
              _targets,
              g.targetScore,
              (v) => '$v',
              (v) => _goals = g.copyWith(targetScore: v),
            ),
            Gaps.v16,
            AppListGroup(
              children: [
                ListTile(
                  leading: const IconBadge(icon: Icons.event_rounded),
                  title: const Text('Ngày thi'),
                  subtitle: Text(g.examDate == null ? 'Chưa đặt' : Fmt.date(g.examDate!)),
                  trailing: g.examDate == null
                      ? const Icon(Icons.chevron_right_rounded)
                      : IconButton(
                          tooltip: 'Bỏ ngày thi',
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => setState(() => _goals = g.copyWith(examDate: null)),
                        ),
                  onTap: _pickDate,
                ),
                if (ReminderService.supported)
                  SwitchListTile(
                    secondary: const IconBadge(
                      icon: Icons.notifications_active_outlined,
                      tone: AppTone.warning,
                    ),
                    title: const Text('Nhắc học mỗi ngày'),
                    subtitle: Text(
                      g.reminderTime == null ? 'Tắt' : 'Lúc ${g.reminderTime!.format(context)}',
                    ),
                    value: g.reminderTime != null,
                    onChanged: _toggleReminder,
                  ),
              ],
            ),
            Gaps.v16,
            Text('Mỗi ngày làm', style: context.textStyles.titleSmall),
            Gaps.v8,
            _chips(
              _questionOptions,
              g.dailyQuestions,
              (v) => '$v câu',
              (v) => _goals = g.copyWith(dailyQuestions: v),
            ),
            Gaps.v16,
            Text('Từ mới mỗi ngày', style: context.textStyles.titleSmall),
            Gaps.v8,
            _chips(
              _wordOptions,
              g.dailyWords,
              (v) => '$v từ',
              (v) => _goals = g.copyWith(dailyWords: v),
            ),
            Gaps.v8,
            Text(
              'Chuỗi ngày học tăng khi bạn làm câu hỏi, ôn thẻ hoặc chép chính tả.',
              style: muted,
            ),
            Gaps.v16,
            AppPrimaryButton(label: 'Lưu', loading: _saving, onPressed: _saving ? null : _save),
          ],
        ),
      ),
    );
  }
}
