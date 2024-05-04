// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchRestaurant _$SearchRestaurantFromJson(Map<String, dynamic> json) =>
    SearchRestaurant(
      id: json['id'] as int?,
      image: json['image'] as String?,
      square_image: json['square_image'] as String?,
      meals: (json['meals'] as List<dynamic>?)
          ?.map((e) => Meal.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      address: json['address'] as String?,
      rated: json['rated'] as int?,
      rating: json['rating'] as num?,
      deliveryPrice: json['deliveryPrice'] as num?,
      description: json['description'] as String?,
      notification: json['notification'] as String?,
      workingHours: json['workingHours'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      prepareTime: json['prepareTime'] as String?,
      city: json['city'] as String?,
      distance: json['distance'] as num?,
      selfPickUp: json['selfPickUp'] as bool?,
      delivery: json['delivery'] as bool?,
      paymentTypes: (json['paymentTypes'] as List<dynamic>?)
          ?.map((e) => PaymentType.fromJson(e as Map<String, dynamic>))
          .toList(),
      discountMeals: json['discount-meals'] as bool?,
      discountAksiya: json['discount-aksiya'] as bool?,
      discountCategory: json['discount-category'] as bool?,
    );

Map<String, dynamic> _$SearchRestaurantToJson(SearchRestaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'square_image': instance.square_image,
      'meals': instance.meals,
      'name': instance.name,
      'address': instance.address,
      'rated': instance.rated,
      'rating': instance.rating,
      'deliveryPrice': instance.deliveryPrice,
      'description': instance.description,
      'notification': instance.notification,
      'workingHours': instance.workingHours,
      'phoneNumber': instance.phoneNumber,
      'prepareTime': instance.prepareTime,
      'city': instance.city,
      'distance': instance.distance,
      'selfPickUp': instance.selfPickUp,
      'delivery': instance.delivery,
      'paymentTypes': instance.paymentTypes,
      'discount-meals': instance.discountMeals,
      'discount-aksiya': instance.discountAksiya,
      'discount-category': instance.discountCategory,
    };
