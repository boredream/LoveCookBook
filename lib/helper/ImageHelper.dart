import 'dart:convert';
import 'dart:io';

import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'CloudBaseHelper.dart';

class ImageHelper {

//  static Future<File> compressAndGetFile(String sourcePath, String targetPath) async {
//    final result = await FlutterImageCompress.compressAndGetFile(
//      sourcePath,
//      targetPath,
//      quality: 80,
//      minWidth: 1024,
//      minHeight: 1024,
//    );
//    return result;
//  }

  static Future<dynamic> uploadFile(String filePath, String cloudPath, {void onProcess(int count, int total)}) async {
    return CloudBaseHelper.getStorage().uploadFile(
        cloudPath: cloudPath,
        filePath: filePath,
        onProcess: onProcess);
  }

}
