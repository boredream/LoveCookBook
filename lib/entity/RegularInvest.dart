import 'package:json_annotation/json_annotation.dart';

import 'BaseCloudBean.dart';

part 'RegularInvest.g.dart';

// flutter packages pub run build_runner build
@JsonSerializable()
class RegularInvest extends BaseCloudBean {
  RegularInvest();

  String name;
  String startDate;
  String endDate;
  double rate;
  int money;

  factory RegularInvest.fromJson(Map<String, dynamic> json) =>
      _$RegularInvestFromJson(json);

  Map<String, dynamic> toJson() => _$RegularInvestToJson(this);
}
