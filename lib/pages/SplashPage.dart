
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<SplashPage> {
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
        Navigator.pushNamed(context, routeName);
      },
    );
  }
}