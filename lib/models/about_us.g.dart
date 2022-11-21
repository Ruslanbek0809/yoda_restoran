// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_us.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AboutUsModel _$AboutUsModelFromJson(Map<String, dynamic> json) => AboutUsModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      info: json['info'] as String?,
      infoTk: json['info_tk'] as String?,
      infoRu: json['info_ru'] as String?,
    );

Map<String, dynamic> _$AboutUsModelToJson(AboutUsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'info': instance.info,
      'info_tk': instance.infoTk,
      'info_ru': instance.infoRu,
    };
