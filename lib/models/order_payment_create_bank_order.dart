import 'package:json_annotation/json_annotation.dart';

part 'order_payment_create_bank_order.g.dart';

@JsonSerializable()
class OrderPaymentCreateBankOrder {
  OrderPaymentCreateBankOrder({
    this.orderId,
    this.requestId,
  });

  @JsonKey(name: 'order_id')
  final String? orderId;

  @JsonKey(name: 'request_id')
  final String? requestId;

  factory OrderPaymentCreateBankOrder.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentCreateBankOrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPaymentCreateBankOrderToJson(this);
}
