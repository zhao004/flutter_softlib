// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigModel _$ConfigModelFromJson(Map<String, dynamic> json) => ConfigModel(
  code: (json['code'] as num?)?.toInt(),
  msg: json['msg'] as String?,
  time: json['time'] as String?,
  data: json['data'] == null
      ? null
      : ConfigData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ConfigModelToJson(ConfigModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'time': instance.time,
      'data': instance.data,
    };

ConfigData _$ConfigDataFromJson(Map<String, dynamic> json) => ConfigData(
  feedbackGroup: json['feedback_group'] as String?,
  feedbackUser: json['feedback_user'] as String?,
  placard: json['placard'] as String?,
);

Map<String, dynamic> _$ConfigDataToJson(ConfigData instance) =>
    <String, dynamic>{
      'feedback_group': instance.feedbackGroup,
      'feedback_user': instance.feedbackUser,
      'placard': instance.placard,
    };
