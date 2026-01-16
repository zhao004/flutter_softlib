// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
  code: (json['code'] as num?)?.toInt(),
  msg: json['msg'] as String?,
  time: json['time'] as String?,
  data: json['data'] == null
      ? null
      : Data.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'time': instance.time,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  id: (json['id'] as num?)?.toInt(),
  image: json['image'] as String?,
  title: json['title'] as String?,
  content: json['content'] as String?,
  views: (json['views'] as num?)?.toInt(),
  createtime: (json['createtime'] as num?)?.toInt(),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'id': instance.id,
  'image': instance.image,
  'title': instance.title,
  'content': instance.content,
  'views': instance.views,
  'createtime': instance.createtime,
};
