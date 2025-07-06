// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_cat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportCatModel _$ReportCatModelFromJson(Map<String, dynamic> json) =>
    ReportCatModel(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      time: json['time'] as String?,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ReportCatData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ReportCatModelToJson(ReportCatModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'time': instance.time,
      'data': instance.data,
    };

ReportCatData _$ReportCatDataFromJson(Map<String, dynamic> json) =>
    ReportCatData(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$ReportCatDataToJson(ReportCatData instance) =>
    <String, dynamic>{'id': instance.id, 'title': instance.title};
