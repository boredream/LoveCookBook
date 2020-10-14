import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'Todo.g.dart';

@JsonSerializable()
class Todo {
  Todo({this.done = false});
  bool done;
  String name;
  String desc;
  List<String> images = [];
  String createDate;
  String todoDate;
  String doneDate;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  @override
  bool operator ==(Object other) {
    if(other is Todo) {
      Todo o = other;
      return createDate == o.createDate;
    }
    return super == other;
  }
}

enum TodoType {
  EAT,
  VIDEO,
  TRAVEL,
  OTHER,
}
