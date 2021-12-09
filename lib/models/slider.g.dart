// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SliderModel _$SliderModelFromJson(Map<String, dynamic> json) => SliderModel(
      id: json['id'] as int?,
      image: json['image'] as String?,
      option: json['option'] as String?,
      url: json['url'] as String?,
      order: json['order'] as int?,
    );

Map<String, dynamic> _$SliderModelToJson(SliderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'option': instance.option,
      'url': instance.url,
      'order': instance.order,
    };
