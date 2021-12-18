// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_customizable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainCustomizable _$MainCustomizableFromJson(Map<String, dynamic> json) =>
    MainCustomizable(
      id: json['id'] as int?,
      name: json['name'] as String?,
      mealId: json['meal'] as int?,
      customizables: (json['costumizes'] as List<dynamic>?)
          ?.map((e) => Customizable.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MainCustomizableToJson(MainCustomizable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'meal': instance.mealId,
      'costumizes': instance.customizables,
    };
