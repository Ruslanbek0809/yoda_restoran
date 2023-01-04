import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'search_restaurant.g.dart';

//*TODO: Add payments list here
@JsonSerializable()
class SearchRestaurant {
  SearchRestaurant({
    this.id,
    this.image,
    this.meals,
    this.name,
    this.address,
    this.rated,
    this.rating,
    this.deliveryPrice,
    this.description,
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

  @JsonKey(name: 'meals')
  final List<Meal>? meals;

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

  @JsonKey(name: 'selfPickUp')
  final bool? selfPickUp;

  @JsonKey(name: 'delivery')
  final bool? delivery;

  @JsonKey(name: 'paymentTypes')
  final List<PaymentType>? paymentTypes;

  factory SearchRestaurant.fromJson(Map<String, dynamic> json) =>
      _$SearchRestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$SearchRestaurantToJson(this);
}
