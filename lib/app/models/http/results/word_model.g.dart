// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordModel _$WordModelFromJson(Map<String, dynamic> json) => WordModel(
  code: (json['code'] as num?)?.toInt(),
  msg: json['msg'] as String?,
  time: json['time'] as String?,
  data: json['data'] as String?,
);

Map<String, dynamic> _$WordModelToJson(WordModel instance) => <String, dynamic>{
  'code': instance.code,
  'msg': instance.msg,
  'time': instance.time,
  'data': instance.data,
};
