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
  List<TargetItem> items;

  int getTotalProgress() {
    int totalProgress = 0;
    for (TargetItem item in items ?? []) {
      totalProgress += item.progress ?? 0;
    }
    return totalProgress;
  }

  factory Target.fromJson(Map<String, dynamic> json) => _$TargetFromJson(json);

  Map<String, dynamic> toJson() => _$TargetToJson(this);
}
