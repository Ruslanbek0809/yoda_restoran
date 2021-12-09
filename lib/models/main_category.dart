import 'package:json_annotation/json_annotation.dart';
part 'main_category.g.dart';

@JsonSerializable()
class MainCategory {
  MainCategory({
    this.id,
    this.image,
    this.name,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'name')
  final String? name;

  factory MainCategory.fromJson(Map<String, dynamic> json) =>
      _$MainCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MainCategoryToJson(this);
}
