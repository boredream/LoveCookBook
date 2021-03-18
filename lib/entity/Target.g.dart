// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Target.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Target _$TargetFromJson(Map<String, dynamic> json) {
  return Target()
    ..id = json['_id'] as String
    ..name = json['name'] as String
    ..doneDate = json['doneDate'] as String
    ..totalProgress = json['totalProgress'] as int
    ..items = (json['items'] as List)
        ?.map((e) =>
            e == null ? null : TargetItem.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TargetToJson(Target instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'doneDate': instance.doneDate,
      'totalProgress': instance.totalProgress,
      'items': instance.items,
    };
