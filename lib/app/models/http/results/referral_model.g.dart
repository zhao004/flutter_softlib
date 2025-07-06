// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferralModel _$ReferralModelFromJson(Map<String, dynamic> json) =>
    ReferralModel(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      time: json['time'] as String?,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ReferralData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ReferralModelToJson(ReferralModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'time': instance.time,
      'data': instance.data,
    };

ReferralData _$ReferralDataFromJson(Map<String, dynamic> json) => ReferralData(
  type: json['type'] as String?,
  image: json['image'] as String?,
  title: json['title'] as String?,
  content: json['content'] as String?,
  url: json['url'] as String?,
);

Map<String, dynamic> _$ReferralDataToJson(ReferralData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'image': instance.image,
      'title': instance.title,
      'content': instance.content,
      'url': instance.url,
    };
