// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatestVersionModel _$LatestVersionModelFromJson(Map<String, dynamic> json) =>
    LatestVersionModel(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      time: json['time'] as String?,
      data: json['data'] == null
          ? null
          : LatestVersionData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LatestVersionModelToJson(LatestVersionModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'time': instance.time,
      'data': instance.data,
    };

LatestVersionData _$LatestVersionDataFromJson(Map<String, dynamic> json) =>
    LatestVersionData(
      version: json['version'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      dowUrl: json['dow_url'] as String?,
      forcedSwitch: json['forced_switch'] as bool?,
    );

Map<String, dynamic> _$LatestVersionDataToJson(LatestVersionData instance) =>
    <String, dynamic>{
      'version': instance.version,
      'title': instance.title,
      'content': instance.content,
      'dow_url': instance.dowUrl,
      'forced_switch': instance.forcedSwitch,
    };
