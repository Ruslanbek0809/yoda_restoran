// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customizable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customizable _$CustomizableFromJson(Map<String, dynamic> json) => Customizable(
      id: json['id'] as int?,
      customizableName: json['extraMeal'] as String?,
      price: json['price'] as num?,
      groupId: json['group'] as int?,
    );

Map<String, dynamic> _$CustomizableToJson(Customizable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'extraMeal': instance.customizableName,
      'price': instance.price,
      'group': instance.groupId,
    };
