import 'package:flutter/material.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';

import 'EatPage.dart';
import 'LifePage.dart';
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
    LifePage(),
    Text(
      'Index 2: School',
    ),
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
      appBar: AppBar(
        title: const Text('团建手册'),
      ),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: '日常',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: '里程碑',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
