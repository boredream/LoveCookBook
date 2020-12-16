import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_todo/pages/AboutPage.dart';
import 'package:flutter_todo/pages/FeedbackPage.dart';
import 'package:flutter_todo/pages/FundPage.dart';
import 'package:flutter_todo/pages/LoginPage.dart';
import 'package:flutter_todo/pages/MenuAllPage.dart';
import 'package:flutter_todo/pages/MoneyPage.dart';
import 'package:flutter_todo/pages/RegularInvestPage.dart';
import 'package:flutter_todo/pages/SplashPage.dart';
import 'package:flutter_todo/pages/TheDayDetailPage.dart';

import 'helper/ChineseCupertinoLocalizations.dart';
import 'pages/ImageBrowerPage.dart';
import 'pages/MainPage.dart';
import 'pages/MenuDetailPage.dart';
import 'pages/MenuMainPage.dart';
import 'pages/TodoDetailPage.dart';

void main() async {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();

    const bool kReleaseMode =
        bool.fromEnvironment('dart.vm.product', defaultValue: false);
    if (kReleaseMode) {
      FlutterError.onError = (FlutterErrorDetails errorDetails) {
        FlutterBugly.uploadException(
            message: errorDetails.exception.toString(),
            detail: "onError: " + errorDetails.stack.toString());
      };
    }
    runApp(App());
  }, (Object error, StackTrace stack) {
    FlutterBugly.uploadException(
        message: error.toString(), detail: "error: " + stack.toString());
  });
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFFB6565),
        primaryColorLight: Color(0xFFffa5a5),
        primaryColorDark: Color(0xFFFB6565),
        accentColor: Color(0xFFFB6565),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(color: Colors.white),
        primaryColorBrightness: Brightness.dark,
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
      ),
      initialRoute: "splash",
      routes: {
        "splash": (context) => SplashPage(),
        "login": (context) => LoginPage(),
        "main": (context) => MainPage(),
        "todoDetail": (context) => TodoDetailPage(),
        "menuMain": (context) => MenuMainPage(),
        "menuAll": (context) => MenuAllPage(),
        "menuDetail": (context) => MenuDetailPage(),
        "imageBrowser": (context) => ImageBrowserPage(),
        "theDayDetail": (context) => TheDayDetailPage(),
        "money": (context) => MoneyPage(),
        "regularInvest": (context) => RegularInvestPage(),
        "fund": (context) => FundPage(),
        "about": (context) => AboutPage(),
        "feedback": (context) => FeedbackPage(),
      },
      localizationsDelegates: [
        ChineseCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale("zh", "CH"),
        const Locale('zh', 'Hans'),
        const Locale('zh', ''),
      ],
      locale: Locale("zh"),
    );
  }
}
