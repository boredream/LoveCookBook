// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Target.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Target _$TargetFromJson(Map<String, dynamic> json) {
  return Target()
    ..id = json['_id'] as String
    ..name = json['name'] as String
    ..desc = json['desc'] as String
    ..defaultAddProgress = json['defaultAddProgress'] as int
    ..doneDate = json['doneDate'] as String
    ..items = (json['items'] as List)
        ?.map((e) =>
            e == null ? null : TargetItem.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TargetToJson(Target instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'defaultAddProgress': instance.defaultAddProgress,
      'doneDate': instance.doneDate,
      'items': instance.items,
    };
