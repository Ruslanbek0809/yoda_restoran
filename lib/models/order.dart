import 'package:json_annotation/json_annotation.dart';
import 'models.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  Order({
    this.id,
    this.orderNumber,
    this.discountedPrice,
    this.totMeal,
    this.selfPickUp,
    this.dostawkaPrice,
    this.deliveryTime,
    this.status,
    this.restaurant,
    this.promocode,
    this.driver,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'orderNumber')
  final String? orderNumber;

  @JsonKey(name: 'discountedPrice')
  final num? discountedPrice;

  @JsonKey(name: 'totMeal')
  final num? totMeal;

  @JsonKey(name: 'selfPickUp')
  final bool? selfPickUp;

  @JsonKey(name: 'dostawkaPrice')
  final num? dostawkaPrice;

  @JsonKey(name: 'deliveryTime')
  final DateTime? deliveryTime;

  @JsonKey(name: 'status')
  final int? status;

  @JsonKey(name: 'restaurant')
  final Restaurant? restaurant;

  @JsonKey(name: 'promocode')
  final Promocode? promocode;

  @JsonKey(name: 'driver')
  final Driver? driver;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
