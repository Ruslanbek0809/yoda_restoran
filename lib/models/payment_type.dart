import 'package:json_annotation/json_annotation.dart';

part 'payment_type.g.dart';

@JsonSerializable()
class PaymentType {
  PaymentType({
    this.id,
    this.nameTk,
    this.nameRu,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name_tk')
  final String? nameTk;

  @JsonKey(name: 'name_ru')
  final String? nameRu;

  factory PaymentType.fromJson(Map<String, dynamic> json) =>
      _$PaymentTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentTypeToJson(this);
}
