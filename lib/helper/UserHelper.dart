import 'dart:convert';

import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/User.dart';
import 'package:flutter_todo/helper/SpDataHelper.dart';

import 'CloudBaseHelper.dart';

class UserHelper {

  static User _curUser;

  static Future<CloudBaseResponse> register(
      String username, String password) async {
    CloudBaseResponse res = await CloudBaseHelper.getFunction()
        .callFunction('register', {"username": username, "password": password});

    if (res.code != null) {
      throw Exception(res.message);
    }
    if (res.data != null &&
        res.data is Map &&
        res.data["code"] != null &&
        res.data["code"] != 0) {
      throw Exception(res.data["message"]);
    }
    return res;
  }

  static Future<CloudBaseAuthState> login(
      String username, String password) async {
    CloudBaseResponse res = await CloudBaseHelper.getFunction()
        .callFunction('login', {"username": username, "password": password});

    if (res.code != null) {
      throw Exception(res.message);
    }

    if (res.data != null &&
        res.data is Map &&
        res.data["code"] != null &&
        res.data["code"] != 0) {
      throw Exception(res.data["message"]);
    }

    var data = res.data["data"];
    String ticket = data["ticket"];

    // 用户名密码正确，继续CloudBase的自定义登录
    CloudBaseCore core = CloudBaseHelper.init();
    CloudBaseAuth auth = CloudBaseAuth(core);

    CloudBaseAuthState authState = await auth.signInWithTicket(ticket);
    // 记录用户信息到本地
    _curUser = User.fromJson(data["user"]);
    SpDataHelper.saveData(SpDataHelper.COLLECTION_USER, _curUser);
    return authState;
  }

  static void logout() async {
    SpDataHelper.deleteData(SpDataHelper.COLLECTION_USER);

    // TODO 不能登出，还要保持登录状态才能继续调用。如何替换回匿名？
    // CloudBaseCore core = CloudBaseHelper.init();
    // CloudBaseAuth auth = CloudBaseAuth(core);
    // try {
    //   await auth.signOut();
    // } catch (e) {
    //   // 不做处理
    // }
  }

  static Future<User> getUserInfo() async {
    if(_curUser == null) {
      String jsonStr = await SpDataHelper.loadData(SpDataHelper.COLLECTION_USER);
      if(jsonStr != null) {
        _curUser = User.fromJson(json.decode(jsonStr));
      }
    }
    return _curUser;
  }
}
