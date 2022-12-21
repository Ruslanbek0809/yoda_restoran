import 'package:json_annotation/json_annotation.dart';

part 'about_us.g.dart';

@JsonSerializable()
class AboutUsModel {
  AboutUsModel({
    this.id,
    this.name,
    this.info,
    this.infoTk,
    this.infoRu,
  });

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'info')
  final String? info;
  @JsonKey(name: 'info_tk')
  final String? infoTk;
  @JsonKey(name: 'info_ru')
  final String? infoRu;

  factory AboutUsModel.fromJson(Map<String, dynamic> json) =>
      _$AboutUsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AboutUsModelToJson(this);
}
