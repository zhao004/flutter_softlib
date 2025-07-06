// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lzy_file_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LzyFileInfoModel _$LzyFileInfoModelFromJson(Map<String, dynamic> json) =>
    LzyFileInfoModel(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      time: json['time'] as String?,
      data:
          json['data'] == null
              ? null
              : LzyFileInfoData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LzyFileInfoModelToJson(LzyFileInfoModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'time': instance.time,
      'data': instance.data,
    };

LzyFileInfoData _$LzyFileInfoDataFromJson(Map<String, dynamic> json) =>
    LzyFileInfoData(
        fileName: json['file_name'] as String?,
        fileTime: json['file_time'] as String?,
        fileSize: json['file_size'] as String?,
        fileDesc: json['file_desc'] as String?,
        fileImage: json['file_image'] as String?,
      )
      ..fileIcon = json['file_icon'] as String?
      ..fileType = json['file_type'] as String?;

Map<String, dynamic> _$LzyFileInfoDataToJson(LzyFileInfoData instance) =>
    <String, dynamic>{
      'file_icon': instance.fileIcon,
      'file_name': instance.fileName,
      'file_type': instance.fileType,
      'file_time': instance.fileTime,
      'file_size': instance.fileSize,
      'file_desc': instance.fileDesc,
      'file_image': instance.fileImage,
    };
