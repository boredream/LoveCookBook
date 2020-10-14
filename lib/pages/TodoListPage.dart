import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:flutter_todo/helper/DataHelper.dart';

class TabTodoListPage extends StatefulWidget {
  TabTodoListPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TabTodoListPage> {
  @override
  Widget build(BuildContext context) {
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
            TodoList(TodoType.EAT),
            TodoList(TodoType.VIDEO),
            TodoList(TodoType.TRAVEL),
            TodoList(TodoType.OTHER),
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

class TodoTypeInheritedWidget extends InheritedWidget {
  final TodoType type;

  TodoTypeInheritedWidget(this.type, {Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(TodoTypeInheritedWidget old) => type != old.type;

  static TodoTypeInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TodoTypeInheritedWidget>();
  }
}

class _TodoListState extends State<TodoList> {
  _TodoListState(this.type);

  final type;
  bool _hasLoadData = false;
  List<Todo> _todoList = [];
  DataHelper _helper = DataHelper();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    _helper.loadData(type).then((value) {
      setState(() {
        _hasLoadData = true;
        _todoList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TodoTypeInheritedWidget(
      type,
      child: Scaffold(
        body: getBody(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "todoDetail")
                .then((value) => loadData());
          },
        ),
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
          value: todo.done,
          onChanged: (value) {
            setState(() {
              todo.done = !todo.done;
            });
            _helper.saveDataList(_todoList);
          },
        ),
        Expanded(
          child: GestureDetector(
            child: Text(todo.name),
            onTap: () {
              // FIXME 使用通知一类的方案刷新
              Navigator.pushNamed(context, "todoDetail", arguments: todo)
                  .then((value) => loadData());
            },
          ),
        ),
      ],
    );
  }
}
