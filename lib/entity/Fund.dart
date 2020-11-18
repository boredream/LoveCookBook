import 'package:json_annotation/json_annotation.dart';

import 'BaseCloudBean.dart';

part 'Fund.g.dart';

// flutter packages pub run build_runner build
@JsonSerializable()
class Fund extends BaseCloudBean {
  Fund();

  String name;
  int oriMoney;
  int curMoney;
  int existIncome;

  factory Fund.fromJson(Map<String, dynamic> json) =>
      _$FundFromJson(json);

  Map<String, dynamic> toJson() => _$FundToJson(this);
}
