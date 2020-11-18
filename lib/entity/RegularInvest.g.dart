// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RegularInvest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegularInvest _$RegularInvestFromJson(Map<String, dynamic> json) {
  return RegularInvest()
    ..id = json['_id'] as String
    ..name = json['name'] as String
    ..startDate = json['startDate'] as String
    ..endDate = json['endDate'] as String
    ..rate = (json['rate'] as num)?.toDouble()
    ..money = json['money'] as int;
}

Map<String, dynamic> _$RegularInvestToJson(RegularInvest instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'rate': instance.rate,
      'money': instance.money,
    };
