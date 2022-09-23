import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

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
    this.discount,
    this.hourlyDiscount,
    this.discountBegin,
    this.discountEnd,
    this.workingHours,
    this.phoneNumber,
    this.prepareTime,
    this.city,
    this.distance,
    this.selfPickUp,
    this.delivery,
    this.paymentTypes,
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

  @JsonKey(name: 'discount')
  final num? discount;

  @JsonKey(name: 'hourlyDiscount')
  final num? hourlyDiscount;

  @JsonKey(name: 'discountBegin')
  final String? discountBegin;

  @JsonKey(name: 'discountEnd')
  final String? discountEnd;

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

  @JsonKey(name: 'selfPickUp')
  final bool? selfPickUp;

  @JsonKey(name: 'delivery')
  final bool? delivery;

  @JsonKey(name: 'paymentTypes')
  final List<PaymentType>? paymentTypes;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
