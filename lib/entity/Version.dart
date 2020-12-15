import 'package:json_annotation/json_annotation.dart';

import 'BaseCloudBean.dart';

part 'Version.g.dart';

// flutter packages pub run build_runner build
@JsonSerializable()
class Version extends BaseCloudBean {

  Version();
  bool isForceUpdate;
  int versionCode;
  String versionName;
  String updateInfo;
  String link;

  factory Version.fromJson(Map<String, dynamic> json) => _$VersionFromJson(json);
  Map<String, dynamic> toJson() => _$VersionToJson(this);

}





