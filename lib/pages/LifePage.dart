
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/helper/UserHelper.dart';
import 'package:flutter_todo/main.dart';

class LifePage extends StatefulWidget {
  LifePage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<LifePage> {
  @override
  Widget build(BuildContext context) {

    List<Widget> items = [
      getRow(Icons.room_service_outlined, "菜单", "menuMain"),
      getRow(Icons.assignment_turned_in_outlined, "目标", "targetList"),
    ];
    if (UserHelper.curUser.username == "papi") {
      items.add(getRow(Icons.attach_money, "理财", "regularInvest"));
    }

    return Scaffold(
      appBar: AppBar(title: Text("日常")),
      body: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //横轴三个子widget
              childAspectRatio: 1.0 //宽高比为1时，子widget
              ),
          children: items),
    );
  }

  getRow(var icon, var name, var routeName) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Theme.of(context).primaryColor),
          SizedBox(height: 8),
          Text(name),
        ],
      ),
      onTap: () {
        MyRouteDelegate.of(context).push(routeName);
      },
    );
  }
}
