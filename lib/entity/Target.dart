import 'package:flutter_todo/entity/TargetItem.dart';
import 'package:json_annotation/json_annotation.dart';

import 'BaseCloudBean.dart';

part 'Target.g.dart';

// flutter packages pub run build_runner watch
@JsonSerializable()
class Target extends BaseCloudBean {

  Target();
  String name;
  String doneDate;
  int totalProgress;
  List<TargetItem> items;

  factory Target.fromJson(Map<String, dynamic> json) => _$TargetFromJson(json);
  Map<String, dynamic> toJson() => _$TargetToJson(this);
}
