import 'package:json_annotation/json_annotation.dart';

class BaseCloudBean {

  @JsonKey(name: "_id")
  String id;

  @override
  bool operator ==(Object other) {
    if(other is BaseCloudBean) {
      BaseCloudBean o = other;
      return id == o.id;
    }
    return super == other;
  }
}
