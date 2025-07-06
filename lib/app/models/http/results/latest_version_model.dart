import 'package:json_annotation/json_annotation.dart';

part 'latest_version_model.g.dart';

@JsonSerializable()
class LatestVersionModel {
  @JsonKey(name: "code")
  int? code;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "data")
  LatestVersionData? data;

  LatestVersionModel({this.code, this.msg, this.time, this.data});

  factory LatestVersionModel.fromJson(Map<String, dynamic> json) =>
      _$LatestVersionModelFromJson(json);

  Map<String, dynamic> toJson() => _$LatestVersionModelToJson(this);
}

@JsonSerializable()
class LatestVersionData {
  @JsonKey(name: "version")
  String? version;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "dow_url")
  String? dowUrl;
  @JsonKey(name: "forced_switch")
  bool? forcedSwitch;

  LatestVersionData({
    this.version,
    this.title,
    this.content,
    this.dowUrl,
    this.forcedSwitch,
  });

  factory LatestVersionData.fromJson(Map<String, dynamic> json) =>
      _$LatestVersionDataFromJson(json);

  Map<String, dynamic> toJson() => _$LatestVersionDataToJson(this);
}
