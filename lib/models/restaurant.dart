import 'package:json_annotation/json_annotation.dart';
import 'package:yoda_res/models/models.dart';

part 'restaurant.g.dart';

@JsonSerializable(includeIfNull: true)
class Restaurant {
  Restaurant({
    this.id,
    this.image,
    this.name,
    this.address,
    this.rated,
    this.rating,
    this.deliveryPrice,
    this.description,
    this.workingHours,
    this.phoneNumber,
    this.prepareTime,
    this.paymentTypes,
    this.city,
    this.distance,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'address')
  final String? address;

  @JsonKey(name: 'rated')
  final int? rated;

  @JsonKey(name: 'rating')
  final num? rating;

  @JsonKey(name: 'deliveryPrice')
  final num? deliveryPrice;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'workingHours')
  final String? workingHours;

  @JsonKey(name: 'phoneNumber')
  final String? phoneNumber;

  @JsonKey(name: 'prepareTime')
  final String? prepareTime;

  @JsonKey(name: 'city')
  final String? city;

  @JsonKey(name: 'distance')
  final num? distance;

  @JsonKey(name: 'paymentTypes')
  final List<PaymentType>? paymentTypes;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
