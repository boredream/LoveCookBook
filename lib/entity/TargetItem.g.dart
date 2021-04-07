// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TargetItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetItem _$TargetItemFromJson(Map<String, dynamic> json) {
  return TargetItem()
    ..progress = json['progress'] as int
    ..type = json['type'] as int
    ..title = json['title'] as String
    ..desc = json['desc'] as String
    ..date = json['date'] as String
    ..newReward = json['newReward'] as String
    ..images = (json['images'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$TargetItemToJson(TargetItem instance) =>
    <String, dynamic>{
      'progress': instance.progress,
      'type': instance.type,
      'title': instance.title,
      'desc': instance.desc,
      'date': instance.date,
      'newReward': instance.newReward,
      'images': instance.images,
    };
