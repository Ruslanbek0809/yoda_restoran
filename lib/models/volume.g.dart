// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volume.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Volume _$VolumeFromJson(Map<String, dynamic> json) => Volume(
      id: json['id'] as int?,
      volumeName: json['volume'] as String?,
      price: json['price'] as num?,
      groupId: json['group'] as int?,
    );

Map<String, dynamic> _$VolumeToJson(Volume instance) => <String, dynamic>{
      'id': instance.id,
      'volume': instance.volumeName,
      'price': instance.price,
      'group': instance.groupId,
    };
