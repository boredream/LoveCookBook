import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/ImageBean.dart';
import 'package:image_picker/image_picker.dart';

import 'CloudBaseHelper.dart';

class ImageHelper {

  static Future<String> selectImage(ImageSource imageSource) async {
    // 选择图片
    final pickedFile = await ImagePicker().getImage(
      source: imageSource,
      imageQuality: 10,
    );
    if (pickedFile == null) return null;

    return pickedFile.path;
  }

  static getImageByUrl(String url) {
    return getImage(ImageBean(url: url));
  }

  static getImage(ImageBean image) {
    return image.path != null
        ? Image.file(File(image.path), fit: BoxFit.cover)
        : CachedNetworkImage(
            imageUrl: image.url,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                new Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          );
  }

  static ImageProvider getImageProvider(ImageBean image) {
    return image.path != null
        ? FileImage(File(image.path))
        : CachedNetworkImageProvider(image.url);
  }

  static Future<String> uploadImage(String filePath) async {
    // 根据路径path，获取文件名称
    String filename = filePath.substring(filePath.lastIndexOf("/") + 1);
    // 云端放在flutter目录下 + 文件名
    String cloudPath = 'flutter/' + filename;

    CloudBaseStorageRes<UploadRes> res = await uploadFile(filePath, cloudPath);
    // 上传成功，替换地址
    // field : cloud://lovecookbook-7gjn846l3db07924.6c6f-lovecookbook-7gjn846l3db07924-1253175673/flutter/image_picker_297004EB-44C4-4355-82AD-FFDA4553F8F4-28546-00000F1C08B97C8F.jpg
    // url: https://6c6f-lovecookbook-7gjn846l3db07924-1253175673.tcb.qcloud.la/flutter/image_picker_297004EB-44C4-4355-82AD-FFDA4553F8F4-28546-00000F1C08B97C8F.jpg
    String url = res.data.fileId.replaceFirst(
        "cloud://lovecookbook-7gjn846l3db07924.6c6f-lovecookbook-7gjn846l3db07924-1253175673",
        "https://6c6f-lovecookbook-7gjn846l3db07924-1253175673.tcb.qcloud.la");
    return url;
  }

  static Future<dynamic> uploadFile(String filePath, String cloudPath,
      {void onProcess(int count, int total)}) async {
    return CloudBaseHelper.getStorage().uploadFile(
        cloudPath: cloudPath, filePath: filePath, onProcess: onProcess);
  }
}
