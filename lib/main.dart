import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_todo/pages/MenuPageAll.dart';

import 'pages/MainPage.dart';
import 'pages/MenuDetailPage.dart';
import 'pages/MenuPageMain.dart';
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
        "menuMain": (context) => MenuPageMain(),
        "menuAll": (context) => MenuPageAll(),
        "menuDetail": (context) => MenuDetailPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) {
          String routeName = settings.name;
          print('~~~~~~~~~~' + routeName);
          return MainPage();
        });
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("zh", "CH"),
      ],
      locale: Locale("zh"),
    );
  }
}
