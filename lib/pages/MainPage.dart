import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'LifePage.dart';
import 'TheDayPage.dart';
import 'TodoListPage.dart';

class MainPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<Widget> _pages = <Widget>[
    TabTodoListPage(),
    TheDayPage(),
    LifePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getBody() {
    return IndexedStack(
        index: _selectedIndex,
        children: _pages,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '纪念日',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: '日常',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
