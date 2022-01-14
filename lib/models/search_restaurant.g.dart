// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchRestaurant _$SearchRestaurantFromJson(Map<String, dynamic> json) =>
    SearchRestaurant(
      id: json['id'] as int?,
      image: json['image'] as String?,
      meals: (json['meals'] as List<dynamic>?)
          ?.map((e) => Meal.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      address: json['address'] as String?,
      rated: json['rated'] as int?,
      rating: json['rating'] as num?,
      deliveryPrice: json['deliveryPrice'] as num?,
      description: json['description'] as String?,
      workingHours: json['workingHours'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      prepareTime: json['prepareTime'] as String?,
    );

Map<String, dynamic> _$SearchRestaurantToJson(SearchRestaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'meals': instance.meals,
      'name': instance.name,
      'address': instance.address,
      'rated': instance.rated,
      'rating': instance.rating,
      'deliveryPrice': instance.deliveryPrice,
      'description': instance.description,
      'workingHours': instance.workingHours,
      'phoneNumber': instance.phoneNumber,
      'prepareTime': instance.prepareTime,
    };
