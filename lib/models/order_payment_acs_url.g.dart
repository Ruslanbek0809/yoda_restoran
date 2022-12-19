// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment_acs_url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPaymentAcsUrl _$OrderPaymentAcsUrlFromJson(Map<String, dynamic> json) =>
    OrderPaymentAcsUrl(
      info: json['info'] as String?,
      acsUrl: json['acsUrl'] as String?,
      paReq: json['paReq'] as String?,
      termUrl: json['termUrl'] as String?,
      errorCode: json['errorCode'] as int?,
    );

Map<String, dynamic> _$OrderPaymentAcsUrlToJson(OrderPaymentAcsUrl instance) =>
    <String, dynamic>{
      'info': instance.info,
      'acsUrl': instance.acsUrl,
      'paReq': instance.paReq,
      'termUrl': instance.termUrl,
      'errorCode': instance.errorCode,
    };
