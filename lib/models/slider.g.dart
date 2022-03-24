// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SliderModel _$SliderModelFromJson(Map<String, dynamic> json) => SliderModel(
      id: json['id'] as int?,
      order: json['order'] as int?,
      image: json['image'] as String?,
      option: json['option'] as String?,
      restaurant: json['restaurant'] == null
          ? null
          : Restaurant.fromJson(json['restaurant'] as Map<String, dynamic>),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$SliderModelToJson(SliderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'image': instance.image,
      'option': instance.option,
      'url': instance.url,
      'restaurant': instance.restaurant,
    };
