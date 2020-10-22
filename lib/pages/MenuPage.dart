import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MenuPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<MenuPage> {
  bool _hasLoadData = true;
  List<String> _menuRandomTypes = ["全部", "自己做", "出去吃"];
  String _curMenuRandomType;

  @override
  void initState() {
    super.initState();
    _curMenuRandomType = _menuRandomTypes[0];
    loadData();
  }

  void loadData() {}

  loadDataError(error) {
    Fluttertoast.showToast(msg: "加载失败 " + error.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("菜单")),
      body: getBody(),
    );
  }

  getBody() {
    if (_hasLoadData) {
      return Column(
        children: [
          Row(
            children: [
              FlatButton(
                  onPressed: () => randomMenu(),
                  child: Text("吃点儿嘛？点我随机选择菜品",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                      ))),
            ],
          ),
          getRandomTypes(),
          Row(
            children: [
              SizedBox(width: 16),
              Text("随机结果："),
              SizedBox(width: 12),
              GestureDetector(
                child: Text("土豆炒肉丝", style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).primaryColor,
                )),
                onTap: () {

                },
              ),
            ],
          ),
          SizedBox(height: 64),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlineButton(
                onPressed: () {},
                child: Text(_menuRandomTypes[1]),
                textColor: Theme.of(context).primaryColor,
              ),
              OutlineButton(
                onPressed: () {},
                child: Text(_menuRandomTypes[2]),
                textColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ],
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  randomMenu() {}

  getRandomTypes() {
    List<Widget> list = List<Widget>();
    list.add(SizedBox(width: 16));
    list.add(Text("随机类型："));
    for (String type in _menuRandomTypes) {
      list.add(Radio(
        value: type,
        groupValue: _curMenuRandomType,
        onChanged: (value) {
          setState(() {
            _curMenuRandomType = value;
          });
        },
      ));
      list.add(Text(type));
    }
    return Row(children: list);
  }
}
