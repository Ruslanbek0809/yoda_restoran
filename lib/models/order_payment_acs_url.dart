import 'package:json_annotation/json_annotation.dart';
part 'order_payment_acs_url.g.dart';

@JsonSerializable()
class OrderPaymentAcsUrl {
  OrderPaymentAcsUrl({
    this.info,
    this.acsUrl,
    this.paReq,
    this.termUrl,
    this.errorCode,
  });

  @JsonKey(name: 'info')
  final String? info;

  @JsonKey(name: 'acsUrl')
  final String? acsUrl;

  @JsonKey(name: 'paReq')
  final String? paReq;

  @JsonKey(name: 'termUrl')
  final String? termUrl;

  @JsonKey(name: 'errorCode')
  final int? errorCode;

  factory OrderPaymentAcsUrl.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentAcsUrlFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPaymentAcsUrlToJson(this);
}
