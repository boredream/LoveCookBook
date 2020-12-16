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
            Text(
                // "由kl和pp共同创建的恋爱app！\n"
                // "\n"
                // "本来是我和女朋友自己用的，试用一段时间后觉得还行！就决定优化后上传app供大家使用！\n"
                // "也希望能收集大家对促进恋爱关系的一些创意想法，好继续完善功能！\n"
                // "\n"
                "App现在还在持续更新中，可以通过意见反馈提供您宝贵的意见！"),
          ],
        ),
      ),
    );
  }
}
