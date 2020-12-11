import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/entity/User.dart';
import 'package:flutter_todo/helper/UserHelper.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<UserPage> {

  User _user;
  var settings = [
    {"icon": Icons.system_update, "name": "检查更新", "route": "update"},
    {"icon": Icons.info, "name": "关于", "route": "about"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("我")),
      body: getListView(),
    );
  }

  @override
  void initState() {
    super.initState();

    UserHelper.getUserInfo()
    .then((value) {
      setState(() {
        _user = value;
      });
    });
  }

  getListView() {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => getRow(index),
        separatorBuilder: (context, index) =>
            SizedBox(height: index == settings.length ? 64 : 8),
        itemCount: settings.length + 2);
  }

  getRow(int index) {
    if (index == 0) {
      String userId = _user == null ? "" : _user.username;
      return ListTile(
        title: Text("用户名：$userId"),
      );
    }

    if (index == settings.length + 1) {
      return GestureDetector(
          child: Container(
            height: 56,
            alignment: Alignment.center,
            color: Colors.white,
            child: Text("退出登录"),
          ),
          onTap: () => logout());
    }

    var setting = settings[index - 1];
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(setting["icon"]),
        title: Text(setting["name"]),
        trailing: Icon(Icons.chevron_right),
        onTap: () {

        },
      ),
    );
  }

  logout() {
    DialogUtils.showConfirmDialog(context, "是否确认退出登录？", "确定", () {
      UserHelper.logout();
      Navigator.pop(context);
      Navigator.pushNamed(context, "login");
    });
  }
}
