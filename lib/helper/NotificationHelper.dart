import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_todo/entity/TheDay.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:flutter_todo/main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static init(BuildContext context) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Shanghai"));

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('app_icon');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: (String payload) async {
      if (payload != null && payload.contains(":::")) {
        String type = payload.split(":::")[0];
        String data = payload.split(":::")[1];
        if (type == "theDay") {
          MyRouteDelegate.of(context).push("theDayDetail",
              arguments: {"theDay": TheDay.fromJson(json.decode(data))});
        } else if(type == "todo") {
          MyRouteDelegate.of(context).push("todoDetail",
              arguments: {"todo": Todo.fromJson(json.decode(data))});
        }
      }
    });
  }

  static _getAndroidNotificationDetails(String type) {
    var channelId = "channel.lovecookbook." + type;
    var channelName = type;
    var channelDesc = "";
    return AndroidNotificationDetails(channelId, channelName, channelDesc,
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
  }

  static showNotification(String type, String title, String body,
      {String payload}) async {
    await flutterLocalNotificationsPlugin.show(0, title, body,
        NotificationDetails(android: _getAndroidNotificationDetails(type)),
        payload: payload);
  }

  static showNotificationAtTime(
      String type, String title, String body, DateTime date,
      {String payload}) async {
    tz.TZDateTime notifyDate = tz.TZDateTime(tz.local, date.year, date.month,
        date.day, date.hour, date.minute, date.second, 10);
    debugPrint("showNotificationAtTime " + notifyDate.toString());
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        notifyDate,
        NotificationDetails(android: _getAndroidNotificationDetails(type)),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
