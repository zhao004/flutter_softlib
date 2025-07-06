import 'package:json_annotation/json_annotation.dart';

part 'lzy_dir_parse_model.g.dart';

@JsonSerializable()
class LzyDirParseModel {
  @JsonKey(name: "code")
  int? code;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "data")
  List<LzyDirParseData>? data;

  LzyDirParseModel({this.code, this.msg, this.time, this.data});

  factory LzyDirParseModel.fromJson(Map<String, dynamic> json) =>
      _$LzyDirParseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LzyDirParseModelToJson(this);
}

@JsonSerializable()
class LzyDirParseData {
  @JsonKey(name: "icon")
  String? icon;
  @JsonKey(name: "t")
  int? t;
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "name_all")
  String? nameAll;
  @JsonKey(name: "size")
  String? size;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "duan")
  String? duan;
  @JsonKey(name: "p_ico")
  int? pIco;
  @JsonKey(name: "ico")
  String? ico;
  @JsonKey(name: "down")
  String? down;

  LzyDirParseData({
    this.icon,
    this.t,
    this.id,
    this.nameAll,
    this.size,
    this.time,
    this.duan,
    this.pIco,
    this.ico,
    this.down,
  });

  factory LzyDirParseData.fromJson(Map<String, dynamic> json) =>
      _$LzyDirParseDataFromJson(json);

  Map<String, dynamic> toJson() => _$LzyDirParseDataToJson(this);
}
