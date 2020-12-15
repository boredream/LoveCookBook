import 'package:flutter/material.dart';
import 'package:flutter_todo/helper/ImageHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DialogUtils {

  static ProgressDialog getProgressDialog(BuildContext context) {
    ProgressDialog dialog = ProgressDialog(context,
        customBody: Container(
          width: 150,
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  width: 32, height: 32, child: CircularProgressIndicator()),
              SizedBox(width: 16),
              Text("请等待..."),
            ],
          ),
        ));
    return dialog;
  }

  static showConfirmDialog(
      BuildContext context, String content, String btn, Function onClick) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.pop(context), // 关闭对话框
            ),
            FlatButton(
              child: Text(btn),
              onPressed: () {
                Navigator.pop(context, true);
                onClick.call();
              },
            ),
          ],
        );
      },
    );
  }

  static showDeleteConfirmDialog(BuildContext context, Function onDelete) {
    showConfirmDialog(context, "您确定要删除吗？", "删除", () => onDelete.call());
  }

  static showImagePickDialog(
      BuildContext context, Function(String) onPick) async {
    showItemsDialog(context, [
      "相册",
      "拍照"
    ], [
      () {
        ImageHelper.selectImage(ImageSource.gallery)
            .then((value) => onPick.call(value));
      },
      () {
        ImageHelper.selectImage(ImageSource.camera)
            .then((value) => onPick.call(value));
      }
    ]);
  }

  static showItemsDialog(
      BuildContext context, List<String> items, List<Function> callbacks) {
    if (items == null ||
        items.length == 0 ||
        callbacks == null ||
        items.length != callbacks.length) return;

    showDialog<bool>(
      context: context,
      builder: (context) {
        List<Widget> children = [];
        for (int i = 0; i < items.length; i++) {
          children.add(SimpleDialogOption(
            child: new Text(items[i], textAlign: TextAlign.center),
            padding: EdgeInsets.all(16),
            onPressed: () {
              Navigator.of(context).pop();
              callbacks[i].call();
            },
          ));
        }

        children.add(SimpleDialogOption(
          child: new Text("取消",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey)),
          padding: EdgeInsets.all(16),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ));

        return SimpleDialog(
          children: children,
        );
      },
    );
  }
}
