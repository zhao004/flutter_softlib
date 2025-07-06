import 'package:json_annotation/json_annotation.dart';

part 'report_cat_model.g.dart';

@JsonSerializable()
class ReportCatModel {
  @JsonKey(name: "code")
  int? code;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "data")
  List<ReportCatData>? data;

  ReportCatModel({this.code, this.msg, this.time, this.data});

  factory ReportCatModel.fromJson(Map<String, dynamic> json) =>
      _$ReportCatModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportCatModelToJson(this);
}

@JsonSerializable()
class ReportCatData {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;

  ReportCatData({this.id, this.title});

  factory ReportCatData.fromJson(Map<String, dynamic> json) =>
      _$ReportCatDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReportCatDataToJson(this);
}
