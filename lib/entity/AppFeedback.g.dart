// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppFeedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppFeedback _$AppFeedbackFromJson(Map<String, dynamic> json) {
  return AppFeedback()
    ..id = json['_id'] as String
    ..name = json['name'] as String
    ..contact = json['contact'] as String
    ..feedback = json['feedback'] as String;
}

Map<String, dynamic> _$AppFeedbackToJson(AppFeedback instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'contact': instance.contact,
      'feedback': instance.feedback,
    };
