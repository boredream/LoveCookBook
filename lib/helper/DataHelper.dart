
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter_todo/entity/Todo.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';

const KEY_TODO_LIST = "todo_list";

class DataHelper {

//  Future<void> uploadFile(String filePath) async {
//    File file = File(filePath);
//    return FirebaseStorage.instance
//        .ref('uploads/file-to-upload.png')
//        .putFile(file);
//  }

  Future<DbCreateResponse> saveData(Todo data) {
    if(data.createDate == null) {
      // 新增，创建个日期
      data.createDate = DateTime.now().toString();
    }

    return CloudBaseHelper.getDb()
        .collection("list")
        .add(data.toJson());
//        .doc(data.createDate)
//        .set(data.toJson());
  }

  Future<DbQueryResponse> loadData(String type) {
    // TODO 分页
    return CloudBaseHelper.getDb()
        .collection("list")
        // .where({"type": type})
        .get();
  }

  Future<DbRemoveResponse> delete(Todo data) async {
    return CloudBaseHelper.getDb()
        .collection("list")
        .doc(data.createDate)
        .remove();
  }
}
