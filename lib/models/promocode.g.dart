// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promocode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Promocode _$PromocodeFromJson(Map<String, dynamic> json) => Promocode(
      id: json['id'] as int?,
      name: json['name'] as String?,
      quantity: json['quantity'] as int?,
      discount: json['discount'] as num?,
      text: json['text'] as String?,
      minLimit: json['minLimit'] as num?,
      promoType: json['promoType'] as int?,
      promocodeType: json['promoTypeJson'] == null
          ? null
          : PromocodeType.fromJson(
              json['promoTypeJson'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PromocodeToJson(Promocode instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'discount': instance.discount,
      'text': instance.text,
      'minLimit': instance.minLimit,
      'promoType': instance.promoType,
      'promoTypeJson': instance.promocodeType,
    };
