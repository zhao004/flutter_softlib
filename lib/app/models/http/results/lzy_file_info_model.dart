import 'package:json_annotation/json_annotation.dart';

part 'lzy_file_info_model.g.dart';

@JsonSerializable()
class LzyFileInfoModel {
  @JsonKey(name: "code")
  int? code;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "data")
  LzyFileInfoData? data;

  LzyFileInfoModel({this.code, this.msg, this.time, this.data});

  factory LzyFileInfoModel.fromJson(Map<String, dynamic> json) =>
      _$LzyFileInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$LzyFileInfoModelToJson(this);
}

@JsonSerializable()
class LzyFileInfoData {
  @JsonKey(name: "file_icon")
  String? fileIcon;
  @JsonKey(name: "file_name")
  String? fileName;
  @JsonKey(name: "file_type")
  String? fileType;
  @JsonKey(name: "file_time")
  String? fileTime;
  @JsonKey(name: "file_size")
  String? fileSize;
  @JsonKey(name: "file_desc")
  String? fileDesc;
  @JsonKey(name: "file_image")
  String? fileImage;

  LzyFileInfoData({
    this.fileName,
    this.fileTime,
    this.fileSize,
    this.fileDesc,
    this.fileImage,
  });

  factory LzyFileInfoData.fromJson(Map<String, dynamic> json) =>
      _$LzyFileInfoDataFromJson(json);

  Map<String, dynamic> toJson() => _$LzyFileInfoDataToJson(this);
}
