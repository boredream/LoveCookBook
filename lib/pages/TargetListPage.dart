import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Target.dart';
import 'package:flutter_todo/entity/TargetItem.dart';
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
    DataHelper.loadData(DataHelper.COLLECTION_TARGET, orderGrow: true)
        .then((value) {
      if (!this.mounted) return;
      if (value.code != null) {
        loadDataError(value.message);
        return;
      }

      setState(() {
        _hasLoadData = true;
        List<Target> dataList = (value.data as List).map((e) {
          // FIXME 成员变量是 list object 的 无法直接转？
          List<TargetItem> items = (e['items'] as List)
              .map((e) => TargetItem.fromJson(new Map<String, dynamic>.from(e)))
              .toList();
          e['items'] = null;
          if(items != null) {
            items.sort((a, b) {
              // 时间倒序
              String aDate = a.date ?? "2100-01-01";
              String bDate = b.date ?? "2100-01-01";
              return bDate.compareTo(aDate);
            });
          }

          Map<String, dynamic> map = new Map<String, dynamic>.from(e);
          Target target = Target.fromJson(map);
          target.items = items;
          return target;
        }).toList();
        dataList.sort((a, b) {
          // 按照最近更新日期倒序
          String aDate;
          String bDate;
          if (a.items != null && a.items.length > 0) {
            aDate = a.items[0].date;
          }
          if (b.items != null && b.items.length > 0) {
            bDate = b.items[0].date;
          }
          if(aDate == null) {
            aDate = "2100-01-01";
          }
          if(bDate == null) {
            bDate = "2100-01-01";
          }
          return bDate.compareTo(aDate);
        });
        _dataList = dataList;
      });
    }).catchError(loadDataError);
  }

  loadDataError(error) {
    print(error);
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
          MyRouteDelegate.of(context).push("targetDetail");
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
        subtitle: Text("当前进度: ${data.getTotalProgress()}%"),
        onTap: () => MyRouteDelegate.of(context)
            .push("targetDetail", arguments: {"data": data}));
  }

  void refresh() {
    setState(() {
      _hasLoadData = false;
    });
    loadData();
  }
}
