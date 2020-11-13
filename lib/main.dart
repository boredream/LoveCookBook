import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_todo/pages/MenuAllPage.dart';
import 'package:flutter_todo/pages/MoneyPage.dart';
import 'package:flutter_todo/pages/TheDayDetailPage.dart';

import 'helper/ChineseCupertinoLocalizations.dart';
import 'pages/ImageBrowerPage.dart';
import 'pages/MainPage.dart';
import 'pages/MenuDetailPage.dart';
import 'pages/MenuMainPage.dart';
import 'pages/TodoDetailPage.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => MainPage(),
        "todoDetail": (context) => TodoDetailPage(),
        "menuMain": (context) => MenuMainPage(),
        "menuAll": (context) => MenuAllPage(),
        "menuDetail": (context) => MenuDetailPage(),
        "imageBrowser": (context) => ImageBrowserPage(),
        "theDayDetail": (context) => TheDayDetailPage(),
        "money": (context) => MoneyPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) {
          String routeName = settings.name;
          print('~~~~~~~~~~' + routeName);
          return MainPage();
        });
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
