import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/helper/UpdateHelper.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("关于")),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Image(
                    width: 92,
                    height: 92,
                    image: AssetImage('assets/images/logo.png'))),
            SizedBox(height: 16),
            Text(UpdateHelper.appName),
            Text(UpdateHelper.version),
            SizedBox(height: 32),
            Text("App现在还在持续更新中，可以通过意见反馈提供您宝贵的意见！\n\n待开发功能：\n * 手机号绑定\n * 日历提醒"),
          ],
        ),
      ),
    );
  }
}
