// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) {
  return Todo()
    ..done = json['done'] as bool
    ..name = json['name'] as String
    ..desc = json['desc'] as String
    ..images = (json['images'] as List)?.map((e) => e as String)?.toList()
    ..todoDate = json['todoDate'] as String
    ..createDate = json['createDate'] as String
    ..doneDate = json['doneDate'] as String;
}

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'done': instance.done,
      'name': instance.name,
      'desc': instance.desc,
      'images': instance.images,
      'todoDate': instance.todoDate,
      'createDate': instance.createDate,
      'doneDate': instance.doneDate,
    };
