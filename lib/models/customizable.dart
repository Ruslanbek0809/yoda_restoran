import 'package:json_annotation/json_annotation.dart';

part 'customizable.g.dart';

@JsonSerializable()
class Customizable {
  Customizable({
    this.id,
    this.customizableName,
    this.price,
    this.groupId,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'extraMeal')
  final String? customizableName;

  @JsonKey(name: 'price')
  final num? price;

  @JsonKey(name: 'group')
  final int? groupId;

  factory Customizable.fromJson(Map<String, dynamic> json) =>
      _$CustomizableFromJson(json);

  Map<String, dynamic> toJson() => _$CustomizableToJson(this);
}
