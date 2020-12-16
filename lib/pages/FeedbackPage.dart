
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/entity/AppFeedback.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/helper/UserHelper.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<FeedbackPage> {
  TextEditingController _contactController;
  TextEditingController _textController;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ProgressDialog _dialog;

  @override
  void initState() {
    super.initState();
    _contactController = TextEditingController();
    _textController = TextEditingController();
    _dialog = DialogUtils.getProgressDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("意见反馈"),
      ),
      body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 16),
              Text("您可以反馈在应用过程中遇到的问题，或者对功能的需求建议",
                  style: TextStyle(fontSize: 14)),
              SizedBox(height: 16),
              getForm(),
              SizedBox(height: 64),
              SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: RaisedButton(
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      child: Text("提交"),
                      onPressed: () => commit())),
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
            controller: _contactController,
            decoration: InputDecoration(
              labelText: "请输入您的联系方式(QQ/手机)",
            ),
          ),
          TextFormField(
            controller: _textController,
            minLines: 6,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: "请输入反馈内容",
            ),
            validator: (value) {
              return value.trim().length > 0 ? null : "不能为空";
            },
          ),
        ],
      ),
    );
  }

  commit() {
    if (!_formKey.currentState.validate()) return;
    // 验证通过提交数据
    _formKey.currentState.save();
    _dialog.show();

    AppFeedback info = AppFeedback();
    info.feedback = _textController.text;
    info.contact = _contactController.text;
    if (UserHelper.curUser != null) {
      info.name = UserHelper.curUser.username;
    }
    DataHelper.saveData(DataHelper.COLLECTION_FEEDBACK, info)
        .then((value) => requestSuccess(value))
        .catchError((error) => requestError(error));
  }

  requestSuccess(var value) {
    _dialog.hide();
    Fluttertoast.showToast(msg: "提交成功，感谢您的反馈！");
    Navigator.pop(context);
  }

  requestError(var e) {
    _dialog.hide();
    var msg = e.toString();
    Fluttertoast.showToast(msg: msg);
  }
}
