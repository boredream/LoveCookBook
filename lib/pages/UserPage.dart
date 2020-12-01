import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/helper/UserHelper.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'SplashPage.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("我")),
      body: getListView(),
    );
  }

  int _itemCount = 3;

  getListView() {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => getRow(index),
        separatorBuilder: (context, index) =>
            SizedBox(height: index == _itemCount - 2 ? 32 : 8),
        itemCount: _itemCount);
  }

  getRow(int index) {
    if (index == 0) {
      return ListTile(
        title: Text("用户："),
        onTap: () {},
      );
    }

    if (index == _itemCount - 1) {
      return GestureDetector(
          child: Container(
            height: 56,
            alignment: Alignment.center,
            color: Colors.white,
            child: Text("退出登录"),
          ),
          onTap: () => logout());
    }

    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(Icons.info),
        title: Text("关于"),
        trailing: Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }

  logout() {
    DialogUtils.showDeleteConfirmDialog(context, () {
      UserHelper.logout();
      Navigator.pop(context);
      Navigator.pushNamed(context, "login");
    });
  }
}
