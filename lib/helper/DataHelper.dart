import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const KEY_TODO_LIST = "todo_list";

class DataHelper {

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    return FirebaseStorage.instance
        .ref('uploads/file-to-upload.png')
        .putFile(file);
  }

  Future<void> saveData(Todo data) {
    if(data.createDate == null) {
      // 新增，创建个日期
      data.createDate = DateTime.now().toString();
    }
    return FirebaseFirestore.instance
        .collection("list")
        .doc(data.createDate)
        .set(data.toJson());
  }

  Future<QuerySnapshot> loadData(String type) {
    // TODO 分页
    return FirebaseFirestore.instance
        .collection("list")
        .where("type", isEqualTo: type)
        .get();
  }

  Future<void> delete(Todo data) async {
    return FirebaseFirestore.instance
        .collection("list")
        .doc(data.createDate)
        .delete();
  }

  void saveDataList(String type, List<Todo> todoList) async {
    final prefs = await SharedPreferences.getInstance();
    var todoListJson = json.encode(todoList);
    var key = KEY_TODO_LIST + "_" + type;
    prefs.setString(key, todoListJson);
  }
}
