import 'package:json_annotation/json_annotation.dart';
part 'slider.g.dart';

@JsonSerializable()
class Slider {
  Slider({
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

  factory Slider.fromJson(Map<String, dynamic> json) => _$SliderFromJson(json);

  Map<String, dynamic> toJson() => _$SliderToJson(this);
}
