// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exclusive_single.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExclusiveSingle _$ExclusiveSingleFromJson(Map<String, dynamic> json) =>
    ExclusiveSingle(
      id: json['id'] as int?,
      order: json['order'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      imageRu: json['imageRu'] as String?,
      option: json['option'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$ExclusiveSingleToJson(ExclusiveSingle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'name': instance.name,
      'image': instance.image,
      'imageRu': instance.imageRu,
      'option': instance.option,
      'url': instance.url,
    };
