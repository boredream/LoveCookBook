import 'package:json_annotation/json_annotation.dart';

import 'BaseCloudBean.dart';

part 'AppFeedback.g.dart';

// flutter packages pub run build_runner build
@JsonSerializable()
class AppFeedback extends BaseCloudBean {
  AppFeedback();

  String name;
  String contact;
  String feedback;

  factory AppFeedback.fromJson(Map<String, dynamic> json) =>
      _$AppFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$AppFeedbackToJson(this);
}
