// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment_register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPaymentRegister _$OrderPaymentRegisterFromJson(
        Map<String, dynamic> json) =>
    OrderPaymentRegister(
      errorCode: json['errorCode'] as String?,
      errorMessage: json['errorMessage'] as String?,
      orderId: json['orderId'] as String?,
      formUrl: json['formUrl'] as String?,
    );

Map<String, dynamic> _$OrderPaymentRegisterToJson(
        OrderPaymentRegister instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
      'orderId': instance.orderId,
      'formUrl': instance.formUrl,
    };
