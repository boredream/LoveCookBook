import 'dart:io';

import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/ImageBean.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/helper/ImageHelper.dart';
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

    // FIXME 如果 _todo关联setState会引起build，则不能在initState里直接调用，因为initState在build方法之前。
    // FIXME 获取参数又不能在build里调用，因为多次build会重新赋值arguments。加一个flag判断?

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
          getGridImage(),
        ],
      ),
    );
  }

  GridView getGridImage() {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: getImageSize(),
        itemBuilder: (context, index) {
          if (index == _images.length) {
            return GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: Container(
                  color: Colors.grey,
                  child: Icon(
                    Icons.add_a_photo,
                    size: 48,
                  ),
                ),
              ),
              onTap: () {
                selectImage();
              },
            );
          } else {
            return getRow(index);
          }
        });
  }

  getRow(int index) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: _images[index].path != null
            ? Image.file(File(_images[index].path), fit: BoxFit.cover)
            : Image.network(_images[index].url, fit: BoxFit.cover)
    );
  }

  selectImage() async {
    // 选择图片
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );
    if (pickedFile == null) return;

    String sourcePath = pickedFile.path;
    setState(() {
      // 添加本地路径
      _images.add(ImageBean(path: sourcePath));
    });

//    // 创建临时文件
//    String filename = sourcePath.substring(sourcePath.lastIndexOf("/") + 1);
//    final dir = await path_provider.getTemporaryDirectory();
//    String targetPath = dir.path + "/" + filename;
//
//    // 压缩图片到临时文件
//    File file = await ImageHelper.compressAndGetFile(sourcePath, targetPath);
//
//    // 上传压缩后的图片文件
//    ImageHelper.uploadFile(file, (count, total) {
//      print("$count / $total");
//    }).then((value) {
//      print("upload = " + value.runtimeType.toString());
//      print("upload = " + value.data.fileId);
//    });

//    // 上传图片文件
//    String filename = sourcePath.substring(sourcePath.lastIndexOf("/") + 1);
//    String cloudPath = 'flutter/' + filename;
//    ImageHelper.uploadFile(sourcePath, cloudPath, (count, total) {
//      print("$count / $total");
//    }).then((value) {
//      print("upload = " + value.runtimeType.toString());
//      print("upload = " + value.data.fileId);
//    });
  }

  int getImageSize() {
    int size = _images.length + 1;
    if (size > 9) {
      size = 9;
    }
    return size;
  }

  selectData(int dateType) async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
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
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("您确定要删除吗?"),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.pop(context), // 关闭对话框
            ),
            FlatButton(
              child: Text("删除"),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.pop(context, true);
                _dialog.show();
                DataHelper.delete(_todo)
                    .then((value) => requestSuccess("删除"))
                    .catchError((error) => requestError(error));
              },
            ),
          ],
        );
      },
    );
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
            String sourcePath = _images[i].path;
            String filename = sourcePath.substring(
                sourcePath.lastIndexOf("/") + 1);
            String cloudPath = 'flutter/' + filename;

            CloudBaseStorageRes<UploadRes> res =
                await ImageHelper.uploadFile(sourcePath, cloudPath);
            // 上传成功，替换地址
            // field : cloud://lovecookbook-7gjn846l3db07924.6c6f-lovecookbook-7gjn846l3db07924-1253175673/flutter/image_picker_297004EB-44C4-4355-82AD-FFDA4553F8F4-28546-00000F1C08B97C8F.jpg
            // url: https://6c6f-lovecookbook-7gjn846l3db07924-1253175673.tcb.qcloud.la/flutter/image_picker_297004EB-44C4-4355-82AD-FFDA4553F8F4-28546-00000F1C08B97C8F.jpg
            _images[i].url = res.data.fileId.replaceFirst(
                "cloud://lovecookbook-7gjn846l3db07924.6c6f-lovecookbook-7gjn846l3db07924-1253175673",
                "https://6c6f-lovecookbook-7gjn846l3db07924-1253175673.tcb.qcloud.la");
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
        DataHelper.updateData(_todo)
            .then((value) => requestSuccess("修改"))
            .catchError((error) => requestError(error));
      } else {
        _todo.createDate = DateFormat("yyyy-MM-dd HH:mm:ss")
            .format(DateTime.now());
        DataHelper.saveData(_todo)
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
