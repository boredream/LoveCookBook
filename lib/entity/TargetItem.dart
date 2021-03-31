import 'package:json_annotation/json_annotation.dart';

import 'BaseCloudBean.dart';

part 'TargetItem.g.dart';

// flutter packages pub run build_runner watch
@JsonSerializable()
class TargetItem {

  TargetItem();
  String targetId;
  int progress;
  int type;
  String title;
  String desc;
  String date;
  List<String> images = [];

  factory TargetItem.fromJson(Map<String, dynamic> json) => _$TargetItemFromJson(json);
  Map<String, dynamic> toJson() => _$TargetItemToJson(this);
}
