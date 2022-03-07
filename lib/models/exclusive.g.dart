// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exclusive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exclusive _$ExclusiveFromJson(Map<String, dynamic> json) => Exclusive(
      id: json['id'] as int?,
      position: json['position'] as int?,
      name: json['name'] as String?,
      order: json['order'] as int?,
      exclusiveSingles: (json['exclusives'] as List<dynamic>?)
          ?.map((e) => ExclusiveSingle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExclusiveToJson(Exclusive instance) => <String, dynamic>{
      'id': instance.id,
      'position': instance.position,
      'name': instance.name,
      'order': instance.order,
      'exclusives': instance.exclusiveSingles,
    };
