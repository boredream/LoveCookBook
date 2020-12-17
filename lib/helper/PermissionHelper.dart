import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {

  static checkAndRequestPermission(BuildContext context, Permission permission,
      String permissionName, Function successCall,
      {bool blockRequest = true}) async {
    final status = await permission.request();
    FlatButton cancelBtn = FlatButton(
        child: Text(blockRequest ? "退出应用" : "下次再说"),
        onPressed: () =>
            blockRequest ? SystemNavigator.pop() : Navigator.pop(context));
    if (status.isGranted) {
      successCall.call();
    } else if (status.isDenied) {
      debugPrint("校验权限:有任何一组权限被用户拒绝");
      showDialog<bool>(
        context: context,
        barrierDismissible: !blockRequest,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => !blockRequest,
            child: AlertDialog(
              content: Text("您拒绝了应用的必要权限:「$permissionName」,是否重新申请?"),
              actions: [
                cancelBtn,
                FlatButton(
                    child: Text("申请权限"),
                    onPressed: () => checkAndRequestPermission(
                        context, permission, permissionName, successCall,
                        blockRequest: blockRequest)),
              ],
            ),
          );
        },
      );
    } else {
      debugPrint("校验权限:有权限永久拒绝");
      showDialog<bool>(
        context: context,
        barrierDismissible: !blockRequest,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => !blockRequest,
            child: AlertDialog(
              content: Text("您禁用了应用的必要权限:「$permissionName」,请到设置里允许?"),
              actions: [
                cancelBtn,
                FlatButton(
                    child: Text("去设置"),
                    onPressed: () async {
                      await openAppSettings(); //打开设置页面
                      if (blockRequest) {
                        SystemNavigator.pop();
                      } else {
                        Navigator.pop(context);
                      }
                    }),
              ],
            ),
          );
        },
      );
    }
  }
}
