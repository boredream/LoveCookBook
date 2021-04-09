import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/entity/BaseItemBean.dart';

abstract class BaseDetailPageState<T extends BaseItemBean<I>, I, S extends StatefulWidget> extends State<S> {

  T data;

  String getTitle();

  void toEditPage();

  void toEditItemPage(I item);

  Widget buildInfoCard();

  Widget buildRow(int index);

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      Map args = ModalRoute.of(context).settings.arguments as Map;
      data = args["data"];
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(getTitle()),
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
                  border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: EdgeInsets.all(8),
              child: buildInfoCard()),
          onTap: () => toEditPage(),
        ),
        Expanded(child: getListView()),
      ],
    );
  }

  getListView() {
    return ListView.separated(
        itemBuilder: (context, index) => buildRow(index),
        separatorBuilder: (context, _) => SizedBox(height: 8),
        itemCount: data == null ? 0 : data.getItems().length);
  }
}
