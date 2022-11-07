// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRegister _$PaymentRegisterFromJson(Map<String, dynamic> json) =>
    PaymentRegister(
      errorCode: json['errorCode'] as String?,
      orderId: json['orderId'] as String?,
      formUrl: json['formUrl'] as String?,
    );

Map<String, dynamic> _$PaymentRegisterToJson(PaymentRegister instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'orderId': instance.orderId,
      'formUrl': instance.formUrl,
    };
