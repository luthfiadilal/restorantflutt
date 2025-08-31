import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderViewModel extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isReminderOn = false;
  bool get isReminderOn => _isReminderOn;

  ReminderViewModel() {
    _loadPreference();
    _initNotifications();
  }

  /// 🔹 Load preference (apakah reminder aktif atau tidak)
  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isReminderOn = prefs.getBool('daily_reminder') ?? false;
    debugPrint("🔄 Load preference: daily_reminder=$_isReminderOn");
    notifyListeners();
  }

  /// 🔹 Simpan state reminder
  Future<void> _savePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', value);
    debugPrint("💾 Save preference: daily_reminder=$value");
  }

  /// 🔹 Init notification + request permission
  Future<void> _initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await flutterLocalNotificationsPlugin.initialize(settings);
    debugPrint("✅ Notifications initialized");

    // ✅ Timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    debugPrint("🌍 Timezone initialized: ${tz.local.name}");

    // ✅ Android 13+ : request notification permission
    if (Platform.isAndroid) {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      final granted = await androidPlugin?.requestNotificationsPermission();
      debugPrint("🔔 POST_NOTIFICATIONS granted: $granted");

      // ✅ Android 12 kebawah: request exact alarm permission
      final alarmGranted = await androidPlugin?.requestExactAlarmsPermission();
      debugPrint("⏰ SCHEDULE_EXACT_ALARM granted: $alarmGranted");
    }
  }

  /// 🔹 Jadwalkan notifikasi harian
  Future<void> _scheduleDailyReminder() async {
    final scheduledTime = _nextInstanceOf11();
    debugPrint("📅 Scheduling notification at: $scheduledTime");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Waktunya Makan! 🍽️',
      'Sudah jam 11:00, yuk cari makan di restoran favoritmu!',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Reminder',
          channelDescription: 'Reminder harian jam 11:00',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint("✅ Notification scheduled successfully");
  }

  /// 🔹 Hitung jam 11:00 berikutnya
  tz.TZDateTime _nextInstanceOf11() {
    final now = tz.TZDateTime.now(tz.local);

    // 🔧 Untuk testing bisa diganti ke now.add(Duration(minutes: 1))
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      11,
      00,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    debugPrint("⏳ Next reminder time calculated: $scheduledDate");
    return scheduledDate;
  }

  /// 🔹 Cancel notifikasi
  Future<void> _cancelReminder() async {
    await flutterLocalNotificationsPlugin.cancel(0);
    debugPrint("❌ Notification cancelled");
  }

  /// 🔹 Toggle reminder ON/OFF
  Future<void> toggleReminder(bool value) async {
    _isReminderOn = value;
    await _savePreference(value);

    if (value) {
      debugPrint("🔔 Turning ON reminder");
      await _scheduleDailyReminder();
    } else {
      debugPrint("🔕 Turning OFF reminder");
      await _cancelReminder();
    }
    notifyListeners();
  }
}
