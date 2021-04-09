import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/BaseCloudBean.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/main.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

abstract class BaseDetailEditPageState<T extends BaseCloudBean, S extends StatefulWidget> extends State<S> {

  T data;
  bool _isUpdate = false;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ProgressDialog _dialog;

  String getTitle();

  String getDataCollectionName();

  void initData();

  List<Widget> getFormWidgetList();

  @override
  void initState() {
    super.initState();
    _dialog = DialogUtils.getProgressDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      Map args = ModalRoute.of(context).settings.arguments as Map;
      if (args != null) {
        data = args["data"];
      }
      _isUpdate = data != null;

      initData();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text("${_isUpdate ? "编辑" : "新增"}${getTitle()}"),
      ),
      body: getBody(),
    );
  }

  getBody() {
    List<Widget> children = [];
    if (_isUpdate) {
      children
          .add(SizedBox(width: 140, height: 44, child: OutlinedButton(child: Text("删除"), onPressed: () => delete())));
    }
    children.add(SizedBox(
        width: 140,
        height: 44,
        child: ElevatedButton(child: Text(_isUpdate ? "修改" : "新增"), onPressed: () => update())));

    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(16),
          child: getForm(),
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  getForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getFormWidgetList(),
      ),
    );
  }

  delete() {
    DialogUtils.showDeleteConfirmDialog(context, () {
      _dialog.show();
      DataHelper.deleteData(getDataCollectionName(), data.id)
          .then((value) => requestSuccess("删除"))
          .catchError((error) => requestError(error));
    });
  }

  update() async {
    if (_formKey.currentState.validate()) {
      // 验证通过提交数据
      _formKey.currentState.save();
      _dialog.show();

      // 新增or更新
      if (_isUpdate) {
        DataHelper.setData(getDataCollectionName(), data.id, data)
            .then((value) => requestSuccess("修改"))
            .catchError((error) => requestError(error));
      } else {
        DataHelper.saveData(getDataCollectionName(), data)
            .then((value) => requestSuccess("新增"))
            .catchError((error) => requestError(error));
      }
    }
  }

  requestSuccess(String operation) {
    _dialog.hide();
    var msg = operation + "成功";
    Fluttertoast.showToast(msg: msg);
    // TODO
    // Provider.of<RefreshNotifier>(context, listen: false).needRefresh("targetList");
    // if ("修改" != operation) {
    //   MyRouteDelegate.of(context).remove("targetDetail");
    // }
    MyRouteDelegate.of(context).pop();
  }

  requestError(error) {
    _dialog.hide();
    var msg = "操作失败 " + error.toString();
    Fluttertoast.showToast(msg: msg);
  }
}
