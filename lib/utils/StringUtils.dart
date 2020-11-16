
import 'package:intl/intl.dart';

class StringUtils {
  static String formatMoney(int money) {
    double moneyWan = 0.0001 * money;
    return NumberFormat("0.0").format(moneyWan) + "w";
  }

  static bool isEmpty(String str) {
    return str == null || str.trim().length == 0;
  }
}