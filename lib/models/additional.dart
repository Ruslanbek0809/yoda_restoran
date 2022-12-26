import 'package:json_annotation/json_annotation.dart';

part 'additional.g.dart';

@JsonSerializable()
class AdditionalModel {
  AdditionalModel({
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

  factory AdditionalModel.fromJson(Map<String, dynamic> json) =>
      _$AdditionalModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdditionalModelToJson(this);
}
