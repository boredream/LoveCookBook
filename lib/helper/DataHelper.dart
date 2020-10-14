import 'dart:convert';

import 'package:flutter_todo/entity/Todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KEY_TODO_LIST = "todo_list";

class DataHelper {
  clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(KEY_TODO_LIST);
  }

  saveData(Todo data) async {
    final prefs = await SharedPreferences.getInstance();
    var todoListJson = prefs.getString(KEY_TODO_LIST) ?? "[]";
    List<Todo> todoList = List<Todo>.from(
        (json.decode(todoListJson) as List).map((i) => Todo.fromJson(i)));
    var index = -1;
    if(data.createDate != null) {
      index = todoList.indexOf(data);
    }
    if(index == -1) {
      // 新数据 or 找不到匹配的
      data.createDate = DateTime.now().toString();
      todoList.insert(0, data);
    } else {
      // 更新数据
      todoList[index] = data;
    }

    todoListJson = json.encode(todoList);
    prefs.setString(KEY_TODO_LIST, todoListJson);
  }

  Future<List<Todo>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    var todoListJson = prefs.getString(KEY_TODO_LIST) ?? "[]";
    List<Todo> todoList = List<Todo>.from(
        (json.decode(todoListJson) as List).map((i) => Todo.fromJson(i)));
    return todoList;
  }

  void saveDataList(List<Todo> todoList) async {
    final prefs = await SharedPreferences.getInstance();
    var todoListJson = json.encode(todoList);
    prefs.setString(KEY_TODO_LIST, todoListJson);
  }
}
