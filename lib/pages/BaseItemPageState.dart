import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/BaseItemBean.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/main.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

abstract class BaseItemPageState<T extends BaseItemBean<I>, I, S extends StatefulWidget> extends State<S> {

  T data;
  I item;
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
    if (item == null) {
      Map args = ModalRoute.of(context).settings.arguments as Map;
      if (args != null) {
        data = args["data"];
        item = args["item"];
      }
      _isUpdate = item != null;
      initData();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle()),
      ),
      body: getBody(),
    );
  }

  getBody() {
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
          children: [
            SizedBox(width: 140, height: 44, child: OutlinedButton(child: Text("删除"), onPressed: () => delete())),
            SizedBox(
                width: 140,
                height: 44,
                child: ElevatedButton(child: Text(_isUpdate ? "修改" : "新增"), onPressed: () => update())),
          ],
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
      data.getItems().remove(item);
      DataHelper.setData(getDataCollectionName(), data.id, data)
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
        data.getItems().add(item);
        data.getItems().sort();
        DataHelper.setData(getDataCollectionName(), data.id, data)
            .then((value) => requestSuccess("新增"))
            .catchError((error) => requestError(error));
      }
    }
  }

  requestSuccess(String operation) {
    _dialog.hide();
    var msg = operation + "成功";
    Fluttertoast.showToast(msg: msg);
    // FIXME
    // Provider.of<RefreshNotifier>(context, listen: false).needRefresh("targetList");
    MyRouteDelegate.of(context).pop();
  }

  requestError(error) {
    _dialog.hide();
    var msg = "操作失败 " + error.toString();
    Fluttertoast.showToast(msg: msg);
  }
}
