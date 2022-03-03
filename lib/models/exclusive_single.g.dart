// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exclusive_single.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExclusiveSingle _$ExclusiveSingleFromJson(Map<String, dynamic> json) =>
    ExclusiveSingle(
      id: json['id'] as int?,
      name: json['name'] as String?,
      order: json['order'] as int?,
      image: json['image'] as String?,
      option: json['option'] as String?,
      url: json['url'] as String?,
      richText: json['reachText'] as String?,
      // restaurant: json['restaurant'] == null
      //     ? null
      //     : Restaurant.fromJson(json['restaurant'] as Map<String, dynamic>),
      // restaurants: (json['restaurants'] as List<dynamic>?)
      //     ?.map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
      //     .toList(),
    );

Map<String, dynamic> _$ExclusiveSingleToJson(ExclusiveSingle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'image': instance.image,
      'option': instance.option,
      'url': instance.url,
      'reachText': instance.richText,
      // 'restaurant': instance.restaurant,
      // 'restaurants': instance.restaurants,
    };
