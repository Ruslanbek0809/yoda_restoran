import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'slider.g.dart';

@JsonSerializable()
class SliderModel {
  SliderModel({
    this.id,
    this.order,
    this.image,
    this.option,
    this.restaurant,
    this.url,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'order')
  final int? order;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'option')
  final String? option;

  @JsonKey(name: 'url')
  final String? url;

  @JsonKey(name: 'restaurant')
  final Restaurant? restaurant;

  factory SliderModel.fromJson(Map<String, dynamic> json) =>
      _$SliderModelFromJson(json);

  Map<String, dynamic> toJson() => _$SliderModelToJson(this);
}
