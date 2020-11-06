
import 'package:intl/intl.dart';

class DateUtils {

  /// 字符串转年月日
  static DateTime str2ymd(String timeStr) {
    return DateFormat("yyyy-MM-dd").parse(timeStr);
  }

  /// 日期转年月日，清空时分秒信息
  static DateTime date2ymd(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

}