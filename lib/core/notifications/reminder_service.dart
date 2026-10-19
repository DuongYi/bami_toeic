import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

part 'reminder_service.g.dart';

@Riverpod(keepAlive: true)
ReminderService reminderService(Ref ref) => ReminderService();

/// Nhắc học mỗi ngày bằng thông báo cục bộ (không cần server).
class ReminderService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  static const _id = 1;

  static bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  Future<void> _init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    }
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: darwin,
        macOS: darwin,
      ),
    );
    _ready = true;
  }

  /// Xin quyền (gọi khi người dùng bật nhắc). Trả về false nếu bị từ chối.
  Future<bool> requestPermission() async {
    if (!supported) return false;
    await _init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) return await android.requestNotificationsPermission() ?? false;
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    }
    final mac = _plugin
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();
    return await mac?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
  }

  /// Giờ nhắc đang đặt (null = tắt) và tình hình học gần nhất để soạn nội dung nhắc.
  TimeOfDay? _time;
  bool _timeKnown = false;
  HabitStatus? _status;

  /// Số ngày đặt sẵn thông báo; không mở app lâu hơn thì hết nhắc (tránh làm phiền người đã bỏ).
  static const _days = 14;
  static const _streakId = 100;

  /// Nhắc "chuỗi sắp đứt" lúc này nếu giờ nhắc chính sớm hơn; muộn hơn thì sau giờ nhắc 90 phút.
  static const _streakAt = TimeOfDay(hour: 21, minute: 30);
  static const _streakAfter = Duration(minutes: 90);

  /// Đặt lại lịch nhắc; [time] null = tắt.
  Future<void> schedule(TimeOfDay? time) async {
    _time = time;
    _timeKnown = true;
    await _reschedule();
  }

  /// Cập nhật tình hình học hôm nay (học xong → bỏ nhắc hôm nay, sắp mất chuỗi → nhắc thêm).
  Future<void> updateStatus(HabitStatus status) async {
    if (status == _status) return;
    _status = status;
    // Chưa đọc giờ nhắc từ mục tiêu → chưa đặt lại, tránh huỷ lịch cũ.
    if (_timeKnown) await _reschedule();
  }

  Future<void> _reschedule() async {
    if (!supported) return;
    await _init();
    await _plugin.cancel(id: _id); // lịch lặp hằng ngày của bản cũ
    for (var d = 0; d < _days; d++) {
      await _plugin.cancel(id: _id + 1 + d);
    }
    await _plugin.cancel(id: _streakId);
    final time = _time;
    if (time == null) return;
    final status = _status;
    final now = tz.TZDateTime.now(tz.local);
    final today = tz.TZDateTime(tz.local, now.year, now.month, now.day);
    final doneToday = status != null && status.isToday(now) && status.studiedToday;

    for (var d = 0; d < _days; d++) {
      if (d == 0 && doneToday) continue;
      final day = today.add(Duration(days: d));
      final at = tz.TZDateTime(tz.local, day.year, day.month, day.day, time.hour, time.minute);
      if (!at.isAfter(now)) continue;
      await _show(_id + 1 + d, at, 'Đến giờ luyện TOEIC', _body(d == 0 ? status : null));
    }

    // Đang có chuỗi mà hôm nay chưa học → nhắc thêm một lần buổi tối.
    if (status != null && status.isToday(now) && !doneToday && status.streak > 0) {
      final main = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
      final fixed = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        _streakAt.hour,
        _streakAt.minute,
      );
      final at = main.isBefore(fixed) ? fixed : main.add(_streakAfter);
      if (at.isAfter(now) && at.day == now.day) {
        await _show(
          _streakId,
          at,
          'Chuỗi ${status.streak} ngày sắp đứt',
          'Hôm nay bạn chưa học. Ôn vài thẻ từ hoặc làm 5 câu để giữ chuỗi nhé.',
        );
      }
    }
  }

  static String _body(HabitStatus? s) {
    final parts = <String>[
      if (s != null && s.dueWords > 0) 'Có ${s.dueWords} thẻ từ đến hạn ôn',
      if (s != null && s.streak > 0) 'đang giữ chuỗi ${s.streak} ngày',
    ];
    if (parts.isEmpty) return 'Giữ chuỗi ngày học: làm vài câu hoặc ôn thẻ từ vựng hôm nay nhé.';
    final text = parts.join(', ');
    return '${text[0].toUpperCase()}${text.substring(1)}. Học vài phút thôi nhé.';
  }

  Future<void> _show(int id, tz.TZDateTime at, String title, String body) => _plugin.zonedSchedule(
    id: id,
    scheduledDate: at,
    title: title,
    body: body,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_reminder',
        'Nhắc học hằng ngày',
        channelDescription: 'Nhắc luyện TOEIC mỗi ngày',
        importance: Importance.defaultImportance,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    ),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
  );
}

/// Tình hình học trong ngày [day] – nguồn cho nhắc học và widget màn hình chính.
@immutable
class HabitStatus {
  const HabitStatus({
    required this.day,
    required this.studiedToday,
    required this.streak,
    required this.dueWords,
    required this.missionsDone,
    required this.missionsTotal,
  });

  /// Ngày (giờ máy) lúc lấy số liệu.
  final DateTime day;
  final bool studiedToday;
  final int streak;
  final int dueWords;
  final int missionsDone;
  final int missionsTotal;

  bool isToday(DateTime now) =>
      day.year == now.year && day.month == now.month && day.day == now.day;

  @override
  bool operator ==(Object other) =>
      other is HabitStatus &&
      isToday(other.day) &&
      other.studiedToday == studiedToday &&
      other.streak == streak &&
      other.dueWords == dueWords &&
      other.missionsDone == missionsDone &&
      other.missionsTotal == missionsTotal;

  @override
  int get hashCode => Object.hash(
    day.year,
    day.month,
    day.day,
    studiedToday,
    streak,
    dueWords,
    missionsDone,
    missionsTotal,
  );
}
