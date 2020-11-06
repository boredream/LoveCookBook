import 'package:flutter/material.dart';

class DialogUtils {
  static showDeleteConfirmDialog(BuildContext context, Function onDelete) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("您确定要删除吗?"),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.pop(context), // 关闭对话框
            ),
            FlatButton(
              child: Text("删除"),
              onPressed: () {
                Navigator.pop(context, true);
                onDelete.call();
              },
            ),
          ],
        );
      },
    );
  }
}
