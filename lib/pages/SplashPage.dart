import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo/entity/User.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';
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
    int startTime = DateTime.now().millisecond;

    // FIXME 必须要先匿名登录，才能调用云函数？
    CloudBaseAuth auth = CloudBaseAuth(CloudBaseHelper.init());
    CloudBaseAuthState authState = await auth.getAuthState();
    if (authState == null) {
      authState = await auth.signInAnonymously();
    }
    User user = await UserHelper.getUserInfo();

    Function nextStep = () {
      Navigator.pop(context);
      if (authState.authType == CloudBaseAuthType.ANONYMOUS || user == null) {
        print("not login");
        Navigator.pushNamed(context, "login");
      } else {
        print("login success");
        Navigator.pushNamed(context, "main");
      }
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    };

    int dur = DateTime.now().millisecond - startTime;
    if (dur < 2 * 1000) {
      dur = 2000;
    }
    Future.delayed(Duration(milliseconds: dur), nextStep);
  }

  @override
  Widget build(BuildContext context) {
    // FIXME ？
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Image(
        image: AssetImage('assets/images/splash.png'), fit: BoxFit.cover);
  }
}
