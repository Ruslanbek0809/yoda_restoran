// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
      id: json['id'] as int?,
      image: json['image'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      rated: json['rated'] as int?,
      rating: json['rating'] as num?,
      deliveryPrice: json['deliveryPrice'] as num?,
      description: json['description'] as String?,
      workingHours: json['workingHours'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      prepareTime: json['prepareTime'] as String?,
      paymentTypes: (json['paymentTypes'] as List<dynamic>?)
          ?.map((e) => PaymentType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'address': instance.address,
      'rated': instance.rated,
      'rating': instance.rating,
      'deliveryPrice': instance.deliveryPrice,
      'description': instance.description,
      'workingHours': instance.workingHours,
      'phoneNumber': instance.phoneNumber,
      'prepareTime': instance.prepareTime,
      'paymentTypes': instance.paymentTypes,
    };
