import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/ImageBean.dart';
import 'package:flutter_todo/entity/Menu.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/helper/ImageHelper.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:flutter_todo/views/AddGridImageList.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MenuDetailPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<MenuDetailPage> {
  Menu _menu;
  bool _isUpdate = false;
  List<ImageBean> _images = [];
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
    if (_menu == null) {
      Map args = ModalRoute.of(context).settings.arguments as Map;
      _menu = args["menu"];
      if (_menu == null) {
        // 新增
        _menu = Menu();
      } else {
        // 修改
        _isUpdate = true;
        for (String url in _menu.images) {
          _images.add(ImageBean(url: url));
        }
      }
      _titleController.text = _menu.name;
      _menu.type = args["type"];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("菜品详情"),
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
              _menu.name = newValue;
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
                  "首次尝试日期：",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  _menu.createDate ?? "未填写",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            onTap: () {
              selectData();
            },
          ),
          SizedBox(
            height: 8,
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

  selectData() async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date == null) return;
    var format = DateFormat("yyyy-MM-dd").format(date);
    setState(() {
      _menu.createDate = format;
    });
  }

  delete() {
    DialogUtils.showDeleteConfirmDialog(context, () {
      _dialog.show();
      DataHelper.deleteData(DataHelper.COLLECTION_MENU, _menu.id)
          .then((value) => requestSuccess("删除"))
          .catchError((error) => requestError(error));
    });
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
            print("image upload success = " + _images[i].url);
          }
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "图片上传失败");
        return;
      }

      // 图片设置到bean上
      _menu.images.clear();
      for (int i = 0; i < _images.length; i++) {
        _menu.images.add(_images[i].url);
      }

      // 新增or更新
      if (_isUpdate) {
        DataHelper.setData(DataHelper.COLLECTION_MENU, _menu.id, _menu)
            .then((value) => requestSuccess("修改"))
            .catchError((error) => requestError(error));
      } else {
        DataHelper.saveData(DataHelper.COLLECTION_MENU, _menu)
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
