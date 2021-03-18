// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TargetItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetItem _$TargetItemFromJson(Map<String, dynamic> json) {
  return TargetItem()
    ..id = json['_id'] as String
    ..targetId = json['targetId'] as String
    ..progress = json['progress'] as int
    ..type = json['type'] as int
    ..title = json['title'] as String
    ..desc = json['desc'] as String
    ..date = json['date'] as String
    ..images = (json['images'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$TargetItemToJson(TargetItem instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'targetId': instance.targetId,
      'progress': instance.progress,
      'type': instance.type,
      'title': instance.title,
      'desc': instance.desc,
      'date': instance.date,
      'images': instance.images,
    };
