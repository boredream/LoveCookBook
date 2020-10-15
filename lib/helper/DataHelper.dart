import 'dart:convert';

import 'package:flutter_todo/entity/Todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const KEY_TODO_LIST = "todo_list";

class DataHelper {

  clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  saveData(Todo data) {
    // Create a CollectionReference called users that references the firestore collection
    FirebaseFirestore.instance.collection('list')
        .doc(data.createDate)
        .set(data.toJson())
        .then((value) => print("Added"))
        .catchError((error) => print("Failed to add : $error"));
  }

  void delete(Todo data) async {
    final prefs = await SharedPreferences.getInstance();
    var key = KEY_TODO_LIST + "_" + data.type;
    var todoListJson = prefs.getString(key) ?? "[]";
    List<Todo> todoList = List<Todo>.from(
        (json.decode(todoListJson) as List).map((i) => Todo.fromJson(i)));
    var index = -1;
    if(data.createDate != null) {
      index = todoList.indexOf(data);
    }
    if(index != -1) {
      // 新数据 or 找不到匹配的不用管。匹配的直接删除
      todoList.removeAt(index);
    }

    todoListJson = json.encode(todoList);
    prefs.setString(key, todoListJson);
  }

  Future<List<Todo>> loadData(String type) async {
    final prefs = await SharedPreferences.getInstance();
    var key = KEY_TODO_LIST + "_" + type;
    var todoListJson = prefs.getString(key) ?? "[]";
    List<Todo> todoList = List<Todo>.from(
        (json.decode(todoListJson) as List).map((i) => Todo.fromJson(i)));
    return todoList;
  }

  void saveDataList(String type, List<Todo> todoList) async {
    final prefs = await SharedPreferences.getInstance();
    var todoListJson = json.encode(todoList);
    var key = KEY_TODO_LIST + "_" + type;
    prefs.setString(key, todoListJson);
  }
}
