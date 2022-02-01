// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'res_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResCategory _$ResCategoryFromJson(Map<String, dynamic> json) => ResCategory(
      id: json['id'] as int?,
      discount: json['discount'] as num?,
      dateBegin: json['date_begin'] == null
          ? null
          : DateTime.parse(json['date_begin'] as String).toLocal(),
      dateEnd: json['date_end'] == null
          ? null
          : DateTime.parse(json['date_end'] as String).toLocal(),
      order: json['order'] as int?,
      restaurantId: json['restaurant'] as int?,
      categoryId: json['category'] as int?,
      meals: (json['meal'] as List<dynamic>?)
          ?.map((e) => Meal.fromJson(e as Map<String, dynamic>))
          .toList(),
      resCategoryModel: json['categoryJson'] == null
          ? null
          : ResCategoryModel.fromJson(
              json['categoryJson'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResCategoryToJson(ResCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'discount': instance.discount,
      'date_begin': instance.dateBegin?.toIso8601String(),
      'date_end': instance.dateEnd?.toIso8601String(),
      'order': instance.order,
      'restaurant': instance.restaurantId,
      'category': instance.categoryId,
      'categoryJson': instance.resCategoryModel,
      'meal': instance.meals,
    };
