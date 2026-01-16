// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lzy_dir_parse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LzyDirParseModel _$LzyDirParseModelFromJson(Map<String, dynamic> json) =>
    LzyDirParseModel(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => LzyDirParseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LzyDirParseModelToJson(LzyDirParseModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'time': instance.time,
      'data': instance.data,
    };

LzyDirParseData _$LzyDirParseDataFromJson(Map<String, dynamic> json) =>
    LzyDirParseData(
      icon: json['icon'] as String?,
      t: (json['t'] as num?)?.toInt(),
      id: json['id'] as String?,
      nameAll: json['name_all'] as String?,
      size: json['size'] as String?,
      time: json['time'] as String?,
      duan: json['duan'] as String?,
      pIco: (json['p_ico'] as num?)?.toInt(),
      ico: json['ico'] as String?,
      down: json['down'] as String?,
    );

Map<String, dynamic> _$LzyDirParseDataToJson(LzyDirParseData instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      't': instance.t,
      'id': instance.id,
      'name_all': instance.nameAll,
      'size': instance.size,
      'time': instance.time,
      'duan': instance.duan,
      'p_ico': instance.pIco,
      'ico': instance.ico,
      'down': instance.down,
    };
