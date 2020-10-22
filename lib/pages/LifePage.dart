
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LifePage extends StatefulWidget {
  LifePage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<LifePage> {
  @override
  Widget build(BuildContext context) {
    return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //横轴三个子widget
            childAspectRatio: 1.0 //宽高比为1时，子widget
            ),
        children: <Widget>[
          getRow(Icons.cake, "菜单", "menu"),
          getRow(Icons.sports_esports, "游戏", "menu"),
        ]);
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
