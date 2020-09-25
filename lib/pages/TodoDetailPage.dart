import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Dish.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:image_picker/image_picker.dart';

class TodoDetailPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TodoDetailPage> {
  TextEditingController _editingController;
  Todo _todo;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _todo = ModalRoute.of(context).settings.arguments;
    if (_todo != null) {
      _editingController.text = _todo.name ?? "";
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
    int size = 1;
    if (_todo != null && _todo.images != null) {
      size += _todo.images.length;
    }

    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemCount: size,
        itemBuilder: (context, index) {
          if (index == size - 1) {
            return GestureDetector(
              child: Icon(Icons.add_a_photo),
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
    String imageUrl = _todo.images[index];
    Image.network(imageUrl);
  }

  Future selectImage() async {
    print("selectImage");

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _todo.images.add(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
