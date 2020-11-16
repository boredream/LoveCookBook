
import 'package:flutter_todo/utils/StringUtils.dart';
import 'package:intl/intl.dart';

class DateUtils {

  /// 字符串转年月日
  static DateTime str2ymd(String timeStr) {
    if(StringUtils.isEmpty(timeStr)) return null;
    return DateFormat("yyyy-MM-dd").parse(timeStr);
  }

  /// 日期转年月日，清空时分秒信息
  static DateTime date2ymd(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// 天数差值
  static int calculateDayDiff(DateTime startDate, DateTime endDate) {
    if(startDate == null || endDate == null) return -1;
    return endDate.difference(startDate).inDays;
  }

}