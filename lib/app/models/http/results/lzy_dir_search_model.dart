import 'package:json_annotation/json_annotation.dart';

part 'lzy_dir_search_model.g.dart';

@JsonSerializable()
class LzyDirSearchModel {
  @JsonKey(name: "code")
  int? code;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "data")
  List<LzyDirSearchData>? data;

  LzyDirSearchModel({this.code, this.msg, this.time, this.data});

  factory LzyDirSearchModel.fromJson(Map<String, dynamic> json) =>
      _$LzyDirSearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$LzyDirSearchModelToJson(this);
}

@JsonSerializable()
class LzyDirSearchData {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "icon")
  String? icon;
  @JsonKey(name: "name_all")
  String? nameAll;
  @JsonKey(name: "size")
  String? size;
  @JsonKey(name: "duan")
  String? duan;
  @JsonKey(name: "p_ico")
  int? pIco;
  @JsonKey(name: "ico")
  String? ico;
  @JsonKey(name: "t")
  String? t;
  @JsonKey(name: "down")
  String? down;

  LzyDirSearchData({
    this.id,
    this.icon,
    this.nameAll,
    this.size,
    this.duan,
    this.pIco,
    this.ico,
    this.t,
    this.down,
  });

  factory LzyDirSearchData.fromJson(Map<String, dynamic> json) =>
      _$LzyDirSearchDataFromJson(json);

  Map<String, dynamic> toJson() => _$LzyDirSearchDataToJson(this);
}
