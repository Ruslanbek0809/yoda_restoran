// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'res_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResCategoryModel _$ResCategoryModelFromJson(Map<String, dynamic> json) =>
    ResCategoryModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      order: json['order'] as int?,
    );

Map<String, dynamic> _$ResCategoryModelToJson(ResCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'order': instance.order,
    };
