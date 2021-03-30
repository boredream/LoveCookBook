import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Menu.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/helper/GlobalConstants.dart';
import 'package:flutter_todo/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MenuMainPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<MenuMainPage> {
  bool _hasLoadData = false;
  List<String> _menuRandomTypes = GlobalConstants.menuTypes;
  List<Menu> _totalMenuList = [];
  List<Menu> _homeMenuList = [];
  List<Menu> _outSideMenuList = [];
  Menu _curRandomMenu;
  String _curRandomMenuType;

  @override
  void initState() {
    super.initState();
    _curRandomMenuType = GlobalConstants.EAT_TYPE_ALL;
    loadData();
  }

  void loadData() {
    DataHelper.loadData(DataHelper.COLLECTION_MENU).then((value) {
      if (!this.mounted) return;
      if (value.code != null) {
        loadDataError(value.message);
        return;
      }

      setState(() {
        _hasLoadData = true;
        _totalMenuList = (value.data as List)
            .map((e) => Menu.fromJson(new Map<String, dynamic>.from(e)))
            .toList();
        GlobalConstants.allMenu = _totalMenuList;
        for (Menu menu in _totalMenuList) {
          if (GlobalConstants.EAT_TYPE_HOME == menu.type) {
            _homeMenuList.add(menu);
          } else if (GlobalConstants.EAT_TYPE_OUTSIDE == menu.type) {
            _outSideMenuList.add(menu);
          }
        }
      });
    }).catchError(loadDataError);
  }

  loadDataError(error) {
    Fluttertoast.showToast(msg: "加载失败 " + error.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("菜单"),
        actions: [
          Center(
              child: TextButton(
            child: Text("全部菜品", style: TextStyle(color: Colors.white)),
            onPressed: () => MyRouteDelegate.of(context).push("menuAll"),
          )),
        ],
      ),
      body: getBody(),
    );
  }

  List<Menu> getTargetMenuList() {
    if (_curRandomMenuType == GlobalConstants.EAT_TYPE_HOME) {
      return _homeMenuList;
    } else if (_curRandomMenuType == GlobalConstants.EAT_TYPE_OUTSIDE) {
      return _outSideMenuList;
    }
    return _totalMenuList;
  }

  getBody() {
    if (_hasLoadData) {
      String randomBtnText = "吃点儿嘛？点我随机选择菜品";
      if (_hasLoadData) {
        randomBtnText += "（共 ${getTargetMenuList().length} 个选择）";
      }

      String randomMenuName = _curRandomMenu == null
          ? "[未选择]" : _curRandomMenu.name;

      return Column(
        children: [
          SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => randomMenu(),
            child: Text(randomBtnText,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                )),
          ),
          getRandomTypes(),
          Row(
            children: [
              SizedBox(width: 16),
              Text("随机结果："),
              SizedBox(width: 12),
              GestureDetector(
                child: Text(randomMenuName,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).primaryColor,
                    )),
                onTap: () {
                  if (_curRandomMenu != null) {
                    MyRouteDelegate.of(context).push("menuDetail", arguments: {
                      "type": _curRandomMenu.type,
                      "menu": _curRandomMenu
                    });
                    // .then((value) => loadData());
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 64),
        ],
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  randomMenu() {
    List<Menu> list = getTargetMenuList();
    if(list == null || list.length == 0) return;
    setState(() {
      _curRandomMenu = list[Random().nextInt(list.length)];
    });
  }

  getRandomTypes() {
    List<Widget> list = List<Widget>();
    list.add(SizedBox(width: 16));
    list.add(Text("随机类型："));
    for (String type in _menuRandomTypes) {
      // FIXME 横向radio？
      list.add(GestureDetector(
          onTap: () {
            setState(() {
              _curRandomMenuType = type;
            });
          },
          child: Row(
            children: [
              Radio(
                value: type,
                groupValue: _curRandomMenuType,
                onChanged: (value) {
                  setState(() {
                    _curRandomMenuType = type;
                  });
                },
              ),
              Text(type),
            ],
          )));
    }
    return Row(children: list);
  }
}
