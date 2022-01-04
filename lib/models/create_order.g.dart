// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrder _$CreateOrderFromJson(Map<String, dynamic> json) => CreateOrder(
      restaurant: json['restaurant'] as int?,
      address: json['address'] as int?,
      selfPickUp: json['selfPickUp'] as bool?,
      deliveryTime: json['deliveryTime'] == null
          ? null
          : DateTime.parse(json['deliveryTime'] as String),
      promocode: json['promocode'] as int?,
      paymentType: json['paymentType'] as int?,
      notes: json['notes'] as String?,
      orderItems: (json['orderItems'] as List<dynamic>?)
          ?.map((e) => CreateOrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateOrderToJson(CreateOrder instance) =>
    <String, dynamic>{
      'restaurant': instance.restaurant,
      'address': instance.address,
      'selfPickUp': instance.selfPickUp,
      'deliveryTime': instance.deliveryTime?.toIso8601String(),
      'promocode': instance.promocode,
      'paymentType': instance.paymentType,
      'notes': instance.notes,
      'orderItems': instance.orderItems?.map((e) => e.toJson()).toList(),
    };
