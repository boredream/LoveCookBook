

import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/cloudbase_database.dart';

class CloudBaseHelper {

  static CloudBaseCore core;
  static CloudBaseDatabase db;

  static CloudBaseCore init() {
    if(core == null) {
      // 初始化 CloudBase
      core = CloudBaseCore.init({
        // 填写您的云开发 env
        'env': 'lovecookbook-7gjn846l3db07924',
        // 填写您的移动应用安全来源凭证
        // 生成凭证的应用标识必须是 Android 包名或者 iOS BundleID
        'appAccess': {
          // 凭证
          'key': 'a43f41be8f9c624d32dd9da068350e68',
          // 版本
          'version': '1'
        }
      });
    }
    return core;
  }

  static CloudBaseDatabase getDb() {
    CloudBaseCore core = init();
    if(db == null) {
      db = CloudBaseDatabase(core);
    }
    return db;
  }

  static Future<CloudBaseAuthState> login() async {
    CloudBaseCore core = init();
    // 获取登录状态
    CloudBaseAuth auth = CloudBaseAuth(core);
    CloudBaseAuthState authState = await auth.getAuthState();

    // 唤起匿名登录
    if (authState == null) {
      try {
        authState = await auth.signInAnonymously();
      } catch(e) {
        print("login error = " + e.toString());
      }
    }

    return authState;
  }
}