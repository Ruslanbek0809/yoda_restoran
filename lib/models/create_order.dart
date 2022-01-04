import 'package:json_annotation/json_annotation.dart';

import 'models.dart';
part 'create_order.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateOrder {
  CreateOrder({
    this.restaurant,
    this.address,
    this.selfPickUp,
    this.deliveryTime,
    this.promocode,
    this.paymentType,
    this.notes,
    this.orderItems,
  });

  @JsonKey(name: 'restaurant')
  final int? restaurant;

  @JsonKey(name: 'address')
  final int? address;

  @JsonKey(name: 'selfPickUp')
  final bool? selfPickUp;

  @JsonKey(name: 'deliveryTime')
  final DateTime? deliveryTime;

  @JsonKey(name: 'promocode')
  final int? promocode;

  @JsonKey(name: 'paymentType')
  final int? paymentType;

  @JsonKey(name: 'notes')
  final String? notes;

  @JsonKey(name: 'orderItems')
  final List<CreateOrderItem>? orderItems;

  factory CreateOrder.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderToJson(this);
}
