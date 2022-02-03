import 'package:json_annotation/json_annotation.dart';
import 'models.dart';

part 'order.g.dart';

@JsonSerializable(includeIfNull: true)
class Order {
  Order({
    this.id,
    this.orderNumber,
    this.discountedPrice,
    this.totPrice,
    this.selfPickUp,
    this.dostawkaPrice,
    this.deliveryTime,
    this.createdAt,
    this.status,
    this.restaurant,
    this.promocode,
    this.driver,
    this.orderItems,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'orderNumber')
  final String? orderNumber;

  @JsonKey(name: 'discountedPrice')
  final num? discountedPrice;

  @JsonKey(name: 'totPrice')
  final num? totPrice;

  @JsonKey(name: 'selfPickUp')
  final bool? selfPickUp;

  @JsonKey(name: 'dostawkaPrice')
  final num? dostawkaPrice;

  @JsonKey(name: 'deliveryTime')
  final DateTime? deliveryTime;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'status')
  final int? status;

  @JsonKey(name: 'restaurant')
  final Restaurant? restaurant;

  @JsonKey(name: 'promocode')
  final Promocode? promocode;

  @JsonKey(name: 'driver')
  final Driver? driver;

  @JsonKey(name: 'orderItems')
  final List<OrderItem>? orderItems;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
