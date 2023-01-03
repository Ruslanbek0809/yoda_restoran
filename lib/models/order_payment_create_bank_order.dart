import 'package:json_annotation/json_annotation.dart';

part 'order_payment_create_bank_order.g.dart';

@JsonSerializable()
class OrderPaymentCreateBankOrder {
  OrderPaymentCreateBankOrder({
    this.orderId,
    this.requestId,
    this.phone,
    this.errorCode,
    this.errorMessage,
  });

  @JsonKey(name: 'order_id')
  final String? orderId;

  @JsonKey(name: 'request_id')
  final String? requestId;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'errorCode')
  final dynamic errorCode;

  @JsonKey(name: 'errorMessage')
  final String? errorMessage;

  factory OrderPaymentCreateBankOrder.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentCreateBankOrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPaymentCreateBankOrderToJson(this);
}
