import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:image_picker/image_picker.dart';

class TodoDetailPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TodoDetailPage> {
  TextEditingController _editingController;
  Todo _todo;
  int _imageSize;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // FIXME 如果 _todo关联setState会引起build，则不能在initState里直接调用，因为initState在build方法之前。
    // FIXME 获取参数又不能在build里调用，因为多次build会重新赋值arguments。加一个flag判断?

    _editingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    if (_todo == null) {
      _todo = ModalRoute.of(context).settings.arguments ?? Todo();
      _editingController.text = _todo.name;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _editingController,
              decoration: InputDecoration(
                labelText: "标题",
              ),
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
              minLines: 1,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: "描述",
              ),
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
                    date2str(_todo.todoDate),
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
            GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "实际完成日期：",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    date2str(_todo.doneDate),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
              onTap: () {
                selectData();
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
                  child: Text("完成任务"),
                  onPressed: () {},
                ),
                FlatButton(
                  child: Text("删除任务"),
                  onPressed: () {},
                ),
                FlatButton(
                  child: Text("确认修改"),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ));
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
    if (index < _todo.images.length) {
      String imageUrl = _todo.images[index];
      print("get row " + index.toString() + " = " + imageUrl);
    }

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: Image.file(File(_todo.images[index]), fit: BoxFit.cover),
    );
  }

  Future selectImage() async {
    print("selectImage");

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _todo.images.add(pickedFile.path);
        _imageSize = _todo.images.length + 1;
      } else {
        print('No image selected.');
      }
    });
  }

  void getImageSize() {
    _imageSize = _todo.images.length + 1;
    if (_imageSize > 9) {
      _imageSize = 9;
    }
  }

  void selectData() async {
    var result = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    print('$result');
  }

  String date2str(String date) {
    return date ?? "未填写";
  }
}
