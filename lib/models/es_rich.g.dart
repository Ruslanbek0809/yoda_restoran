// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'es_rich.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EsRich _$EsRichFromJson(Map<String, dynamic> json) => EsRich(
      id: json['id'] as int?,
      richText: json['reachText'] as String?,
      reachRes: json['reachRes'] as int?,
      restaurant: json['restaurant'] == null
          ? null
          : Restaurant.fromJson(json['restaurant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EsRichToJson(EsRich instance) => <String, dynamic>{
      'id': instance.id,
      'reachText': instance.richText,
      'reachRes': instance.reachRes,
      'restaurant': instance.restaurant,
    };
