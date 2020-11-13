import 'package:json_annotation/json_annotation.dart';

import 'BaseCloudBean.dart';

part 'RegularInvestment.g.dart';

// flutter packages pub run build_runner watch
@JsonSerializable()
class RegularInvestment extends BaseCloudBean {
  RegularInvestment();

  String name;
  String startDate;
  String endDate;
  double rate;

  factory RegularInvestment.fromJson(Map<String, dynamic> json) =>
      _$RegularInvestmentFromJson(json);

  Map<String, dynamic> toJson() => _$RegularInvestmentToJson(this);
}
