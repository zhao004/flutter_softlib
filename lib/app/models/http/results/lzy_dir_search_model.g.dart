// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lzy_dir_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LzyDirSearchModel _$LzyDirSearchModelFromJson(Map<String, dynamic> json) =>
    LzyDirSearchModel(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      time: json['time'] as String?,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => LzyDirSearchData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$LzyDirSearchModelToJson(LzyDirSearchModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'time': instance.time,
      'data': instance.data,
    };

LzyDirSearchData _$LzyDirSearchDataFromJson(Map<String, dynamic> json) =>
    LzyDirSearchData(
      id: json['id'] as String?,
      icon: json['icon'] as String?,
      nameAll: json['name_all'] as String?,
      size: json['size'] as String?,
      duan: json['duan'] as String?,
      pIco: (json['p_ico'] as num?)?.toInt(),
      ico: json['ico'] as String?,
      t: json['t'] as String?,
      down: json['down'] as String?,
    );

Map<String, dynamic> _$LzyDirSearchDataToJson(LzyDirSearchData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'icon': instance.icon,
      'name_all': instance.nameAll,
      'size': instance.size,
      'duan': instance.duan,
      'p_ico': instance.pIco,
      'ico': instance.ico,
      't': instance.t,
      'down': instance.down,
    };
