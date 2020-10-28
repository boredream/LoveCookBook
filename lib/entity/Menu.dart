import 'package:json_annotation/json_annotation.dart';

part 'Menu.g.dart';

@JsonSerializable()
class Menu {

  Menu();

  String _id;
  String type;
  String name;
  List<String> images = [];
  String createDate;

  String getId() {
    return _id;
  }

  setId(String id) {
    _id = id;
  }

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);
  Map<String, dynamic> toJson() => _$MenuToJson(this);

  @override
  bool operator ==(Object other) {
    if(other is Menu) {
      Menu o = other;
      return _id == o._id;
    }
    return super == other;
  }
}
