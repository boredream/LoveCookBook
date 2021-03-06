import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_todo/helper/GlobalConstants.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
    Color primaryColor = Color(0xFFFB6565);

    return RefreshConfiguration(
        headerBuilder: () => ClassicHeader(),
        // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
        footerBuilder: () => ClassicFooter(),
        // 配置默认底部指示器
        headerTriggerDistance: 80.0,
        // 头部触发刷新的越界距离
        springDescription:
            SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
        // 自定义回弹动画,三个属性值意义请查询flutter api
        maxOverScrollExtent: 100,
        //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
        maxUnderScrollExtent: 0,
        // 底部最大可以拖动的范围
        enableScrollWhenRefreshCompleted: true,
        //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
        enableLoadingWhenFailed: true,
        //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
        hideFooterWhenNotFull: false,
        // Viewport不满一屏时,禁用上拉加载更多功能
        enableBallisticLoad: true,
        // 可以通过惯性滑动触发加载更多
        child: MaterialApp.router(
          routeInformationParser: MyRouteParser(),
          routerDelegate: delegate,
          debugShowCheckedModeBanner: false,
          title: '恋爱手册',
          theme: ThemeData(
            primaryColor: primaryColor,
            primaryColorLight: Color(0xFFffa5a5),
            primaryColorDark: primaryColor,
            accentColor: primaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            iconTheme: IconThemeData(color: Colors.white),
            primaryColorBrightness: Brightness.dark,
            primaryTextTheme: TextTheme(
              headline6: TextStyle(color: Colors.white),
              subtitle1: TextStyle(color: Colors.black87, fontSize: 16),
              bodyText1: TextStyle(color: Colors.black87, fontSize: 14),
              bodyText2: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: primaryColor),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(primary: primaryColor),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(primary: primaryColor),
            ),
          ),
          localizationsDelegates: [
            RefreshLocalizations.delegate,
            ChineseCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('zh'),
          ],
          locale: Locale("zh"),
        ));
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

  void remove(String routeName) {
    _stack.remove(MyRoutePath(routeName, null));
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
