import 'package:json_annotation/json_annotation.dart';

part 'Todo.g.dart';

@JsonSerializable()
class Todo {

  static const TYPE_EAT = "eat";
  static const TYPE_VIDEO = "video";
  static const TYPE_TRAVEL = "travel";
  static const TYPE_OTHER = "other";

  Todo({this.done = false});
  bool done;
  String type;
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
