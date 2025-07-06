import 'package:json_annotation/json_annotation.dart';

part 'lzy_file_parse_model.g.dart';

@JsonSerializable()
class LzyFileParseModel {
  @JsonKey(name: "code")
  int? code;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "data")
  Data? data;

  LzyFileParseModel({this.code, this.msg, this.time, this.data});

  factory LzyFileParseModel.fromJson(Map<String, dynamic> json) =>
      _$LzyFileParseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LzyFileParseModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "url")
  String? url;

  Data({this.url});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
