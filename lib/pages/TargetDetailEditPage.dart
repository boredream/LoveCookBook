import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Target.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/main.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class TargetDetailEditPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TargetDetailEditPage> {
  Target _data;
  bool _isUpdate = false;
  TextEditingController _titleController;
  TextEditingController _descController;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ProgressDialog _dialog;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();
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
      } else {
        // 修改
        _isUpdate = true;
      }

      _titleController.text = _data.name;
      _descController.text = _data.desc;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text("${_isUpdate ? "编辑" : "新增"}目标详情"),
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
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: "标题",
            ),
            validator: (value) {
              return value.trim().length > 0 ? null : "标题不能为空";
            },
            onSaved: (newValue) {
              _data.name = newValue;
            },
          ),
          TextFormField(
            controller: _descController,
            keyboardType: TextInputType.multiline,
            textAlignVertical: TextAlignVertical.top,
            minLines: 1,
            maxLines: 10,
            decoration: InputDecoration(
              labelText: "描述",
            ),
            onSaved: (newValue) {
              _data.desc = newValue;
            },
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "默认新增进度：${_data.defaultAddProgress ?? 2}%",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Slider(
            value: (_data.defaultAddProgress ?? 2).toDouble(),
            min: 0,
            max: 100,
            divisions: 100,
            label: (_data.defaultAddProgress ?? 2).toDouble().round().toString(),
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Theme.of(context).primaryColorLight,
            onChanged: (double value) {
              setState(() {
                _data.defaultAddProgress = value.round();
              });
            },
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "奖励",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(
                  width: 72, height: 36, child: ElevatedButton(child: Text("新增"), onPressed: () => showEditDialog(-1))),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          getListView(),
        ],
      ),
    );
  }

  getListView() {
    if (_data.rewardList != null) {
      _data.rewardList.sort((a, b) {
        int aProgress = int.parse(Target.getRewardProgress(a));
        int bProgress = int.parse(Target.getRewardProgress(b));
        return aProgress.compareTo(bProgress);
      });
    }
    return ListView.separated(
        itemBuilder: (context, index) => getRow(index),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, _) => SizedBox(height: 8),
        itemCount: _data == null || _data.rewardList == null ? 0 : _data.rewardList.length);
  }

  getRow(int index) {
    String reward = _data.rewardList[index];
    String name = Target.getRewardName(reward);
    String progress = Target.getRewardProgress(reward);
    String done = _data.getTotalProgress() >= int.parse(progress) ? "已完成" : "未完成";
    Color color = _data.getTotalProgress() >= int.parse(progress) ? Theme.of(context).primaryColor : Colors.black87;
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Row(
            children: [
              Expanded(child: Text("[$progress%] $name", style: TextStyle().copyWith(color: color))),
              Text(done, style: TextStyle().copyWith(color: color)),
            ],
          )),
      onTap: () => showEditDialog(index),
      onLongPress: () => showDeleteDialog(index),
    );
  }

  delete() {
    DialogUtils.showDeleteConfirmDialog(context, () {
      _dialog.show();
      DataHelper.deleteData(DataHelper.COLLECTION_TARGET, _data.id)
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
    Provider.of<RefreshNotifier>(context, listen: false).needRefresh("targetList");
    if ("修改" != operation) {
      MyRouteDelegate.of(context).remove("targetDetail");
    }
    MyRouteDelegate.of(context).pop();
  }

  requestError(error) {
    _dialog.hide();
    var msg = "操作失败 " + error.toString();
    Fluttertoast.showToast(msg: msg);
  }

  void showDeleteDialog(int rewardIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text('提示'),
            content: Text('是否确认删除？'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _data.rewardList.removeAt(rewardIndex);
                  });
                  Navigator.pop(context);
                },
                child: Text('删除'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showEditDialog(int rewardIndex) {
    String reward;
    if (rewardIndex != -1) {
      reward = _data.rewardList[rewardIndex];
    }
    showDialog<bool>(
      context: context,
      builder: (context) {
        return EditDialog(
            reward: reward,
            onCall: (name, progress) {
              // 新增或修改
              String newReward = name + "::" + progress;
              setState(() {
                if (rewardIndex == -1) {
                  if (_data.rewardList == null) {
                    _data.rewardList = [];
                  }
                  _data.rewardList.add(newReward);
                } else {
                  _data.rewardList[rewardIndex] = newReward;
                }
              });
            });
      },
    );
  }
}

class EditDialog extends StatefulWidget {
  final String reward;
  final Function onCall;

  EditDialog({Key key, this.reward, this.onCall}) : super(key: key);

  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<EditDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _progressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _progressController.text = "100";
    String name = Target.getRewardName(widget.reward);
    String progress = Target.getRewardProgress(widget.reward);
    if (name != null) _nameController.text = name;
    if (progress != null) _progressController.text = progress;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "奖励内容",
              ),
              validator: (value) {
                return value.trim().length > 0 ? null : "不能为空";
              },
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _progressController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "奖励目标进度",
              ),
              validator: (value) {
                return value.trim().length > 0 ? null : "不能为空";
              },
            ),
            SizedBox(
              height: 8,
            ),
          ]),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("取消"),
          onPressed: () => Navigator.pop(context), // 关闭对话框
        ),
        TextButton(
          child: Text("确定"),
          onPressed: () {
            updateData();
          },
        ),
      ],
    );
  }

  updateData() async {
    if (_formKey.currentState.validate()) {
      // 验证通过提交数据
      _formKey.currentState.save();

      widget.onCall.call(_nameController.text, _progressController.text);
      Navigator.pop(context);
    }
  }
}
