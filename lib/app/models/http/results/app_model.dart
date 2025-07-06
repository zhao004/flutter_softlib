import 'package:json_annotation/json_annotation.dart';

part 'app_model.g.dart';

@JsonSerializable()
class AppModel {
  @JsonKey(name: "code")
  int? code;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "data")
  List<AppData>? data;

  AppModel({this.code, this.msg, this.time, this.data});

  factory AppModel.fromJson(Map<String, dynamic> json) =>
      _$AppModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppModelToJson(this);
}

@JsonSerializable()
class AppData {
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "url")
  String? url;

  AppData({this.title, this.url});

  factory AppData.fromJson(Map<String, dynamic> json) =>
      _$AppDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppDataToJson(this);
}
