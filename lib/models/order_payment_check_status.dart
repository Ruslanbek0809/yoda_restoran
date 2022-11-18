import 'package:json_annotation/json_annotation.dart';

part 'order_payment_check_status.g.dart';

@JsonSerializable()
class OrderPaymentCheckStatus {
  OrderPaymentCheckStatus({
    this.orderStatus,
    this.errorCode,
    this.errorMessage,
    this.orderNumber,
  });

  @JsonKey(name: 'OrderStatus')
  final int? orderStatus;

  @JsonKey(name: 'ErrorCode')
  final String? errorCode;

  @JsonKey(name: 'ErrorMessage')
  final String? errorMessage;

  @JsonKey(name: 'OrderNumber')
  final String? orderNumber;

  factory OrderPaymentCheckStatus.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentCheckStatusFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPaymentCheckStatusToJson(this);
}
