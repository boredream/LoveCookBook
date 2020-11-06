import 'package:flutter_todo/entity/Menu.dart';

class GlobalConstants {

  static const EAT_TYPE_ALL = '全部';
  static const EAT_TYPE_HOME = '自己做';
  static const EAT_TYPE_OUTSIDE = '出去吃';
  static const menuTypes = [EAT_TYPE_ALL, EAT_TYPE_HOME, EAT_TYPE_OUTSIDE];

  static const TODO_TYPE_EAT = "美食";
  static const TODO_TYPE_VIDEO = "看剧";
  static const TODO_TYPE_TRAVEL = "出游";
  static const TODO_TYPE_HOME = "宅家";
  static const TODO_TYPE_OTHER = "其它";
  static const todoTypes = [
    TODO_TYPE_EAT,
    TODO_TYPE_VIDEO,
    TODO_TYPE_TRAVEL,
    TODO_TYPE_HOME,
    TODO_TYPE_OTHER
  ];

  static List<Menu> allMenu;
}
