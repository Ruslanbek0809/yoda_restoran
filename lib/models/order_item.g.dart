// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      meal: json['meal'] as int?,
      price: json['price'] as num?,
      quantity: json['quantity'] as int?,
      volumePrices: (json['volumePrices'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      costumizedMeals: (json['costumizedMeals'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      mealJson: json['mealJson'] == null
          ? null
          : Meal.fromJson(json['mealJson'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'meal': instance.meal,
      'price': instance.price,
      'quantity': instance.quantity,
      'volumePrices': instance.volumePrices,
      'costumizedMeals': instance.costumizedMeals,
      'mealJson': instance.mealJson?.toJson(),
    };
