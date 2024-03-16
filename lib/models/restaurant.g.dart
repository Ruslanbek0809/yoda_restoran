// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
      id: json['id'] as int?,
      image: json['image'] as String?,
      square_image: json['square_image'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      rated: json['rated'] as int?,
      rating: json['rating'] as num?,
      deliveryPrice: json['deliveryPrice'] as num?,
      description: json['description'] as String?,
      discount: json['discount'] as num?,
      hourlyDiscount: json['hourlyDiscount'] as num?,
      discountBegin: json['discountBegin'] as String?,
      discountEnd: json['discountEnd'] as String?,
      notification: json['notification'] as String?,
      workingHours: json['workingHours'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      prepareTime: json['prepareTime'] as String?,
      city: json['city'] as String?,
      distance: json['distance'] as num?,
      selfPickUp: json['selfPickUp'] as bool?,
      delivery: json['delivery'] as bool?,
      disabled: json['disabled'] as bool?,
      paymentTypes: (json['paymentTypes'] as List<dynamic>?)
          ?.map((e) => PaymentType.fromJson(e as Map<String, dynamic>))
          .toList(),
      stories: (json['stories'] as List<dynamic>?)
          ?.map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'square_image': instance.square_image,
      'name': instance.name,
      'address': instance.address,
      'rated': instance.rated,
      'rating': instance.rating,
      'deliveryPrice': instance.deliveryPrice,
      'description': instance.description,
      'discount': instance.discount,
      'hourlyDiscount': instance.hourlyDiscount,
      'discountBegin': instance.discountBegin,
      'discountEnd': instance.discountEnd,
      'notification': instance.notification,
      'workingHours': instance.workingHours,
      'phoneNumber': instance.phoneNumber,
      'prepareTime': instance.prepareTime,
      'city': instance.city,
      'distance': instance.distance,
      'selfPickUp': instance.selfPickUp,
      'delivery': instance.delivery,
      'disabled': instance.disabled,
      'paymentTypes': instance.paymentTypes,
      'stories': instance.stories,
    };
