import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo/helper/NotificationHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'LifePage.dart';
import 'TheDayPage.dart';
import 'TodoListPage.dart';
import 'UserPage.dart';

class MainPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<MainPage> {
  int _selectedIndex = 0;
  DateTime _lastPopTime;

  List<Widget> _pages = <Widget>[
    TabTodoListPage(),
    TheDayPage(),
    LifePage(),
    UserPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    NotificationHelper.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: '待办',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: '纪念日',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wb_sunny),
              label: '日常',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '我',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
        ),
      ),
      onWillPop: () async {
        // 点击返回键的操作
        if (_lastPopTime == null ||
            DateTime.now().difference(_lastPopTime) > Duration(seconds: 2)) {
          _lastPopTime = DateTime.now();
          Fluttertoast.showToast(msg: '再按一次退出');
        } else {
          _lastPopTime = DateTime.now();
          // 退出app
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        return false;
      },
    );
  }
}
