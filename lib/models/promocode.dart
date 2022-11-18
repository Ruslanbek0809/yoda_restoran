import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'promocode.g.dart';

@JsonSerializable()
class Promocode {
  Promocode({
    this.id,
    this.name,
    this.quantity,
    this.discount,
    this.text,
    this.minLimit,
    this.promoType,
    this.promocodeType,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'quantity')
  final int? quantity;

  @JsonKey(name: 'discount')
  final num? discount;

  @JsonKey(name: 'text')
  final String? text;

  @JsonKey(name: 'minLimit')
  final num? minLimit;

  @JsonKey(name: 'promoType')
  final int? promoType;

  @JsonKey(name: 'promoTypeJson')
  final PromocodeType? promocodeType;

  factory Promocode.fromJson(Map<String, dynamic> json) =>
      _$PromocodeFromJson(json);

  Map<String, dynamic> toJson() => _$PromocodeToJson(this);
}
