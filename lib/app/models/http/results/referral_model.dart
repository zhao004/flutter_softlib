import 'package:json_annotation/json_annotation.dart';

part 'referral_model.g.dart';

@JsonSerializable()
class ReferralModel {
  @JsonKey(name: "code")
  int? code;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "time")
  String? time;
  @JsonKey(name: "data")
  List<ReferralData>? data;

  ReferralModel({this.code, this.msg, this.time, this.data});

  factory ReferralModel.fromJson(Map<String, dynamic> json) =>
      _$ReferralModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralModelToJson(this);
}

@JsonSerializable()
class ReferralData {
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "url")
  String? url;

  ReferralData({this.type, this.image, this.title, this.content, this.url});

  factory ReferralData.fromJson(Map<String, dynamic> json) =>
      _$ReferralDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralDataToJson(this);
}
