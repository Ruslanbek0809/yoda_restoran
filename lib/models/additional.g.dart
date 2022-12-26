// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'additional.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdditionalModel _$AdditionalModelFromJson(Map<String, dynamic> json) =>
    AdditionalModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      info: json['info'] as String?,
      infoTk: json['info_tk'] as String?,
      infoRu: json['info_ru'] as String?,
    );

Map<String, dynamic> _$AdditionalModelToJson(AdditionalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'info': instance.info,
      'info_tk': instance.infoTk,
      'info_ru': instance.infoRu,
    };
