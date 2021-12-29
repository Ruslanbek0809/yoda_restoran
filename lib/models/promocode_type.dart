import 'package:json_annotation/json_annotation.dart';

part 'promocode_type.g.dart';

@JsonSerializable()
class PromocodeType {
  PromocodeType({
    this.id,
    this.name,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  factory PromocodeType.fromJson(Map<String, dynamic> json) =>
      _$PromocodeTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PromocodeTypeToJson(this);
}
