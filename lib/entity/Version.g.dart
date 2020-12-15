// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Version _$VersionFromJson(Map<String, dynamic> json) {
  return Version()
    ..id = json['_id'] as String
    ..isForceUpdate = json['isForceUpdate'] as bool
    ..versionCode = json['versionCode'] as int
    ..versionName = json['versionName'] as String
    ..updateInfo = json['updateInfo'] as String
    ..link = json['link'] as String;
}

Map<String, dynamic> _$VersionToJson(Version instance) => <String, dynamic>{
      '_id': instance.id,
      'isForceUpdate': instance.isForceUpdate,
      'versionCode': instance.versionCode,
      'versionName': instance.versionName,
      'updateInfo': instance.updateInfo,
      'link': instance.link,
    };
