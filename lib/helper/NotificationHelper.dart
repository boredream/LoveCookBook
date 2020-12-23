import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationHelper {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Shanghai"));

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('app_icon');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: (String payload) async {
      // TODO
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      // selectNotificationSubject.add(payload);
    });
  }

  static _getAndroidNotificationDetails() {
    return AndroidNotificationDetails('channel.lovecookbook', '待办清单', '',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
  }

  static showNotification(String title, String body, {String payload}) async {
    await flutterLocalNotificationsPlugin.show(0, title, body,
        NotificationDetails(android: _getAndroidNotificationDetails()),
        payload: payload);
  }

  static showNotificationAtTime(String title, String body, DateTime date,
      {String payload}) async {
    tz.TZDateTime notifyDate = tz.TZDateTime(tz.local, date.year, date.month,
        date.day, date.hour, date.minute, date.second, 10);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        notifyDate,
        NotificationDetails(android: _getAndroidNotificationDetails()),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
