import 'package:json_annotation/json_annotation.dart';

import 'BaseCloudBean.dart';

part 'TheDay.g.dart';

// flutter packages pub run build_runner watch
@JsonSerializable()
class TheDay extends BaseCloudBean {

  TheDay();
  String name;
  String desc;
  String theDayDate;
  String notifyDate;
  String remindPeriod;
  List<String> images = [];

  factory TheDay.fromJson(Map<String, dynamic> json) => _$TheDayFromJson(json);
  Map<String, dynamic> toJson() => _$TheDayToJson(this);
}
