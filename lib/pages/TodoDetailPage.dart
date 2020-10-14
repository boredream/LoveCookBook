import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class TodoDetailPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TodoDetailPage> {
  Todo _todo;
  int _imageSize;
  ImagePicker _picker = ImagePicker();
  DataHelper _helper = DataHelper();
  TextEditingController _titleController;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // FIXME 如果 _todo关联setState会引起build，则不能在initState里直接调用，因为initState在build方法之前。
    // FIXME 获取参数又不能在build里调用，因为多次build会重新赋值arguments。加一个flag判断?

    _titleController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    if (_todo == null) {
      _todo = ModalRoute.of(context).settings.arguments ?? Todo();
      _titleController.text = _todo.name;
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
                selectData(1);
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
                selectData(2);
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
                  child: Text("删除任务"),
                  onPressed: () => deleteTodo(),
                ),
                FlatButton(
                  child: Text("确认修改"),
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
      if (dateType == 1) {
        _todo.todoDate = format;
      } else if (dateType == 2) {
        _todo.doneDate = format;
      }
    });
  }

  deleteTodo() {
    _helper.clearAll();
  }

  updateTodo() {
    if (_formKey.currentState.validate()) {
      // 验证通过提交数据
      _formKey.currentState.save();
      _helper.saveData(_todo);
      Navigator.pop(context, true);
    }
  }
}
