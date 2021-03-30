import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo/helper/UserHelper.dart';
import 'package:flutter_todo/main.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<LoginPage> {
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ProgressDialog _dialog;
  SharedPreferences _sp;
  int _registerTime;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _dialog = DialogUtils.getProgressDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              SizedBox(height: 8),
              getForm(),
              SizedBox(height: 64),
              SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: RaisedButton(
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      child: Text("登录"),
                      onPressed: () => login())),
              SizedBox(height: 16),
              SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlineButton(
                      color: Theme.of(context).primaryColor,
                      highlightedBorderColor: Colors.transparent,
                      child: Text("注册"),
                      onPressed: () => register())),
              SizedBox(height: 16),
              Text("首次使用，直接输入用户信息和密码，点击注册即可", style: TextStyle(fontSize: 12)),
            ],
          )),
    );
  }

  getForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("可以两个人使用同一账户登录，共享信息", style: TextStyle(fontSize: 14)),
          TextFormField(
            maxLength: 20,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[a-z,A-Z,0-9]")),
              //限制只允许输入字母和数字
            ],
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: "用户名",
            ),
            validator: (value) {
              return value.trim().length > 0 ? null : "不能为空";
            },
          ),
          SizedBox(height: 8),
          TextFormField(
            maxLength: 20,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[a-z,A-Z,0-9]")),
              //限制只允许输入字母和数字
            ],
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: "密码",
            ),
            validator: (value) {
              if (value.trim().length >= 6 && value.trim().length <= 20) {
                return null;
              }
              return "密码必须是6~20位的字母和数字组合";
            },
          ),
        ],
      ),
    );
  }

  login() async {
    if (!_formKey.currentState.validate()) return;
    // 验证通过提交数据
    _formKey.currentState.save();
    _dialog.show();
    UserHelper.login(_usernameController.text, _passwordController.text)
        .then((value) => loginSuccess())
        .catchError((error) => requestError(error));
  }

  register() async {
    if (!_formKey.currentState.validate()) return;
    if (_sp == null) {
      _sp = await SharedPreferences.getInstance();
    }
    _registerTime = _sp.getInt("registerTime") ?? 0;
    if (_registerTime > 3) {
      Fluttertoast.showToast(msg: "为了防止恶意注册，同一台设备被限制只能注册三个账户");
      return;
    }

    DialogUtils.showConfirmDialog(context, "确定以当前输入的用户名和密码注册？", "注册", () {
      // 验证通过提交数据
      _formKey.currentState.save();
      _dialog.show();
      UserHelper.register(_usernameController.text, _passwordController.text)
          .then((value) => registerSuccess(value))
          .catchError((error) => requestError(error));
    });
  }

  registerSuccess(var value) {
    _dialog.hide();
    Fluttertoast.showToast(msg: "注册成功，请继续登录");
    _sp.setInt("registerTime", _registerTime + 1);
  }

  loginSuccess() {
    _dialog.hide();
    Navigator.pop(context);
    MyRouteDelegate.of(context).push("main");
    Fluttertoast.showToast(msg: "登录成功");
  }

  requestError(var e) {
    _dialog.hide();
    var msg = e.toString();
    Fluttertoast.showToast(msg: msg);
  }
}
