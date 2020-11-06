import 'package:json_annotation/json_annotation.dart';

import 'BaseCloudBean.dart';

part 'Menu.g.dart';

@JsonSerializable()
class Menu extends BaseCloudBean {

  Menu();
  String type;
  String name;
  List<String> images = [];
  String createDate;

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);
  Map<String, dynamic> toJson() => _$MenuToJson(this);
}
