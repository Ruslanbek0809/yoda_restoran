// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as int?,
      orderNumber: json['orderNumber'] as String?,
      discountedPrice: json['discountedPrice'] as num?,
      totPrice: json['totPrice'] as num?,
      selfPickUp: json['selfPickUp'] as bool?,
      dostawkaPrice: json['dostawkaPrice'] as num?,
      deliveryTime: json['deliveryTime'] == null
          ? null
          : DateTime.parse(json['deliveryTime'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      status: json['status'] as int?,
      restaurant: json['restaurant'] == null
          ? null
          : Restaurant.fromJson(json['restaurant'] as Map<String, dynamic>),
      promocode: json['promocode'] == null
          ? null
          : Promocode.fromJson(json['promocode'] as Map<String, dynamic>),
      driver: json['driver'] == null
          ? null
          : Driver.fromJson(json['driver'] as Map<String, dynamic>),
      orderItems: (json['orderItems'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'discountedPrice': instance.discountedPrice,
      'totPrice': instance.totPrice,
      'selfPickUp': instance.selfPickUp,
      'dostawkaPrice': instance.dostawkaPrice,
      'deliveryTime': instance.deliveryTime?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'status': instance.status,
      'restaurant': instance.restaurant,
      'promocode': instance.promocode,
      'driver': instance.driver,
      'orderItems': instance.orderItems,
    };
