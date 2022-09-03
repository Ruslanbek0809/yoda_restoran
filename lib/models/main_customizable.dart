import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'main_customizable.g.dart';

@JsonSerializable()
class MainCustomizable {
  MainCustomizable({
    this.id,
    this.name,
    this.mealId,
    this.customizables,
  });

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'meal')
  final int? mealId;

  @JsonKey(name: 'costumizes')
  final List<Customizable>? customizables;

  factory MainCustomizable.fromJson(Map<String, dynamic> json) =>
      _$MainCustomizableFromJson(json);

  Map<String, dynamic> toJson() => _$MainCustomizableToJson(this);
}
