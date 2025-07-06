import 'package:json_annotation/json_annotation.dart';

part 'report_cat_list_model.g.dart';

@JsonSerializable()
class ReportCatListModel {
  @JsonKey(name: "code")
  int? code;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "data")
  List<ReportData>? data;

  ReportCatListModel({this.code, this.msg, this.time, this.data});

  factory ReportCatListModel.fromJson(Map<String, dynamic> json) =>
      _$ReportCatListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportCatListModelToJson(this);
}

@JsonSerializable()
class ReportData {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "views")
  int? views;
  @JsonKey(name: "createtime")
  int? createtime;

  ReportData({this.id, this.image, this.title, this.views, this.createtime});

  factory ReportData.fromJson(Map<String, dynamic> json) =>
      _$ReportDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReportDataToJson(this);
}
