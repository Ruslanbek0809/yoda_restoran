// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment_check_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPaymentCheckStatus _$OrderPaymentCheckStatusFromJson(
        Map<String, dynamic> json) =>
    OrderPaymentCheckStatus(
      orderStatus: json['OrderStatus'] as int?,
      errorCode: json['ErrorCode'] as String?,
      errorMessage: json['ErrorMessage'] as String?,
      orderNumber: json['OrderNumber'] as String?,
    );

Map<String, dynamic> _$OrderPaymentCheckStatusToJson(
        OrderPaymentCheckStatus instance) =>
    <String, dynamic>{
      'OrderStatus': instance.orderStatus,
      'ErrorCode': instance.errorCode,
      'ErrorMessage': instance.errorMessage,
      'OrderNumber': instance.orderNumber,
    };
