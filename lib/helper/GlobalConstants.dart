import 'package:flutter/widgets.dart';
import 'package:flutter_todo/entity/Menu.dart';
import 'package:flutter_todo/pages/AboutPage.dart';
import 'package:flutter_todo/pages/FeedbackPage.dart';
import 'package:flutter_todo/pages/ImageBrowerPage.dart';
import 'package:flutter_todo/pages/LoginPage.dart';
import 'package:flutter_todo/pages/MainPage.dart';
import 'package:flutter_todo/pages/MenuAllPage.dart';
import 'package:flutter_todo/pages/MenuDetailPage.dart';
import 'package:flutter_todo/pages/MenuMainPage.dart';
import 'package:flutter_todo/pages/MoneyPage.dart';
import 'package:flutter_todo/pages/RegularInvestPage.dart';
import 'package:flutter_todo/pages/SplashPage.dart';
import 'package:flutter_todo/pages/TargetDetailEditPage.dart';
import 'package:flutter_todo/pages/TargetItemPage.dart';
import 'package:flutter_todo/pages/TargetListPage.dart';
import 'package:flutter_todo/pages/TargetDetailPage.dart';
import 'package:flutter_todo/pages/TheDayDetailPage.dart';
import 'package:flutter_todo/pages/TodoDetailPage.dart';

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

  static Map<String, StatefulWidget> pages = {
    "login": LoginPage(),
    "main": MainPage(),
    "todoDetail": TodoDetailPage(),
    "menuMain": MenuMainPage(),
    "menuAll": MenuAllPage(),
    "menuDetail": MenuDetailPage(),
    "imageBrowser": ImageBrowserPage(),
    "theDayDetail": TheDayDetailPage(),
    "money": MoneyPage(),
    "regularInvest": RegularInvestPage(),
    "targetList": TargetListPage(),
    "targetDetail": TargetDetailPage(),
    "targetDetailEdit": TargetDetailEditPage(),
    "targetItem": TargetItemPage(),
    "about": AboutPage(),
    "feedback": FeedbackPage(),
    "/": SplashPage(),
  };
}
