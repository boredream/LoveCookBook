
import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TabTodoListPage extends StatefulWidget {
  TabTodoListPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TabTodoListPage> with AutomaticKeepAliveClientMixin {

  // FIXME bottomNavigation 页面切换不保留状态？

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: "吃吃吃"),
              Tab(text: "看剧"),
              Tab(text: "出游"),
              Tab(text: "其他"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TodoList(Todo.TYPE_EAT),
            TodoList(Todo.TYPE_VIDEO),
            TodoList(Todo.TYPE_TRAVEL),
            TodoList(Todo.TYPE_OTHER),
          ],
        ),
      ),
    );
  }

}

class TodoList extends StatefulWidget {
  TodoList(this.type, {Key key}) : super(key: key);

  final type;

  @override
  _TodoListState createState() => _TodoListState(type);
}

class _TodoListState extends State<TodoList> with AutomaticKeepAliveClientMixin {

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
    DataHelper.loadData(type).then((value) {
      if (!this.mounted) return;
      if (value.code != null) {
        loadDataError(value.message);
        return;
      }

      setState(() {
        _hasLoadData = true;
        _todoList = (value.data as List)
            .map((e) => Todo.fromJson(new Map<String, dynamic>.from(e)))
            .toList();
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
          Navigator.pushNamed(context, "todoDetail", arguments: {"type": type})
              .then((value) => loadData());
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
        itemCount: _todoList.length);
  }

  getRow(int index) {
    Todo todo = _todoList[index];
    return Row(
      children: [
        Checkbox(
          value: todo.done ?? false,
          onChanged: (value) {
            setState(() {
              todo.done = !todo.done;
            });
             DataHelper.doneData(todo);
          },
        ),
        Expanded(
          child: GestureDetector(
            child: Text("[" + (todo.todoDate ?? "未设置时间") + "] " + todo.name),
            onTap: () {
              // FIXME 使用通知一类的方案刷新
              Navigator.pushNamed(context, "todoDetail",
                      arguments: {"type": type, "todo": todo})
                  .then((value) => loadData());
            },
          ),
        ),
      ],
    );
  }
}
