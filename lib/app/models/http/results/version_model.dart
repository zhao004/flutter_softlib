import 'package:json_annotation/json_annotation.dart';

part 'version_model.g.dart';

@JsonSerializable()
class VersionModel {
  @JsonKey(name: "code")
  int? code;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "data")
  List<VersionData>? data;

  VersionModel({this.code, this.msg, this.time, this.data});

  factory VersionModel.fromJson(Map<String, dynamic> json) =>
      _$VersionModelFromJson(json);

  Map<String, dynamic> toJson() => _$VersionModelToJson(this);
}

@JsonSerializable()
class VersionData {
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

  VersionData({
    this.version,
    this.title,
    this.content,
    this.dowUrl,
    this.forcedSwitch,
  });

  factory VersionData.fromJson(Map<String, dynamic> json) =>
      _$VersionDataFromJson(json);

  Map<String, dynamic> toJson() => _$VersionDataToJson(this);
}
