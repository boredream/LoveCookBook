import 'dart:convert';

import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpDataHelper {

  static const COLLECTION_USER = "user";

  static Future<bool> saveData(
      String collection, dynamic data) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.setString(collection, json.encode(data));
  }

  static Future<bool> saveDataList(
      String collection, dynamic data) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> jsonList = sp.getStringList(collection);
    if(jsonList == null) jsonList = [];
    jsonList.add(json.encode(data));
    return sp.setStringList(collection, jsonList);
  }

  static Future<bool> setData(
      String collection, String id, dynamic data) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> jsonList = sp.getStringList(collection);
    for (int i = 0; i < jsonList.length; i++) {
      if(id == json.decode(jsonList[i])["_id"]) {
        jsonList[i] = json.encode(data);
        return sp.setStringList(collection, jsonList);
      }
    }
    return false;
  }

  static Future<bool> updateData(
      String collection, String id, Map<String, dynamic> update) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> jsonList = sp.getStringList(collection);
    for (int i = 0; i < jsonList.length; i++) {
      if(id == json.decode(jsonList[i])["_id"]) {
        for(MapEntry entry in update.entries) {
          Map data = json.decode(jsonList[i]);
          data[entry.key] = data[entry.value];
        }
        return sp.setStringList(collection, jsonList);
      }
    }
    return false;
  }

  static Future<bool> deleteData(String collection) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.remove(COLLECTION_USER);
  }

  static Future<bool> deleteDataById(String collection, String id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> jsonList = sp.getStringList(collection);
    int deleteIndex = -1;
    for (int i = 0; i < jsonList.length; i++) {
      if(id == json.decode(jsonList[i])["_id"]) {
        deleteIndex = i;
        break;
      }
    }
    if(deleteIndex != -1) {
      jsonList.removeAt(deleteIndex);
      return sp.setStringList(collection, jsonList);
    }
    return false;
  }

  static Future<String> loadData(String collection) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(collection);
  }

  static Future<DbQueryResponse> loadDataList(String collection,
      {dynamic where, String orderField, bool orderGrow, int limit}) async {
    // FIXME
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> jsonList = sp.getStringList(collection);

    DbQueryResponse response = DbQueryResponse();
    response.data = jsonList;
    return response;
  }

}
