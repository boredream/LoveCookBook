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
    ..doneDate = json['doneDate'] as String
    ..defaultAddProgress = json['defaultAddProgress'] as int
    ..totalProgress = json['totalProgress'] as int
    ..items = (json['items'] as List)
        ?.map((e) =>
            e == null ? null : TargetItem.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..rewardList =
        (json['rewardList'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$TargetToJson(Target instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'doneDate': instance.doneDate,
      'defaultAddProgress': instance.defaultAddProgress,
      'totalProgress': instance.totalProgress,
      'items': instance.items,
      'rewardList': instance.rewardList,
    };
