// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) {
  return Menu()
    .._id = json['_id'] as String
    ..type = json['type'] as String
    ..name = json['name'] as String
    ..images = (json['images'] as List)?.map((e) => e as String)?.toList()
    ..createDate = json['createDate'] as String;
}

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      '_id': instance._id,
      'type': instance.type,
      'name': instance.name,
      'images': instance.images,
      'createDate': instance.createDate,
    };
