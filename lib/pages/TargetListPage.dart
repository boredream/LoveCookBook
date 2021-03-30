import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Target.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TargetListPage extends StatefulWidget {
  TargetListPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TargetListPage> {
  bool _hasLoadData = false;
  List<Target> _dataList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    DataHelper.loadData(DataHelper.COLLECTION_TARGET).then((value) {
      if (!this.mounted) return;
      if (value.code != null) {
        loadDataError(value.message);
        return;
      }

      setState(() {
        _hasLoadData = true;
        List<Target> dataList = (value.data as List)
            .map((e) => Target.fromJson(new Map<String, dynamic>.from(e)))
            .toList();
        dataList.sort((a, b) {
          // // 未完成的在前，已完成的在后
          //
          // if (aDate != null && bDate != null) {
          //   // 都有日期，按日期排
          //   return aDate.compareTo(bDate);
          // } else if (aDate == null && bDate == null) {
          //   // 都没日期，按名字排
          //   return a.name.compareTo(b.name);
          // } else {
          //   // 无日期的在前，有日期的在后
          //   return aDate != null ? 1 : -1;
          // }
          return a.name.compareTo(b.name);
        });
        _dataList = dataList;
      });
    }).catchError(loadDataError);
  }

  loadDataError(error) {
    Fluttertoast.showToast(msg: "加载失败 " + error.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('目标列表'),
      ),
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          MyRouteDelegate.of(context).push("target");
          // .then((value) {
            // if (value) refresh();
          // });
        },
      ),
    );
  }

  getBody() {
    if (_hasLoadData) {
      return getListView();
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  getListView() {
    return ListView.separated(
        itemBuilder: (context, index) => getRow(index),
        separatorBuilder: (context, _) => SizedBox(height: 8),
        itemCount: _dataList.length);
  }

  getRow(int index) {
    Target data = _dataList[index];
    return ListTile(
      title: Text(data.name),
      subtitle: Text("当前进度: ${data.totalProgress}%"),
      onTap: () =>  MyRouteDelegate.of(context).push("target", arguments: {"data": data})
              // .then((value) {
        // if (value) refresh();
      // }
    );
  }

  void refresh() {
    setState(() {
      _hasLoadData = false;
    });
    loadData();
  }
}
