import 'dart:io';

import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_todo/entity/User.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';
import 'package:flutter_todo/helper/UpdateHelper.dart';
import 'package:flutter_todo/helper/UserHelper.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    autoLogin();
  }

  void autoLogin() async {
    try {
      int startTime = DateTime.now().millisecond;

      // TODO iOS app id
      await FlutterBugly.init(
          androidAppId: "02a35ff82c", iOSAppId: "your iOS app id");

      // FIXME 必须要先匿名登录，才能调用云函数？
      CloudBaseAuth auth = CloudBaseAuth(CloudBaseHelper.init());
      CloudBaseAuthState authState = await auth.getAuthState();
      User user;
      if (authState == null) {
        authState = await auth.signInAnonymously();
      } else {
        user = await UserHelper.getUserInfo();
      }

      // 获取版本更新信息
      await UpdateHelper.saveVersionInfo();
      await UpdateHelper.saveUpdateInfoList();
      if(UpdateHelper.hasForceVersion()) {
        UpdateHelper.showUpdateDialog(context);
        return;
      }

      Function nextStep = () {
        Navigator.pop(context);
        if (authState.authType == CloudBaseAuthType.ANONYMOUS || user == null) {
          print("not login");
          Navigator.pushNamed(context, "login");
        } else {
          print("login success");
          Navigator.pushNamed(context, "main");
        }
      };

      int dur = DateTime.now().millisecond - startTime;
      if (dur < 2 * 1000) {
        dur = 2000;
      }
      Future.delayed(Duration(milliseconds: dur), nextStep);
    } catch (e) {
      initError(e);
    }
  }

  void initError(e) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text('提示'),
            content: Text('初始化异常，请尝试重新打开app\n${e.toString()}'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => exit(0),
                child: Text('关闭应用'),
              ),
            ],
          ),
        );
      },
    );
    print('error = ' + e.toString());
  }

  @override
  Widget build(BuildContext context) {
    // FIXME 系统和自定义splash间有个fade效果？？
    return Scaffold(
        body: Image(
            image: AssetImage('assets/images/splash.png'), fit: BoxFit.fill));
  }
}
