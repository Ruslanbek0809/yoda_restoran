import 'package:json_annotation/json_annotation.dart';
import 'models.dart';

part 'promoted.g.dart';

@JsonSerializable(includeIfNull: true)
class Promoted {
  Promoted({
    this.id,
    this.position,
    this.name,
    this.order,
    this.restaurants,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'position')
  final int? position;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'order')
  final int? order;

  @JsonKey(name: 'restaurant')
  final List<Restaurant>? restaurants;

  factory Promoted.fromJson(Map<String, dynamic> json) =>
      _$PromotedFromJson(json);

  Map<String, dynamic> toJson() => _$PromotedToJson(this);
}
