
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'SplashPage.dart';

class LifePage extends StatefulWidget {
  LifePage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<LifePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("日常")),
      body: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //横轴三个子widget
              childAspectRatio: 1.0 //宽高比为1时，子widget
              ),
          children: <Widget>[
            getRow(Icons.room_service_outlined, "菜单", "menuMain"),
            // getRow(Icons.attach_money, "理财", "money"),
            // getRow(Icons.attach_money, "理财", "regularInvest"),
          ]),
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
        Navigator.pushNamed(context, routeName);
      },
    );
  }
}
