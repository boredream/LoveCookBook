import 'package:flutter/material.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';

import 'EatPage.dart';
import 'LifePage.dart';
import 'TheDayPage.dart';
import 'TodoListPage.dart';

class MainPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<MainPage> {
  bool _hasInit = false;
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    TabTodoListPage(),
    TheDayPage(),
    LifePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    CloudBaseHelper.login().then((value) {
      setState(() {
        print("login success!");
        _hasInit = true;
      });
    });
  }

  getBody() {
    if (_hasInit) {
      return Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
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
