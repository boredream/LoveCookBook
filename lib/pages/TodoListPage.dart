import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabTodoListPage extends StatefulWidget {
  TabTodoListPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TabTodoListPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: "吃吃吃"),
              Tab(text: "看剧"),
              Tab(text: "出游"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TodoList(),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  TodoList({Key key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool _hasLoadData = false;
  List<Todo> _todoList = [];
  DataHelper _helper = DataHelper();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    _helper.loadData().then((value) {
      setState(() {
        print("load data done");
        _hasLoadData = true;
        _todoList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "todoDetail");
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
          value: todo.done,
          onChanged: (value) {},
        ),
        Expanded(
          child: Text(todo.name),
        ),
      ],
    );
  }
}
