// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderItem _$CreateOrderItemFromJson(Map<String, dynamic> json) =>
    CreateOrderItem(
      meal: json['meal'] as int?,
      price: json['price'] as num?,
      quantity: json['quantity'] as int?,
      volumePrices: (json['volumePrices'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      costumizedMeals: (json['costumizedMeals'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$CreateOrderItemToJson(CreateOrderItem instance) =>
    <String, dynamic>{
      'meal': instance.meal,
      'price': instance.price,
      'quantity': instance.quantity,
      'volumePrices': instance.volumePrices,
      'costumizedMeals': instance.costumizedMeals,
    };
