import 'dart:convert';

import 'package:flutter_todo/entity/Todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KEY_TODO_LIST = "todo_list";
class DataHelper {

  saveData(Todo data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(KEY_TODO_LIST, json.encode(data));
  }

  Future<List<Todo>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final todoListJson = prefs.getString(KEY_TODO_LIST) ?? "[]";
    List<Todo> todoList = json.decode(todoListJson).cast<Todo>();
    return todoList;
  }
}
