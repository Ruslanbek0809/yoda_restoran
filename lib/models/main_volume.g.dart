// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_volume.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainVolume _$MainVolumeFromJson(Map<String, dynamic> json) => MainVolume(
      id: json['id'] as int?,
      name: json['name'] as String?,
      nameTk: json['name_tk'] as String?,
      nameRu: json['name_ru'] as String?,
      mealId: json['meal'] as int?,
      volumes: (json['volumes'] as List<dynamic>?)
          ?.map((e) => Volume.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MainVolumeToJson(MainVolume instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_tk': instance.nameTk,
      'name_ru': instance.nameRu,
      'meal': instance.mealId,
      'volumes': instance.volumes,
    };
