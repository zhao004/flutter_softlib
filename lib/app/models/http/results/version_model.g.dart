// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionModel _$VersionModelFromJson(Map<String, dynamic> json) => VersionModel(
  code: (json['code'] as num?)?.toInt(),
  msg: json['msg'] as String?,
  time: json['time'] as String?,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => VersionData.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$VersionModelToJson(VersionModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'time': instance.time,
      'data': instance.data,
    };

VersionData _$VersionDataFromJson(Map<String, dynamic> json) => VersionData(
  version: json['version'] as String?,
  title: json['title'] as String?,
  content: json['content'] as String?,
  dowUrl: json['dow_url'] as String?,
  forcedSwitch: json['forced_switch'] as bool?,
);

Map<String, dynamic> _$VersionDataToJson(VersionData instance) =>
    <String, dynamic>{
      'version': instance.version,
      'title': instance.title,
      'content': instance.content,
      'dow_url': instance.dowUrl,
      'forced_switch': instance.forcedSwitch,
    };
