import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/helper/GlobalConstants.dart';
import 'package:flutter_todo/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class TabTodoListPage extends StatefulWidget {
  TabTodoListPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TabTodoListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: GlobalConstants.todoTypes.length,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: getTabs(),
          ),
        ),
        body: TabBarView(
          children: getTabViews(),
        ),
      ),
    );
  }

  List<Widget> getTabs() {
    List<Widget> tabs = [];
    for (String type in GlobalConstants.todoTypes) {
      tabs.add(Tab(
          child: Text(type,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.white))));
    }
    return tabs;
  }

  List<Widget> getTabViews() {
    List<Widget> tabs = [];
    for (String type in GlobalConstants.todoTypes) {
      tabs.add(TodoList(type));
    }
    return tabs;
  }
}

class TodoList extends StatefulWidget {
  TodoList(this.type, {Key key}) : super(key: key);

  final type;

  @override
  _TodoListState createState() => _TodoListState(type);
}

class _TodoListState extends State<TodoList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  _TodoListState(this.type);

  final type;
  bool _hasLoadData = false;
  List<Todo> _todoList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    print('load data todo list');
    var where = {"type": type};
    DataHelper.loadData(DataHelper.COLLECTION_LIST, where: where).then((value) {
      if (!this.mounted) return;
      if (value.code != null) {
        loadDataError(value.message);
        return;
      }

      setState(() {
        _hasLoadData = true;
        List<Todo> todoList = (value.data as List)
            .map((e) => Todo.fromJson(new Map<String, dynamic>.from(e)))
            .toList();
        todoList.sort((a, b) {
          // 未完成的在前，已完成的在后
          if(a.done && !b.done) return 1;
          if(!a.done && b.done) return -1;

          String aDate;
          String bDate;
          if (a.todoDate != null) {
            aDate = a.todoDate;
          }
          if (a.notifyDate != null) {
            aDate = a.notifyDate;
          }
          if (b.todoDate != null) {
            bDate = b.todoDate;
          }
          if (b.notifyDate != null) {
            bDate = b.notifyDate;
          }

          if (aDate != null && bDate != null) {
            // 都有日期，按日期排
            return aDate.compareTo(bDate);
          } else if (aDate == null && bDate == null) {
            // 都没日期，按名字排
            return a.name.compareTo(b.name);
          } else {
            // 无日期的在前，有日期的在后
            return aDate != null ? 1 : -1;
          }
        });
        _todoList = todoList;
      });
    }).catchError(loadDataError);
  }

  loadDataError(error) {
    Fluttertoast.showToast(msg: "加载失败 " + error.toString());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        heroTag: type,
        child: Icon(Icons.add),
        onPressed: () {
          MyRouteDelegate.of(context).push("todoDetail", arguments: {"type": type});
        },
      ),
    );
  }

  getBody() {
    RefreshNotifier notifier = Provider.of<RefreshNotifier>(context);
    if(notifier.refreshList.contains("todoList")) {
      _hasLoadData = false;
      loadData();
      notifier.refreshList.remove("todoList");
    }

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
        itemCount: _todoList.length);
  }

  getRow(int index) {
    Todo todo = _todoList[index];
    String date = "[未设置时间]";
    if (todo.todoDate != null) {
      date = "[" + todo.todoDate + "]";
    }
    if (todo.notifyDate != null) {
      date = "[" + todo.notifyDate + "]";
    }
    return Row(
      children: [
        Checkbox(
          value: todo.done ?? false,
          onChanged: (value) {
            setState(() {
              todo.done = !todo.done;
            });
            DataHelper.updateData(
                DataHelper.COLLECTION_LIST, todo.id, {"done": todo.done});
          },
        ),
        Expanded(
          child: GestureDetector(
            child: Text(date + " " + todo.name),
            onTap: () {
              MyRouteDelegate.of(context).push("todoDetail", arguments: {"type": type, "todo": todo});
              //     .then((value) => loadData());
            },
          ),
        ),
      ],
    );
  }
}

