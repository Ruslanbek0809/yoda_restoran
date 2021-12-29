import 'package:json_annotation/json_annotation.dart';
import 'models.dart';

part 'promocode.g.dart';

@JsonSerializable()
class Promocode {
  Promocode({
    this.id,
    this.name,
    this.quantity,
    this.restaurant,
    this.promoType,
    this.promocodeType,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'quantity')
  final int? quantity;

  @JsonKey(name: 'restaurant')
  final int? restaurant;

  @JsonKey(name: 'promoType')
  final int? promoType;

  @JsonKey(name: 'promoTypeJson')
  final PromocodeType? promocodeType;

  factory Promocode.fromJson(Map<String, dynamic> json) =>
      _$PromocodeFromJson(json);

  Map<String, dynamic> toJson() => _$PromocodeToJson(this);
}
