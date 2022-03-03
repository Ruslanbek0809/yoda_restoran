// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exclusive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exclusive _$ExclusiveFromJson(Map<String, dynamic> json) => Exclusive(
      id: json['id'] as int?,
      name: json['name'] as String?,
      order: json['order'] as int?,
      restaurants: (json['exclusives'] as List<dynamic>?)
          ?.map((e) => ExclusiveSingle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExclusiveToJson(Exclusive instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'exclusives': instance.restaurants,
    };
