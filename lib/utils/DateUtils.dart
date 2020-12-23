
import 'package:flutter/material.dart';
import 'package:flutter_todo/utils/StringUtils.dart';
import 'package:intl/intl.dart';

class DateUtils {

  /// 字符串转日期
  static DateTime str2date(String timeStr) {
    if(StringUtils.isEmpty(timeStr)) return null;
    return DateFormat("yyyy-MM-dd").parse(timeStr);
  }

  /// 日期清空时分秒信息
  static DateTime dateClearHMS(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// 天数差值
  static int calculateDayDiff(DateTime startDate, DateTime endDate) {
    if(startDate == null || endDate == null) return -1;
    return endDate.difference(startDate).inDays;
  }

  /// 选择日期
  static Future<DateTime> showCustomDatePicker(BuildContext context, {DateTime initialDate}) {
    return showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2200),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: Theme.of(context).primaryColor,
              ),
            ),
            child: child,
          );
        }
    );
  }

  /// 选择日期+时间
  static Future<String> showCustomDateTimePicker(BuildContext context, {DateTime initialDate, TimeOfDay initialTime}) async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2200),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: Theme.of(context).primaryColor,
              ),
            ),
            child: child,
          );
        });
    if (date == null) return null;
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: initialTime,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: Theme.of(context).primaryColor,
              ),
            ),
            child: child,
          );
        }
    );
    if (time == null) return null;

    date = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return DateFormat("yyyy-MM-dd HH:mm").format(date);
  }
}