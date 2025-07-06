// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppModel _$AppModelFromJson(Map<String, dynamic> json) => AppModel(
  code: (json['code'] as num?)?.toInt(),
  msg: json['msg'] as String?,
  time: json['time'] as String?,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => AppData.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$AppModelToJson(AppModel instance) => <String, dynamic>{
  'code': instance.code,
  'msg': instance.msg,
  'time': instance.time,
  'data': instance.data,
};

AppData _$AppDataFromJson(Map<String, dynamic> json) =>
    AppData(title: json['title'] as String?, url: json['url'] as String?);

Map<String, dynamic> _$AppDataToJson(AppData instance) => <String, dynamic>{
  'title': instance.title,
  'url': instance.url,
};
