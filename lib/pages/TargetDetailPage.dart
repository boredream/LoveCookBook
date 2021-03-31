import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/entity/Target.dart';
import 'package:flutter_todo/entity/TargetItem.dart';
import 'package:flutter_todo/main.dart';

class TargetDetailPage extends StatefulWidget {
  TargetDetailPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TargetDetailPage> {
  Target _data;

  @override
  Widget build(BuildContext context) {
    if (_data == null) {
      Map args = ModalRoute.of(context).settings.arguments as Map;
      _data = args["data"];
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("目标详情"),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => toEditItemPage(null),
      ),
    );
  }

  _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(),
                  Text("目标名称：${_data.name}"),
                  Text("目标进度：${_data.getTotalProgress()}%"),
                ],
              )),
          onTap: () => toEditPage(),
        ),
        Expanded(child: getListView()),
      ],
    );
  }

  getListView() {
    return ListView.separated(
        itemBuilder: (context, index) => getRow(index),
        separatorBuilder: (context, _) => SizedBox(height: 8),
        itemCount: _data == null ? 0 : _data.items.length);
  }

  getRow(int index) {
    TargetItem data = _data.items[index];
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Expanded(child: Text("[${data.date}] ${data.title}")),
              Text("+ ${data.progress}%"),
            ],
          )),
      onTap: () => toEditItemPage(data),
    );
  }

  void toEditPage() {
    MyRouteDelegate.of(context)
        .push("targetDetailEdit", arguments: {"data": _data});
  }

  void toEditItemPage(TargetItem data) {
    MyRouteDelegate.of(context)
        .push("targetItem", arguments: {"target": _data, "data": data});
  }
}
