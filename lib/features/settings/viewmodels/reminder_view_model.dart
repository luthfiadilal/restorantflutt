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

  /// Default: jam 11:00
  int _hour = 11;
  int _minute = 0;

  int get hour => _hour;
  int get minute => _minute;

  ReminderViewModel() {
    _loadPreference();
    _initNotifications();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isReminderOn = prefs.getBool('daily_reminder') ?? false;
    _hour = prefs.getInt('reminder_hour') ?? 11;
    _minute = prefs.getInt('reminder_minute') ?? 0;
    debugPrint("🔄 Load prefs: reminder=$_isReminderOn, time=$_hour:$_minute");
    notifyListeners();
  }

  Future<void> _savePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', value);
  }

  Future<void> _saveTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_hour', hour);
    await prefs.setInt('reminder_minute', minute);
    debugPrint("💾 Save reminder time: $hour:$minute");
  }

  Future<void> _initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await flutterLocalNotificationsPlugin.initialize(settings);
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    if (Platform.isAndroid) {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await androidPlugin?.requestNotificationsPermission();
      await androidPlugin?.requestExactAlarmsPermission();
    }
  }

  Future<void> _scheduleDailyReminder() async {
    final scheduledTime = _nextInstanceOfTime(_hour, _minute);
    debugPrint("📅 Scheduling notification at: $scheduledTime");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Waktunya Makan! 🍽️',
      'Sudah jam $_hour:$_minute, yuk cari makan di restoran favoritmu!',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Reminder',
          channelDescription: 'Reminder harian sesuai pilihan',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _cancelReminder() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> toggleReminder(bool value) async {
    _isReminderOn = value;
    await _savePreference(value);

    if (value) {
      await _scheduleDailyReminder();
    } else {
      await _cancelReminder();
    }
    notifyListeners();
  }

  /// 🔹 Ganti jam reminder dari UI
  Future<void> setReminderTime(TimeOfDay time) async {
    _hour = time.hour;
    _minute = time.minute;
    await _saveTime(_hour, _minute);

    if (_isReminderOn) {
      await _scheduleDailyReminder();
    }
    notifyListeners();
  }
}
