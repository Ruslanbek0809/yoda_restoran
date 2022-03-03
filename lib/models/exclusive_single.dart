import 'package:json_annotation/json_annotation.dart';
import 'models.dart';

part 'exclusive_single.g.dart';

@JsonSerializable(includeIfNull: true)
class ExclusiveSingle {
  ExclusiveSingle({
    this.id,
    this.name,
    this.order,
    this.image,
    this.option,
    this.url,
    this.richText,
    this.restaurant,
    this.restaurants,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'order')
  final int? order;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'option')
  final String? option;

  @JsonKey(name: 'url')
  final String? url;

  @JsonKey(name: 'reachText')
  final String? richText;

  @JsonKey(name: 'restaurant')
  final Restaurant? restaurant;

  @JsonKey(name: 'restaurants')
  final List<Restaurant>? restaurants;

  factory ExclusiveSingle.fromJson(Map<String, dynamic> json) =>
      _$ExclusiveSingleFromJson(json);

  Map<String, dynamic> toJson() => _$ExclusiveSingleToJson(this);
}
