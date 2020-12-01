
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/helper/UserHelper.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

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

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _dialog = ProgressDialog(context);
    _dialog.style(message: "请等待...");
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
              SizedBox(height: 16),
              getForm(),
              SizedBox(height: 92),
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
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: "用户名",
            ),
            validator: (value) {
              return value.trim().length > 0 ? null : "不能为空";
            },
            onSaved: (newValue) {
              // TODO
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: "密码",
            ),
            validator: (value) {
              return value.trim().length > 0 ? null : "不能为空";
            },
          ),
          SizedBox(
            height: 16,
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

  register() {
    if (!_formKey.currentState.validate()) return;
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
  }

  loginSuccess() {
    _dialog.hide();
    Navigator.pop(context);
    Navigator.pushNamed(context, "main");
    Fluttertoast.showToast(msg: "登录成功");
  }

  requestError(var e) {
    _dialog.hide();
    var msg = e.toString();
    Fluttertoast.showToast(msg: msg);
  }
}
