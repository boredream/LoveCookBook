// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RegularInvestment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegularInvestment _$RegularInvestmentFromJson(Map<String, dynamic> json) {
  return RegularInvestment()
    ..id = json['_id'] as String
    ..name = json['name'] as String
    ..startDate = json['startDate'] as String
    ..endDate = json['endDate'] as String
    ..rate = (json['rate'] as num)?.toDouble();
}

Map<String, dynamic> _$RegularInvestmentToJson(RegularInvestment instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'rate': instance.rate,
    };
