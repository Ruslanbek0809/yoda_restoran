import 'package:json_annotation/json_annotation.dart';
part 'res_category_model.g.dart';

@JsonSerializable()
class ResCategoryModel {
  ResCategoryModel({
    this.id,
    this.name,
    this.image,
    this.order,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'order')
  final int? order;

  factory ResCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ResCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResCategoryModelToJson(this);
}
