import 'dart:convert';
import 'dart:io';

import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'CloudBaseHelper.dart';

class ImageHelper {

  static compressAndUploadFile(String filePath, void onProcess(int count, int total)) {

  }

  static Future<File> compressAndGetFile(String sourcePath, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      quality: 80,
      minWidth: 1024,
      minHeight: 1024,
    );
    return result;
  }


  static Future<dynamic> uploadFile(String filePath, void onProcess(int count, int total)) async {
    String filename = filePath.substring(filePath.lastIndexOf("/") + 1);
    return CloudBaseHelper.getStorage().uploadFile(
        cloudPath: 'flutter/' + filename,
        filePath: filePath,
        onProcess: onProcess);
  }

}
