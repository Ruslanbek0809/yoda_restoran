// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentType _$PaymentTypeFromJson(Map<String, dynamic> json) => PaymentType(
      id: json['id'] as int?,
      nameTk: json['name_tk'] as String?,
      nameRu: json['name_ru'] as String?,
    );

Map<String, dynamic> _$PaymentTypeToJson(PaymentType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_tk': instance.nameTk,
      'name_ru': instance.nameRu,
    };
