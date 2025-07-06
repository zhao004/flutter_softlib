import 'package:json_annotation/json_annotation.dart';

part 'carousel_model.g.dart';

@JsonSerializable()
class CarouselModel {
  @JsonKey(name: "code")
  int? code;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "data")
  List<CarouselData>? data;

  CarouselModel({this.code, this.msg, this.time, this.data});

  factory CarouselModel.fromJson(Map<String, dynamic> json) =>
      _$CarouselModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarouselModelToJson(this);
}

@JsonSerializable()
class CarouselData {
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "url")
  String? url;

  CarouselData({this.type, this.title, this.image, this.url});

  factory CarouselData.fromJson(Map<String, dynamic> json) =>
      _$CarouselDataFromJson(json);

  Map<String, dynamic> toJson() => _$CarouselDataToJson(this);
}
