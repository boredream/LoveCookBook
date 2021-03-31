import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/entity/Target.dart';
import 'package:flutter_todo/entity/TargetItem.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/main.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class TargetDetailPage extends StatefulWidget {
  TargetDetailPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TargetDetailPage> {
  Target _data;
  bool _isUpdate = false;
  TextEditingController _titleController;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ProgressDialog _dialog;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _dialog = DialogUtils.getProgressDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_data == null) {
      Map args = ModalRoute.of(context).settings.arguments as Map;
      if (args != null) {
        _data = args["data"];
      }
      if (_data == null) {
        // 新增
        _data = Target();
        _data.items = [];
      } else {
        // 修改
        _isUpdate = true;
      }

      _titleController.text = _data.name;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("目标详情"),
        actions: [
          Center(child: _buildCommitBtn()),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _isUpdate
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => toEditPage(null),
            )
          : null,
    );
  }

  _buildCommitBtn() {
    return TextButton(
      child:
          Text(_isUpdate ? "修改" : "新增", style: TextStyle(color: Colors.white)),
      onPressed: () => updateData(),
    );
  }

  _buildBody() {
    return Column(
      children: [
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "目标名称",
                  ),
                  validator: (value) {
                    return value.trim().length > 0 ? null : "不能为空";
                  },
                  onSaved: (newValue) {
                    setState(() {
                      _data.name = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(child: getListView()),
      ],
    );
  }

  getListView() {
    return ListView.separated(
        itemBuilder: (context, index) => getRow(index),
        separatorBuilder: (context, _) => SizedBox(height: 8),
        itemCount: _data.items.length);
  }

  getRow(int index) {
    TargetItem data = _data.items[index];
    return ListTile(
      title: Text(data.title),
      subtitle: Row(
        children: [
          Expanded(child: Text(data.date)),
          Expanded(child: Text("进度：${data.progress}")),
        ],
      ),
      onTap: () {
        toEditPage(data);
      },
    );
  }

  updateData() async {
    if (_formKey.currentState.validate()) {
      // 验证通过提交数据
      _formKey.currentState.save();

      _dialog.show();
      if (_isUpdate) {
        DataHelper.setData(DataHelper.COLLECTION_TARGET, _data.id, _data)
            .then((value) => requestSuccess("修改"))
            .catchError((error) => requestError(error));
      } else {
        DataHelper.saveData(DataHelper.COLLECTION_TARGET, _data)
            .then((value) => requestSuccess("新增"))
            .catchError((error) => requestError(error));
      }
    }
  }

  requestSuccess(String operation) {
    _dialog.hide();
    var msg = operation + "成功";
    Fluttertoast.showToast(msg: msg);
    Navigator.pop(context, true);
  }

  requestError(error) {
    _dialog.hide();
    var msg = "操作失败 " + error.toString();
    Fluttertoast.showToast(msg: msg);
  }

  void toEditPage(TargetItem data) {
    MyRouteDelegate.of(context).push("targetItem",
        arguments: {"target": _data, "data": data});
  }
}
