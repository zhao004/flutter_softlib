// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carousel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarouselModel _$CarouselModelFromJson(Map<String, dynamic> json) =>
    CarouselModel(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      time: json['time'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CarouselData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CarouselModelToJson(CarouselModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'time': instance.time,
      'data': instance.data,
    };

CarouselData _$CarouselDataFromJson(Map<String, dynamic> json) => CarouselData(
  type: json['type'] as String?,
  title: json['title'] as String?,
  image: json['image'] as String?,
  url: json['url'] as String?,
);

Map<String, dynamic> _$CarouselDataToJson(CarouselData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'image': instance.image,
      'url': instance.url,
    };
