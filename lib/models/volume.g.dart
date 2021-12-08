// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volume.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Volume _$VolumeFromJson(Map<String, dynamic> json) => Volume(
      id: json['id'] as int?,
      volume: json['volume'] as String?,
      volumeTk: json['volume_tk'] as String?,
      volumeRu: json['volume_ru'] as String?,
      price: json['price'] as num?,
      groupId: json['group'] as int?,
    );

Map<String, dynamic> _$VolumeToJson(Volume instance) => <String, dynamic>{
      'id': instance.id,
      'volume': instance.volume,
      'volume_tk': instance.volumeTk,
      'volume_ru': instance.volumeRu,
      'price': instance.price,
      'group': instance.groupId,
    };
