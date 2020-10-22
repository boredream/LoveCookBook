import 'package:flutter/material.dart';

import 'pages/DishPage.dart';
import 'pages/MainPage.dart';
import 'pages/MenuPage.dart';
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
        "dish": (context) => DishPage(),
        "todoDetail": (context) => TodoDetailPage(),
        "menu": (context) => MenuPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) {
          String routeName = settings.name;
          print('~~~~~~~~~~' + routeName);
          return MainPage();
        });
      },
    );
  }
}
