import 'package:json_annotation/json_annotation.dart';

part 'slider.g.dart';

@JsonSerializable()
class SliderModel {
  SliderModel({
    this.id,
    this.image,
    this.option,
    this.url,
    this.order,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'option')
  final String? option;

  @JsonKey(name: 'url')
  final String? url;

  @JsonKey(name: 'order')
  final int? order;

  factory SliderModel.fromJson(Map<String, dynamic> json) =>
      _$SliderModelFromJson(json);

  Map<String, dynamic> toJson() => _$SliderModelToJson(this);
}
