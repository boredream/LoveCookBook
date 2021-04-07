import 'package:flutter_todo/entity/TargetItem.dart';
import 'package:json_annotation/json_annotation.dart';

import 'BaseCloudBean.dart';

part 'Target.g.dart';

// flutter packages pub run build_runner build
@JsonSerializable()
class Target extends BaseCloudBean {
  Target();

  String name;
  String desc;
  String doneDate;
  int defaultAddProgress;
  List<TargetItem> items;
  List<String> rewardList;

  static String getRewardName(String reward) {
    if(reward == null || reward.split("::").length != 2) return null;
    return reward.split("::")[0];
  }

  static String getRewardProgress(String reward) {
    if(reward == null || reward.split("::").length != 2) return null;
    return reward.split("::")[1];
  }

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
