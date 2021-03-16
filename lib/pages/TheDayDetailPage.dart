import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/ImageBean.dart';
import 'package:flutter_todo/entity/TheDay.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/helper/ImageHelper.dart';
import 'package:flutter_todo/helper/NotificationHelper.dart';
import 'package:flutter_todo/utils/DateStrUtils.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:flutter_todo/views/AddGridImageList.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class TheDayDetailPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TheDayDetailPage> {
  static const DATE_TYPE_THE_DAY = 1;
  static const DATE_TYPE_NOTIFY = 2;

  TheDay _theDay;
  bool _isUpdate = false;
  List<ImageBean> _images = [];
  TextEditingController _titleController;
  TextEditingController _descController;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ProgressDialog _dialog;

  List<String> _remindPeriods = ["从不", "仅一次", "每年"];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();
    _dialog = DialogUtils.getProgressDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_theDay == null) {
      Map args = ModalRoute.of(context).settings.arguments as Map;
      _theDay = args["theDay"];
      if (_theDay == null) {
        // 新增
        _theDay = TheDay();
        _theDay.theDayDate = DateFormat("yyyy-MM-dd").format(args["date"]);
      } else {
        // 修改
        _isUpdate = true;
        if (_theDay.images == null) {
          _theDay.images = [];
        }
        for (String url in _theDay.images) {
          _images.add(ImageBean(url: url));
        }
      }
      if (_theDay.remindPeriod == null) {
        _theDay.remindPeriod = _remindPeriods[0];
      }

      _titleController.text = _theDay.name;
      _descController.text = _theDay.desc;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text("纪念日"),
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
            SizedBox(
                width: 140,
                height: 44,
                child: OutlineButton(
                    color: Theme.of(context).primaryColor,
                    highlightedBorderColor: Colors.transparent,
                    child: Text("删除"),
                    onPressed: () => delete())),
            SizedBox(
                width: 140,
                height: 44,
                child: RaisedButton(
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text(_isUpdate ? "修改" : "新增"),
                    onPressed: () => update())),
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
              _theDay.name = newValue;
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
              _theDay.desc = newValue;
            },
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "纪念日时间：",
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
                Text(
                  _theDay.theDayDate ?? "[点我修改]",
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                ),
              ],
            ),
            onTap: () {
              selectData(DATE_TYPE_THE_DAY);
            },
          ),
          getRemindPeriods(),
          getRemindDate(),
          SizedBox(
            height: 16,
          ),
          AddGridImageList(_images, selectImage, (image) {
            setState(() {
              _images.remove(image);
            });
          }),
        ],
      ),
    );
  }

  selectImage() {
    DialogUtils.showImagePickDialog(context, (path) {
      setState(() {
        // 添加本地路径
        _images.add(ImageBean(path: path));
      });
    });
  }

  selectData(int dateType) async {
    DateTime initialDate = DateTime.now();
    TimeOfDay initialTime = TimeOfDay(hour: 10, minute: 0);
    if (dateType == DATE_TYPE_THE_DAY) {
      if (_theDay.theDayDate != null) {
        initialDate = DateTime.parse(_theDay.theDayDate);
        initialTime =
            TimeOfDay(hour: initialDate.hour, minute: initialDate.minute);
      }
    } else if (dateType == DATE_TYPE_NOTIFY) {
      if (_theDay.notifyDate != null) {
        initialDate = DateTime.parse(_theDay.notifyDate);
        initialTime =
            TimeOfDay(hour: initialDate.hour, minute: initialDate.minute);
      }
    }

    var format = await DateStrUtils.showCustomDateTimePicker(context,
        initialDate: initialDate, initialTime: initialTime);
    setState(() {
      if (dateType == DATE_TYPE_THE_DAY) {
        _theDay.theDayDate = format;
      } else if (dateType == DATE_TYPE_NOTIFY) {
        _theDay.notifyDate = format;
      }
    });
  }

  delete() {
    DialogUtils.showDeleteConfirmDialog(context, () {
      _dialog.show();
      DataHelper.deleteData(DataHelper.COLLECTION_THE_DAY, _theDay.id)
          .then((value) => requestSuccess("删除"))
          .catchError((error) => requestError(error));
    });
  }

  getRemindPeriods() {
    List<Widget> list = List<Widget>();
    list.add(Text("提醒：", style: Theme.of(context).primaryTextTheme.subtitle1));
    for (String type in _remindPeriods) {
      list.add(GestureDetector(
          onTap: () {
            setState(() {
              _theDay.remindPeriod = type;
            });
          },
          child: Row(
            children: [
              Radio(
                value: type,
                groupValue: _theDay.remindPeriod,
                onChanged: (value) {
                  setState(() {
                    _theDay.remindPeriod = type;
                  });
                },
              ),
              Text(type),
            ],
          )));
    }
    return Row(children: list);
  }

  getRemindDate() {
    if (_theDay.remindPeriod != "仅一次") {
      return Row();
    }
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "提醒时间：",
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
          Text(
            _theDay.notifyDate ?? "[点我修改]",
            style: Theme.of(context).primaryTextTheme.bodyText1,
          ),
        ],
      ),
      onTap: () {
        selectData(DATE_TYPE_NOTIFY);
      },
    );
  }

  update() async {
    if (_formKey.currentState.validate()) {
      // 验证通过提交数据
      _formKey.currentState.save();
      _dialog.show();

      // 校验图片，上传未上传的
      try {
        for (int i = 0; i < _images.length; i++) {
          if (_images[i].url == null) {
            // 本地图片，上传之
            _images[i].url = await ImageHelper.uploadImage(_images[i].path);
            debugPrint("image upload success = " + _images[i].url);
          }
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "图片上传失败");
        return;
      }

      // 图片设置到bean上
      _theDay.images.clear();
      for (int i = 0; i < _images.length; i++) {
        _theDay.images.add(_images[i].url);
      }

      // 新增or更新
      if (_isUpdate) {
        DataHelper.setData(DataHelper.COLLECTION_THE_DAY, _theDay.id, _theDay)
            .then((value) => requestSuccess("修改"))
            .catchError((error) => requestError(error));
      } else {
        DataHelper.saveData(DataHelper.COLLECTION_THE_DAY, _theDay)
            .then((value) => requestSuccess("新增"))
            .catchError((error) => requestError(error));
      }
    }
  }

  requestSuccess(String operation) {
    if (_theDay.remindPeriod == "仅一次" && _theDay.notifyDate != null) {
      DateTime notifyDate = DateStrUtils.str2dateAndTime(_theDay.notifyDate);
      NotificationHelper.showNotificationAtTime(
          "theDay", _theDay.name, _theDay.desc ?? "", notifyDate,
          payload: "theDay:::" + json.encode(_theDay));
      return;
    }

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
}
