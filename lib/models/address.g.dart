// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      id: json['id'] as int?,
      city: json['city'] as String?,
      street: json['street'] as String?,
      house: json['house'] as int?,
      apartment: json['apartment'] as int?,
      floor: json['floor'] as int?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'city': instance.city,
      'street': instance.street,
      'house': instance.house,
      'apartment': instance.apartment,
      'floor': instance.floor,
      'notes': instance.notes,
    };
