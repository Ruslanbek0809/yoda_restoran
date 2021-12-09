// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promoted.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Promoted _$PromotedFromJson(Map<String, dynamic> json) => Promoted(
      id: json['id'] as int?,
      name: json['name'] as String?,
      order: json['order'] as int?,
      restaurants: (json['restaurant'] as List<dynamic>?)
          ?.map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PromotedToJson(Promoted instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'restaurant': instance.restaurants,
    };
