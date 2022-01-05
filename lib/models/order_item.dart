import 'package:json_annotation/json_annotation.dart';

import 'models.dart';
part 'order_item.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderItem {
  OrderItem({
    this.meal,
    this.price,
    this.quantity,
    this.volumePrices,
    this.costumizedMeals,
    this.mealJson,
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

  @JsonKey(name: 'mealJson')
  final Meal? mealJson;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
