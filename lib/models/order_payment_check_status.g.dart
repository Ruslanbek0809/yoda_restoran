// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment_check_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPaymentCheckStatus _$OrderPaymentCheckStatusFromJson(
        Map<String, dynamic> json) =>
    OrderPaymentCheckStatus(
      orderStatus: json['OrderStatus'] as int?,
      errorCode: json['errorCode'] as String?,
      errorMessage: json['errorMessage'] as String?,
      orderNumber: json['OrderNumber'] as int?,
    );

Map<String, dynamic> _$OrderPaymentCheckStatusToJson(
        OrderPaymentCheckStatus instance) =>
    <String, dynamic>{
      'OrderStatus': instance.orderStatus,
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
      'OrderNumber': instance.orderNumber,
    };
