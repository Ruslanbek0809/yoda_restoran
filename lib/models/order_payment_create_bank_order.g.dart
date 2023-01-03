// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment_create_bank_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPaymentCreateBankOrder _$OrderPaymentCreateBankOrderFromJson(
        Map<String, dynamic> json) =>
    OrderPaymentCreateBankOrder(
      orderId: json['order_id'] as String?,
      requestId: json['request_id'] as String?,
      phone: json['phone'] as String?,
      errorCode: json['errorCode'] as dynamic,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$OrderPaymentCreateBankOrderToJson(
        OrderPaymentCreateBankOrder instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'request_id': instance.requestId,
      'phone': instance.phone,
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
    };
