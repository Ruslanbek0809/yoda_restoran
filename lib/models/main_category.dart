import 'package:json_annotation/json_annotation.dart';
part 'main_category.g.dart';

@JsonSerializable()
class MainCategory {
  MainCategory({
    this.id,
    this.image,
    this.name,
    this.name_tk,
    this.name_ru,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'name_tk')
  final String? name_tk;

  @JsonKey(name: 'name_ru')
  final String? name_ru;

  factory MainCategory.fromJson(Map<String, dynamic> json) =>
      _$MainCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MainCategoryToJson(this);
}
