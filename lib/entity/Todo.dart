import 'package:json_annotation/json_annotation.dart';

import 'BaseCloudBean.dart';

part 'Todo.g.dart';

@JsonSerializable()
class Todo extends BaseCloudBean {

  Todo({this.done = false});
  bool done;
  String type;
  String name;
  String desc;
  List<String> images = [];
  String todoDate;
  String notifyDate;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);

}
