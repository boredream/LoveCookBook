import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_todo/helper/GlobalConstants.dart';
import 'package:provider/provider.dart';

import 'helper/ChineseCupertinoLocalizations.dart';

void main() async {
  runZonedGuarded(() {
    const bool kReleaseMode =
        bool.fromEnvironment('dart.vm.product', defaultValue: false);
    if (kReleaseMode) {
      FlutterError.onError = (FlutterErrorDetails errorDetails) {
        FlutterBugly.uploadException(
            message: errorDetails.exception.toString(),
            detail: "onError: " + errorDetails.stack.toString());
      };
    }
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RefreshNotifier()),
      ],
      child: App(),
    ));
  }, (Object error, StackTrace stack) {
    FlutterBugly.uploadException(
        message: error.toString(), detail: "error: " + stack.toString());
  });
}

class App extends StatelessWidget {
  final delegate = MyRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: MyRouteParser(),
      routerDelegate: delegate,
      debugShowCheckedModeBanner: false,
      title: '恋爱手册',
      theme: ThemeData(
        primaryColor: Color(0xFFFB6565),
        primaryColorLight: Color(0xFFffa5a5),
        primaryColorDark: Color(0xFFFB6565),
        accentColor: Color(0xFFFB6565),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(color: Colors.white),
        primaryColorBrightness: Brightness.dark,
        primaryTextTheme: TextTheme(
          headline6: TextStyle(color: Colors.white),
          subtitle1: TextStyle(color: Colors.black87, fontSize: 16),
          bodyText1: TextStyle(color: Colors.black87, fontSize: 14),
          bodyText2: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ),
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

class RefreshNotifier with ChangeNotifier {
  Set<String> refreshList = Set();

  void needRefresh(String name) {
    refreshList.add(name);
    notifyListeners();
  }
}

class MyPage extends Page {
  MyPage({
    LocalKey key,
    String name,
    Object arguments,
  }) : super(
          key: key,
          name: name,
          arguments: arguments,
        );

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return GlobalConstants.pages[name];
      },
    );
  }
}

class MyRouteParser extends RouteInformationParser<MyRoutePath> {
  @override
  Future<MyRoutePath> parseRouteInformation(RouteInformation routeInformation) {
    return SynchronousFuture(
        MyRoutePath(routeInformation.location, routeInformation.state));
  }

  @override
  RouteInformation restoreRouteInformation(MyRoutePath configuration) {
    return RouteInformation(
        location: configuration.name, state: configuration.arguments);
  }
}

class MyRoutePath {
  String name;
  Object arguments;

  MyRoutePath(this.name, this.arguments);

  @override
  bool operator ==(Object other) => other is MyRoutePath && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }
}

class MyRouteDelegate extends RouterDelegate<MyRoutePath>
    with PopNavigatorRouterDelegateMixin<MyRoutePath>, ChangeNotifier {
  final _stack = <MyRoutePath>[];

  static MyRouteDelegate of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is MyRouteDelegate, 'Delegate type must match');
    return delegate as MyRouteDelegate;
  }

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  MyRoutePath get currentConfiguration =>
      _stack.isNotEmpty ? _stack.last : null;

  List<String> get stack => List.unmodifiable(_stack);

  void push(String routeName, {Object arguments}) {
    _stack.add(MyRoutePath(routeName, arguments));
    notifyListeners();
  }

  void remove(MyRoutePath route) {
    _stack.remove(route);
    notifyListeners();
  }

  void pop() {
    _stack.removeLast();
    notifyListeners();
  }

  @override
  Future<void> setInitialRoutePath(MyRoutePath configuration) {
    return setNewRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(MyRoutePath configuration) {
    _stack
      ..clear()
      ..add(configuration);
    return SynchronousFuture<void>(null);
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (_stack.isNotEmpty) {
      if (_stack.last.name == route.settings.name) {
        _stack.removeLast();
        notifyListeners();
      }
    }
    return route.didPop(result);
  }

  @override
  Widget build(BuildContext context) {
    print('stack: $_stack');
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: [
        for (final path in _stack)
          MyPage(
            key: ValueKey(path.name),
            name: path.name,
            arguments: path.arguments,
          ),
      ],
    );
  }
}
