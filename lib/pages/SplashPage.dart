
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';

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

  void autoLogin() {
    int startTime = DateTime.now().millisecond;

    CloudBaseCore core = CloudBaseHelper.init();
    CloudBaseAuth auth = CloudBaseAuth(core);
    Function nextStep = () {
      Navigator.pop(context);
      if(auth == null) {
        print("not login");
        Navigator.pushNamed(context, "login");
      } else {
        print("login success");
        Navigator.pushNamed(context, "main");
      }
    };

    int dur = DateTime.now().millisecond - startTime;
    if(dur < 2 * 1000) {
      dur = 2000;
    }
    Future.delayed(Duration(milliseconds: dur), nextStep);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Image(image: AssetImage('assets/images/splash.png'), fit: BoxFit.cover);
  }
}
