import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/ImageBean.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/helper/ImageHelper.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:flutter_todo/views/AddGridImageList.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class TodoDetailPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TodoDetailPage> {
  static const DATE_TYPE_TODO = 1;
  static const DATE_TYPE_DONE = 2;

  Todo _todo;
  bool _isUpdate = false;
  List<ImageBean> _images = [];
  ImagePicker _picker = ImagePicker();
  TextEditingController _titleController;
  TextEditingController _descController;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ProgressDialog _dialog;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();
    _dialog = ProgressDialog(context);
    _dialog.style(message: "请等待...");
  }

  @override
  Widget build(BuildContext context) {
    if (_todo == null) {
      Map args = ModalRoute.of(context).settings.arguments as Map;
      _todo = args["todo"];
      if (_todo == null) {
        // 新增
        _todo = Todo();
      } else {
        // 修改
        _isUpdate = true;
        for (String url in _todo.images) {
          _images.add(ImageBean(url: url));
        }
      }
      _titleController.text = _todo.name;
      _descController.text = _todo.desc;

      _todo.type = args["type"];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("list 详情"),
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
            FlatButton(
              child: Text("删除"),
              onPressed: () => deleteTodo(),
            ),
            FlatButton(
              child: Text(_isUpdate ? "修改" : "新增"),
              onPressed: () => updateTodo(),
            ),
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
      autovalidate: true,
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
              _todo.name = newValue;
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
              _todo.desc = newValue;
            },
          ),
          SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "创建日期：",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                _todo.createDate ?? "",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "预计完成日期：",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  _todo.todoDate ?? "未填写",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            onTap: () {
              selectData(DATE_TYPE_TODO);
            },
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "实际完成日期：",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  _todo.doneDate ?? "未填写",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            onTap: () {
              selectData(DATE_TYPE_DONE);
            },
          ),
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
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if(date == null) return;
    var format = DateFormat("yyyy-MM-dd").format(date);
    setState(() {
      if (dateType == DATE_TYPE_TODO) {
        _todo.todoDate = format;
      } else if (dateType == DATE_TYPE_DONE) {
        _todo.doneDate = format;
      }
    });
  }

  deleteTodo() {
    DialogUtils.showDeleteConfirmDialog(context, () {
      _dialog.show();
      DataHelper.deleteData(DataHelper.COLLECTION_LIST, _todo.id)
          .then((value) => requestSuccess("删除"))
          .catchError((error) => requestError(error));
    });
  }

  updateTodo() async {
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
            print("image upload success = " + _images[i].url);
          }
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "图片上传失败");
        return;
      }

      // 图片设置到bean上
      _todo.images.clear();
      for (int i = 0; i < _images.length; i++) {
        _todo.images.add(_images[i].url);
      }

      // 新增or更新
      if (_isUpdate) {
        DataHelper.setData(DataHelper.COLLECTION_LIST, _todo.id, _todo)
            .then((value) => requestSuccess("修改"))
            .catchError((error) => requestError(error));
      } else {
        _todo.createDate = DateFormat("yyyy-MM-dd HH:mm:ss")
            .format(DateTime.now());
        DataHelper.saveData(DataHelper.COLLECTION_LIST, _todo)
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
}
