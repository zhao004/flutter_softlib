// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lzy_file_parse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LzyFileParseModel _$LzyFileParseModelFromJson(Map<String, dynamic> json) =>
    LzyFileParseModel(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      time: json['time'] as String?,
      data:
          json['data'] == null
              ? null
              : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LzyFileParseModelToJson(LzyFileParseModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'time': instance.time,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) =>
    Data(url: json['url'] as String?);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'url': instance.url,
};
