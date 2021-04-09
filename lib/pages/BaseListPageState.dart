import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class BaseListPageState<T, S extends StatefulWidget> extends State<S> {
  bool _hasLoadData = false;
  List<T> dataList = [];
  RefreshController _refreshController;

  String getTitle();

  Future<DbQueryResponse> getLoadDataFuture();

  void toEditPage(T data);

  List<T> setLoadDataResponse(dynamic data);

  Widget getRow(int index);

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    loadData();
  }

  void loadData() {
    getLoadDataFuture().then((value) {
      if (!this.mounted) return;
      if (value.code != null) {
        loadDataError(value.message);
        return;
      }

      setState(() {
        _hasLoadData = true;
        dataList = setLoadDataResponse(value.data);
      });
      _refreshController.refreshCompleted();
    }).catchError(loadDataError);
  }

  loadDataError(error) {
    _refreshController.refreshCompleted();
    Fluttertoast.showToast(msg: "加载失败 " + error.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle()),
      ),
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => toEditPage(null),
      ),
    );
  }

  getBody() {
    String routeName = ModalRoute.of(context).settings.name;
    RefreshNotifier notifier = Provider.of<RefreshNotifier>(context);
    if (notifier.refreshList.contains(routeName)) {
      _hasLoadData = false;
      loadData();
      notifier.refreshList.remove(routeName);
    }

    if (_hasLoadData) {
      return getListView();
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  getListView() {
    return SmartRefresher(
      enablePullDown: true,
      controller: _refreshController,
      onRefresh: loadData,
      child: ListView.separated(
          itemBuilder: (context, index) => getRow(index),
          separatorBuilder: (context, _) => Divider(height: 1),
          itemCount: dataList.length),
    );
  }

  void refresh() {
    setState(() {
      _hasLoadData = false;
    });
    loadData();
  }
}
