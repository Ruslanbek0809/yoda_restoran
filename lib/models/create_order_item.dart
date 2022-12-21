import 'package:json_annotation/json_annotation.dart';

part 'create_order_item.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateOrderItem {
  CreateOrderItem({
    this.meal,
    this.price,
    this.quantity,
    this.volumePrices,
    this.costumizedMeals,
  });

  @JsonKey(name: 'meal')
  final int? meal;

  @JsonKey(name: 'price')
  final num? price;

  @JsonKey(name: 'quantity')
  final int? quantity;

  @JsonKey(name: 'volumePrices')
  final List<int>? volumePrices;

  @JsonKey(name: 'costumizedMeals')
  final List<int>? costumizedMeals;

  factory CreateOrderItem.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderItemToJson(this);
}
