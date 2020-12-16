import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/entity/User.dart';
import 'package:flutter_todo/helper/UpdateHelper.dart';
import 'package:flutter_todo/helper/UserHelper.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<UserPage> {
  User _user;
  var settings = [
    {"icon": Icons.system_update, "name": "检查更新"},
    {"icon": Icons.info, "name": "关于", "route": "about"},
  ];
  ProgressDialog _dialog;

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

    _dialog = DialogUtils.getProgressDialog(context);
    UserHelper.getUserInfo().then((value) {
      setState(() {
        _user = value;
      });
    });
  }

  getListView() {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => getRow(index),
        separatorBuilder: (context, index) => getDivider(context, index),
        itemCount: settings.length + 2);
  }

  getDivider(BuildContext context, int index) {
    List<Widget> divider = [];
    if (index > 0) {
      divider.add(Divider(height: 1));
    }
    if (index == settings.length) {
      divider.add(SizedBox(height: 128));
    }
    return Column(children: divider, mainAxisSize: MainAxisSize.min);
  }

  getRow(int index) {
    if (index == 0) {
      String userId = _user == null ? "" : _user.username;
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("用户名：$userId", style: TextStyle(fontSize: 20)),
          ],
        ),
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
    var name = setting["name"];
    var rightInfo = "";
    var route = setting["route"];
    if (name == "检查更新") {
      rightInfo = UpdateHelper.version;
    }
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(setting["icon"]),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name),
            Text(rightInfo,
                style: TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          switch (name) {
            case "检查更新":
              checkUpdate();
              break;
            default:
              Navigator.pushNamed(context, route);
              break;
          }
        },
      ),
    );
  }

  void checkUpdate() {
    _dialog.show();
    UpdateHelper.getAndSaveUpdateInfoList().then((value) {
      _dialog.hide();
      UpdateHelper.showUpdateDialog(context, cancelable: true);
    }).catchError((e) {
      _dialog.hide();
      Fluttertoast.showToast(msg: "检查更新失败。error = ${e.toString()}");
    });
  }

  logout() {
    DialogUtils.showConfirmDialog(context, "是否确认退出登录？", "确定", () {
      UserHelper.logout();
      Navigator.pop(context);
      Navigator.pushNamed(context, "login");
    });
  }
}
