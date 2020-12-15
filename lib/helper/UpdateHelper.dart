import 'dart:io';

import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_todo/entity/Version.dart';
import 'package:flutter_todo/helper/CloudBaseHelper.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateHelper {
  /// The package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
  static String packageName;

  /// The package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  static String version;

  /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
  static String buildNumber;

  static List<Version> list;

  static void showUpdateDialog(BuildContext context) {
    if (list == null) return;

    String updateInfo = getUpdateInfoListStr();

    showDialog<bool>(
      context: context,
      barrierDismissible: false, // outside cancel
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // back button cancel
          child: AlertDialog(
            title: Text("版本更新"),
            content: Text(updateInfo),
            actions: <Widget>[
              FlatButton(
                child: Text("更新"),
                onPressed: () {
                  showDownloadDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static void showDownloadDialog(BuildContext context) async {
    Version newest = getNewestUpdateInfo();
    // 判断是否可以直接走浏览器链接
    if (newest.link.startsWith("http")) {
      if (await canLaunch(newest.link)) {
        await launch(newest.link);
        return;
      }
    }

    Directory storageDir = await getExternalStorageDirectory();
    String storagePath = storageDir.path;
    File file = new File('$storagePath/lovecookbook${newest.versionName}.apk');

    bool exists = await file.exists();
    if (!exists) {
      await file.create();
    }

    print(file);

    // cloudbase fileId
    ProgressDialog dialog = new ProgressDialog(context,
        type: ProgressDialogType.Download, isDismissible: false);
    CloudBaseStorage storage = CloudBaseHelper.getStorage();
    storage.downloadFile(
      fileId: newest.link,
      savePath: file.path,
      onProcess: (count, total) {
        double progress = 1000 * count / total;
        progress = progress.toInt() / 10;
        dialog.update(progress: progress);
        if (count >= total) {
          dialog.hide();
          showDownloadSuccessDialog(context, file);
        }
      },
    );
    dialog.show();
  }

  static void showDownloadSuccessDialog(BuildContext context, File file) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false, // outside cancel
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // back button cancel
          child: AlertDialog(
            title: Text("下载完成"),
            content: Text("下载文件路径：${file.path}"),
            actions: <Widget>[
              FlatButton(
                child: Text("安装"),
                onPressed: () {
                  InstallPlugin.installApk(file.path, packageName);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static saveVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  static saveUpdateInfoList() async {
    // FIXME 区分iOS和安卓
    if (buildNumber == null) {
      throw Exception("buildNumber为空");
    }

    var _ = CloudBaseHelper.getDb().command;
    int code = int.parse(buildNumber);
    var where = {
      // 大于当前版本的
      "versionCode": _.gt(code)
    };
    DbQueryResponse response = await DataHelper.loadData(
        DataHelper.COLLECTION_VERSION,
        where: where,
        orderField: "versionCode");

    if (response.code != null) {
      throw Exception(response.message);
    }

    list = (response.data as List)
        .map((e) => Version.fromJson(new Map<String, dynamic>.from(e)))
        .toList();
  }

  static Version getNewestUpdateInfo() {
    if (list == null) return null;
    return list[0];
  }

  static getUpdateInfoListStr() {
    if (list == null) return "";
    String info = "";
    for (Version version in list) {
      info += ("${version.versionName}\n");
      if (version.updateInfo == null) {
        info += ("    无更新内容\n");
      } else {
        for (String line in version.updateInfo.split("\\n")) {
          info += ("    " + line.trim() + "\n");
        }
      }
    }
    return info;
  }

  static bool hasForceVersion() {
    if (list == null) return false;
    for (Version version in list) {
      if (version.isForceUpdate) return true;
    }
    return false;
  }
}
