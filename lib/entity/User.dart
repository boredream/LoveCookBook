import 'package:json_annotation/json_annotation.dart';

import 'BaseCloudBean.dart';

part 'User.g.dart';

// flutter packages pub run build_runner build
@JsonSerializable()
class User extends BaseCloudBean {
  User();

  String username;
  String password;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
