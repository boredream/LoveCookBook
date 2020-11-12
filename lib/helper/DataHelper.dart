import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';

class DataHelper {
  
  static const COLLECTION_LIST = "list";
  static const COLLECTION_MENU = "menu";
  static const COLLECTION_THE_DAY = "theDay";

  static Future<DbCreateResponse> saveData(
      String collection, dynamic data) async {
    DbCreateResponse response =
        await CloudBaseHelper.getDb().collection(collection).add(data.toJson());
    if (response.code != null) {
      throw Exception(response.message);
    }
    return response;
  }

  static Future<DbUpdateResponse> setData(
      String collection, String id, dynamic data) async {
    Map<String, dynamic> newData = data.toJson();
    // 更新的时候不能带 _id
    newData.remove("_id");

    DbUpdateResponse response = await CloudBaseHelper.getDb()
        .collection(collection)
        .doc(id)
        .set(newData);
    if (response.code != null) {
      throw Exception(response.message);
    }
    return response;
  }

  static Future<DbUpdateResponse> updateData(
      String collection, String id, Map<String, dynamic> update) async {
    DbUpdateResponse response = await CloudBaseHelper.getDb()
        .collection(collection)
        .doc(id)
        .update(update);
    if (response.code != null) {
      throw Exception(response.message);
    }
    return response;
  }

  static Future<DbRemoveResponse> deleteData(String collection, String id) async {
    DbRemoveResponse response =
        await CloudBaseHelper.getDb().collection(collection).doc(id).remove();
    if (response.code != null) {
      throw Exception(response.message);
    }
    return response;
  }

  static Future<DbQueryResponse> loadData(String collection,
      {dynamic where, String orderField, bool orderGrow, int limit}) async {
    dynamic col = CloudBaseHelper.getDb().collection(collection);
    if (where != null) {
      col = col.where(where);
    }
    if (orderField != null) {
      if(orderGrow == null) {
        // 默认降序
        orderGrow = false;
      }
      col = col.orderBy(orderField, orderGrow ? "asc" : "desc");
    }
    if(limit == null) {
      // 默认拉取数量
      limit = 100;
    }

    DbQueryResponse response = await col.limit(limit).get();
    if (response.code != null) {
      throw Exception(response.message);
    }
    return response;
  }
  
}
