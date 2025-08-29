import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
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

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isReminderOn = prefs.getBool('daily_reminder') ?? false;
    notifyListeners();
  }

  Future<void> _savePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', value);
  }

  Future<void> _initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await flutterLocalNotificationsPlugin.initialize(settings);
    tz.initializeTimeZones();
  }

  Future<void> _scheduleDailyReminder() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Waktunya Istirahat!',
      'Sudah jam 23:15, jangan lupa tidur cukup 😴',
      _nextInstanceOf11(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Reminder',
          channelDescription: 'Reminder harian jam 23:15 malam',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOf11() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      11, // menitnya
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
}
