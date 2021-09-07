import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';
import 'package:http/http.dart' as http;

class SpringDataHelper {
  static const HOST = 'http://10.0.2.2:8080';

  static const COLLECTION_LIST = "list";
  static const COLLECTION_MENU = "menu";
  static const COLLECTION_THE_DAY = "theDay";
  static const COLLECTION_REGULAR_INVEST = "regularInvest";
  static const COLLECTION_FUND = "fund";
  static const COLLECTION_VERSION = "version";
  static const COLLECTION_FEEDBACK = "feedback";
  static const COLLECTION_TARGET = "target";
  static const COLLECTION_STOCK = "stock";

  static Future<String> saveData(String collection, dynamic data) async {
    Map<String, dynamic> newData = data.toJson();
    print('saveData $collection\n$newData');

    Uri uri = Uri.parse("$HOST/$collection");

    http.Response response = await http.post(uri, body: newData);
    if (response.statusCode != 200) {
      throw Exception(response.statusCode);
    }
    return response.body;
  }

  static Future<DbUpdateResponse> setData(String collection, String id, dynamic data) async {
    Map<String, dynamic> newData = data.toJson();
    print('setData $collection\n$newData');
    // 更新的时候不能带 _id
    newData.remove("_id");

    DbUpdateResponse response = await CloudBaseHelper.getDb().collection(collection).doc(id).set(newData);
    if (response.code != null) {
      throw Exception(response.message);
    }
    return response;
  }

  static Future<DbUpdateResponse> updateData(String collection, String id, Map<String, dynamic> update) async {
    DbUpdateResponse response = await CloudBaseHelper.getDb().collection(collection).doc(id).update(update);
    if (response.code != null) {
      throw Exception(response.message);
    }
    return response;
  }

  static Future<DbRemoveResponse> deleteData(String collection, String id) async {
    DbRemoveResponse response = await CloudBaseHelper.getDb().collection(collection).doc(id).remove();
    if (response.code != null) {
      throw Exception(response.message);
    }
    return response;
  }

  static Future<String> loadData(String collection,
      {dynamic where, String orderField, bool orderGrow, int limit}) async {
    print('loadData $collection');

    Uri uri = Uri.parse("$HOST/$collection");

    http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception(response.statusCode);
    }

    // dynamic col = CloudBaseHelper.getDb().collection(collection);
    // if (where != null) {
    //   col = col.where(where);
    // }
    // if (orderField != null) {
    //   if (orderGrow == null) {
    //     // 默认降序
    //     orderGrow = false;
    //   }
    //   col = col.orderBy(orderField, orderGrow ? "asc" : "desc");
    // }
    // if (limit == null) {
    //   // 默认拉取数量
    //   limit = 100;
    // }

    // DbQueryResponse response = await col.limit(limit).get();
    // if (response.code != null) {
    //   throw Exception(response.message);
    // }

    return response.body;
  }
}