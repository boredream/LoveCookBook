import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';

const KEY_TODO_LIST = "todo_list";

class DataHelper {

  static Future<DbCreateResponse> saveData(Todo data) async {
    DbCreateResponse response =
        await CloudBaseHelper.getDb().collection("list").add(data.toJson());
    if (response.code != null) {
      throw Exception(response.message);
    }
    return response;
  }

  static Future<DbUpdateResponse> updateData(Todo data) async {
    String id = data.getId();
    Map<String, dynamic> newData = data.toJson();
    // 更新的时候不能带 _id
    newData.remove("_id");

    DbUpdateResponse response =
        await CloudBaseHelper.getDb().collection("list").doc(id).set(newData);
    if (response.code != null) {
      throw Exception(response.message);
    }
    return response;
  }

  static Future<DbQueryResponse> loadData(String type) async {
    DbQueryResponse response =
        await CloudBaseHelper.getDb().collection("list").get();
    if (response.code != null) {
      throw Exception(response.message);
    }
    return response;
  }

  static Future<DbRemoveResponse> delete(Todo data) async {
    DbRemoveResponse response = await CloudBaseHelper.getDb()
        .collection("list")
        .doc(data.getId())
        .remove();
    if (response.code != null) {
      throw Exception(response.message);
    }
    return response;
  }
}
