import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  Address({
    this.id,
    this.city,
    this.street,
    this.house,
    this.apartment,
    this.floor,
    this.notes,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'city')
  final String? city;

  @JsonKey(name: 'street')
  final String? street;

  @JsonKey(name: 'house')
  final int? house;

  @JsonKey(name: 'apartment')
  final int? apartment;

  @JsonKey(name: 'floor')
  final int? floor;

  @JsonKey(name: 'notes')
  final String? notes;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
