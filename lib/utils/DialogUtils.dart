import 'package:flutter/material.dart';
import 'package:flutter_todo/helper/ImageHelper.dart';
import 'package:image_picker/image_picker.dart';

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

  static showItemsDialog (
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
