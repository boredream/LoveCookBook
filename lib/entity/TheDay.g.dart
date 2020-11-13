// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TheDay.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TheDay _$TheDayFromJson(Map<String, dynamic> json) {
  return TheDay()
    ..id = json['_id'] as String
    ..name = json['name'] as String
    ..desc = json['desc'] as String
    ..createDate = json['createDate'] as String
    ..theDayDate = json['theDayDate'] as String
    ..remindPeriod = json['remindPeriod'] as String
    ..images = (json['images'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$TheDayToJson(TheDay instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'createDate': instance.createDate,
      'theDayDate': instance.theDayDate,
      'remindPeriod': instance.remindPeriod,
      'images': instance.images,
    };
