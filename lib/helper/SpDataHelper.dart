import 'dart:convert';

import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataHelper {

  static const COLLECTION_LIST = "list";
  static const COLLECTION_MENU = "menu";
  static const COLLECTION_THE_DAY = "theDay";
  static const COLLECTION_REGULAR_INVEST = "regularInvest";
  static const COLLECTION_FUND = "fund";

  static Future<bool> saveData(
      String collection, dynamic data) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> jsonList = sp.getStringList(collection);
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

  static Future<bool> deleteData(String collection, String id) async {
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

  static Future<DbQueryResponse> loadData(String collection,
      {dynamic where, String orderField, bool orderGrow, int limit}) async {
    // FIXME
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> jsonList = sp.getStringList(collection);

    DbQueryResponse response = DbQueryResponse();
    response.data = jsonList;
    return response;
  }

}
