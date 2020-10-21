import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';

const KEY_TODO_LIST = "todo_list";

class DataHelper {
  uploadFile(String filePath, void onProcess(int count, int total)) {
    String filename = filePath.substring(filePath.lastIndexOf("/") + 1);
    CloudBaseHelper.getStorage().uploadFile(
        cloudPath: 'flutter/' + filename,
        filePath: filePath,
        onProcess: onProcess);
  }

  Future<DbCreateResponse> saveData(Todo data) async {
    DbCreateResponse response =
        await CloudBaseHelper.getDb().collection("list").add(data.toJson());
    if (response.code != null) {
      throw Exception(response.message);
    }
    return response;
  }

  Future<DbUpdateResponse> updateData(Todo data) async {
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

  Future<DbQueryResponse> loadData(String type) async {
    DbQueryResponse response =
        await CloudBaseHelper.getDb().collection("list").get();
    if (response.code != null) {
      throw Exception(response.message);
    }
    return response;
  }

  Future<DbRemoveResponse> delete(Todo data) async {
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
