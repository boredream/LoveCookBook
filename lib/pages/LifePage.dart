
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:leancloud_storage/leancloud.dart';

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
            getRow(Icons.cake, "菜单", "menuMain"),
            // getRow(Icons.attach_money, "理财", "money"),
            getRow(Icons.attach_money, "理财", "regularInvest"),
          ]),
    );
  }

  getRow(var icon, var name, var routeName) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          SizedBox(height: 8),
          Text(name),
        ],
      ),
      onTap: () {
        CloudBaseHelper.login("papi", "123456")
            .then((value) => {print("登录 $value")});
        // Navigator.pushNamed(context, routeName);
      },
    );
  }
}
