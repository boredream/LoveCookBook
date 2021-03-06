

import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:cloudbase_function/cloudbase_function.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';

class CloudBaseHelper {

  static CloudBaseCore _core;
  static CloudBaseDatabase _db;
  static CloudBaseStorage _storage;
  static CloudBaseFunction _function;

  static CloudBaseCore init() {
    if(_core == null) {
      // 初始化 CloudBase
      _core = CloudBaseCore.init({
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
    return _core;
  }

  static CloudBaseDatabase getDb() {
    CloudBaseCore core = init();
    if(_db == null) {
      _db = CloudBaseDatabase(core);
    }
    return _db;
  }

  static CloudBaseStorage getStorage() {
    CloudBaseCore core = init();
    if(_storage == null) {
      _storage = CloudBaseStorage(core);
    }
    return _storage;
  }

  static CloudBaseFunction getFunction() {
    CloudBaseCore core = init();
    if(_function == null) {
      _function = CloudBaseFunction(core);
    }
    return _function;
  }

}