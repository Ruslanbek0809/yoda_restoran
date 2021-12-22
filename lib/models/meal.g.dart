// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      id: json['id'] as int?,
      image: json['image'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      approved: json['approved'] as bool?,
      discount: json['discount'] as int?,
      price: json['price'] as num?,
      discountedPrice: json['discountedPrice'] as num?,
      available: json['available'] as bool?,
      dateBegin: json['date_begin'] == null
          ? null
          : DateTime.parse(json['date_begin'] as String),
      dateEnd: json['date_end'] == null
          ? null
          : DateTime.parse(json['date_end'] as String),
      value: json['value'] as num?,
      restaurantId: json['restaurant'] as int?,
      categoryId: json['category'] as int?,
      sizeId: json['size'] as int?,
      size: json['sizeJson'] == null
          ? null
          : SizeModel.fromJson(json['sizeJson'] as Map<String, dynamic>),
      gVolumes: (json['gVolumes'] as List<dynamic>?)
          ?.map((e) => MainVolume.fromJson(e as Map<String, dynamic>))
          .toList(),
      gCustomizables: (json['gCostumizes'] as List<dynamic>?)
          ?.map((e) => MainCustomizable.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'description': instance.description,
      'approved': instance.approved,
      'discount': instance.discount,
      'price': instance.price,
      'discountedPrice': instance.discountedPrice,
      'available': instance.available,
      'date_begin': instance.dateBegin?.toIso8601String(),
      'date_end': instance.dateEnd?.toIso8601String(),
      'value': instance.value,
      'restaurant': instance.restaurantId,
      'category': instance.categoryId,
      'size': instance.sizeId,
      'sizeJson': instance.size,
      'gVolumes': instance.gVolumes,
      'gCostumizes': instance.gCustomizables,
    };
