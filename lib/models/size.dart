import 'package:json_annotation/json_annotation.dart';
part 'size.g.dart';

@JsonSerializable()
class SizeModel {
  SizeModel({
    this.id,
    this.name,
    this.nameTk,
    this.nameRu,
  });

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'name_tk')
  final String? nameTk;

  @JsonKey(name: 'name_ru')
  final String? nameRu;

  factory SizeModel.fromJson(Map<String, dynamic> json) =>
      _$SizeModelFromJson(json);

  Map<String, dynamic> toJson() => _$SizeModelToJson(this);
}
