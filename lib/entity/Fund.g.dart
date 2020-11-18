// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Fund.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fund _$FundFromJson(Map<String, dynamic> json) {
  return Fund()
    ..id = json['_id'] as String
    ..name = json['name'] as String
    ..oriMoney = json['oriMoney'] as int
    ..curMoney = json['curMoney'] as int
    ..existIncome = json['existIncome'] as int;
}

Map<String, dynamic> _$FundToJson(Fund instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'oriMoney': instance.oriMoney,
      'curMoney': instance.curMoney,
      'existIncome': instance.existIncome,
    };
