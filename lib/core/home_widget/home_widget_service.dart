import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../notifications/reminder_service.dart';

part 'home_widget_service.g.dart';

@Riverpod(keepAlive: true)
HomeWidgetService homeWidgetService(Ref ref) => HomeWidgetService();

/// Đẩy số liệu học (chuỗi ngày, nhiệm vụ, thẻ cần ôn) ra widget màn hình chính.
/// Widget native đọc các khoá `bami_*`: Android `StudyWidgetProvider`, iOS `BamiStudyWidget`.
class HomeWidgetService {
  /// App Group dùng chung giữa app và Widget Extension trên iOS.
  static const appGroupId = 'group.com.app.bami.toeic';
  static const _android = 'com.app.bami.toeic.StudyWidgetProvider';
  static const _ios = 'BamiStudyWidget';

  static bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  bool _ready = false;
  HabitStatus? _last;

  Future<void> _init() async {
    if (_ready) return;
    await HomeWidget.setAppGroupId(appGroupId);
    _ready = true;
  }

  Future<void> update(HabitStatus s) async {
    if (!supported || s == _last) return;
    _last = s;
    try {
      await _init();
      await Future.wait([
        HomeWidget.saveWidgetData<bool>('bami_signed_in', true),
        HomeWidget.saveWidgetData<int>('bami_streak', s.streak),
        HomeWidget.saveWidgetData<bool>('bami_studied_today', s.studiedToday),
        HomeWidget.saveWidgetData<int>('bami_due_words', s.dueWords),
        HomeWidget.saveWidgetData<int>('bami_missions_done', s.missionsDone),
        HomeWidget.saveWidgetData<int>('bami_missions_total', s.missionsTotal),
        // Ngày lấy số liệu: widget tự coi "đã học hôm nay" là sai khi sang ngày mới.
        HomeWidget.saveWidgetData<String>('bami_day', _dayKey(s.day)),
      ]);
      await HomeWidget.updateWidget(qualifiedAndroidName: _android, iOSName: _ios);
    } catch (_) {
      // Chưa cài widget / iOS chưa bật App Group → bỏ qua, không ảnh hưởng app.
    }
  }

  /// Đăng xuất: widget hiện lời mời đăng nhập thay vì số liệu của tài khoản cũ.
  Future<void> clear() async {
    if (!supported) return;
    _last = null;
    try {
      await _init();
      await HomeWidget.saveWidgetData<bool>('bami_signed_in', false);
      await HomeWidget.updateWidget(qualifiedAndroidName: _android, iOSName: _ios);
    } catch (_) {}
  }

  static String _dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
