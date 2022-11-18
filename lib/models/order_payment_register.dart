import 'package:json_annotation/json_annotation.dart';

part 'order_payment_register.g.dart';

@JsonSerializable()
class OrderPaymentRegister {
  OrderPaymentRegister({
    this.errorCode,
    this.errorMessage,
    this.orderId,
    this.formUrl,
  });

  @JsonKey(name: 'errorCode')
  final String? errorCode;

  @JsonKey(name: 'errorMessage')
  final String? errorMessage;

  @JsonKey(name: 'orderId')
  final String? orderId;

  @JsonKey(name: 'formUrl')
  final String? formUrl;

  factory OrderPaymentRegister.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentRegisterFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPaymentRegisterToJson(this);
}
