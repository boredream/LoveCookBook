import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class TodoDetailPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TodoDetailPage> {
  static const DATE_TYPE_TODO = 1;
  static const DATE_TYPE_DONE = 2;

  Todo _todo;
  bool _isUpdate = false;
  int _imageSize;
  ImagePicker _picker = ImagePicker();
  DataHelper _helper = DataHelper();
  TextEditingController _titleController;
  TextEditingController _descController;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // FIXME 如果 _todo关联setState会引起build，则不能在initState里直接调用，因为initState在build方法之前。
    // FIXME 获取参数又不能在build里调用，因为多次build会重新赋值arguments。加一个flag判断?

    _titleController = TextEditingController();
    _descController = TextEditingController();
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
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
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
            Expanded(
              child: getGridImage(),
            ),
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
        ),
      ),
    );
  }

  Widget getGridImage() {
    getImageSize();
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: _imageSize,
        itemBuilder: (context, index) {
          if (index == _todo.images.length) {
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
      child: Image.file(File(_todo.images[index]), fit: BoxFit.cover),
    );
  }

  Future selectImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _todo.images.add(pickedFile.path);
        _imageSize = _todo.images.length + 1;
      }
    });
  }

  void getImageSize() {
    _imageSize = _todo.images.length + 1;
    if (_imageSize > 9) {
      _imageSize = 9;
    }
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
                _helper
                    .delete(_todo)
                    .then((value) => requestSuccess("删除"))
                    .catchError((error) => requestError(error));
              },
            ),
          ],
        );
      },
    );
  }

  updateTodo() {
    if (_formKey.currentState.validate()) {
      // 验证通过提交数据
      _formKey.currentState.save();

      if (_isUpdate) {
        _helper.updateData(_todo).then((value) {
          print(value);
          requestSuccess("修改");
        }).catchError((error) => requestError(error));
      } else {
        _helper.saveData(_todo).then((value) {
          print(value);
          requestSuccess("新增");
        }).catchError((error) => requestError(error));
      }
    }
  }

  requestSuccess(String operation) {
    var msg = operation + "成功";
    Fluttertoast.showToast(msg: msg);
    Navigator.pop(context, true);
  }

  requestError(error) {
    var msg = "操作失败 " + error.toString();
    Fluttertoast.showToast(msg: msg);
    print(msg);
  }
}
