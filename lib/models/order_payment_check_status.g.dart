// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment_check_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPaymentCheckStatus _$OrderPaymentCheckStatusFromJson(
        Map<String, dynamic> json) =>
    OrderPaymentCheckStatus(
      errorCode: json['errorCode'] as String?,
      errorMessage: json['errorMessage'] as String?,
      orderNumber: json['OrderNumber'] as String?,
      orderStatus: json['orderStatus'] as int?,
      actionCode: json['actionCode'] as int?,
      actionCodeDescription: json['actionCodeDescription'] as String?,
    );

Map<String, dynamic> _$OrderPaymentCheckStatusToJson(
        OrderPaymentCheckStatus instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
      'OrderNumber': instance.orderNumber,
      'orderStatus': instance.orderStatus,
      'actionCode': instance.actionCode,
      'actionCodeDescription': instance.actionCodeDescription,
    };
