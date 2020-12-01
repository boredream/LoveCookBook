
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

  static Future<DateTime> showCustomDatePicker(BuildContext context) {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
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
}