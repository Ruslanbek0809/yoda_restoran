import 'package:json_annotation/json_annotation.dart';

part 'order_payment_check_status.g.dart';

@JsonSerializable()
class OrderPaymentCheckStatus {
  OrderPaymentCheckStatus({
    this.errorCode,
    this.errorMessage,
    this.orderNumber,
    this.orderStatus,
    this.actionCode,
    this.actionCodeDescription,
  });

  @JsonKey(name: 'errorCode')
  final String? errorCode;

  @JsonKey(name: 'errorMessage')
  final String? errorMessage;

  @JsonKey(name: 'orderNumber')
  final String? orderNumber;

  @JsonKey(name: 'orderStatus')
  final int? orderStatus;

  @JsonKey(name: 'actionCode')
  final int? actionCode;

  @JsonKey(name: 'actionCodeDescription')
  final String? actionCodeDescription;

  factory OrderPaymentCheckStatus.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentCheckStatusFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPaymentCheckStatusToJson(this);
}
