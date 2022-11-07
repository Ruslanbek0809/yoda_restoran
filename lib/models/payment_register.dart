import 'package:json_annotation/json_annotation.dart';

part 'payment_register.g.dart';

@JsonSerializable()
class PaymentRegister {
  PaymentRegister({
    this.errorCode,
    this.orderId,
    this.formUrl,
  });

  @JsonKey(name: 'errorCode')
  final String? errorCode;

  @JsonKey(name: 'orderId')
  final String? orderId;

  @JsonKey(name: 'formUrl')
  final String? formUrl;

  factory PaymentRegister.fromJson(Map<String, dynamic> json) =>
      _$PaymentRegisterFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentRegisterToJson(this);
}
