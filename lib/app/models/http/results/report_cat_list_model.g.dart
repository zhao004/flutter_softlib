// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_cat_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportCatListModel _$ReportCatListModelFromJson(Map<String, dynamic> json) =>
    ReportCatListModel(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ReportData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportCatListModelToJson(ReportCatListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'time': instance.time,
      'data': instance.data,
    };

ReportData _$ReportDataFromJson(Map<String, dynamic> json) => ReportData(
  id: (json['id'] as num?)?.toInt(),
  image: json['image'] as String?,
  title: json['title'] as String?,
  views: (json['views'] as num?)?.toInt(),
  createtime: (json['createtime'] as num?)?.toInt(),
);

Map<String, dynamic> _$ReportDataToJson(ReportData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'title': instance.title,
      'views': instance.views,
      'createtime': instance.createtime,
    };
