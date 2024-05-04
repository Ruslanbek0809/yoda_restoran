import 'package:json_annotation/json_annotation.dart';
import 'package:yoda_res/models/story.dart';

import 'models.dart';

part 'restaurant.g.dart';

@JsonSerializable(includeIfNull: true)
class Restaurant {
  Restaurant({
    this.id,
    this.image,
    this.square_image,
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
    this.notification,
    this.workingHours,
    this.phoneNumber,
    this.prepareTime,
    this.city,
    this.distance,
    this.selfPickUp,
    this.delivery,
    this.disabled,
    this.paymentTypes,
    this.stories,
    this.discountMeals,
    this.discountAksiya,
    this.discountCategory,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'square_image')
  final String? square_image;

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

  @JsonKey(name: 'notification')
  final String? notification;

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

  @JsonKey(name: 'disabled')
  final bool? disabled;

  @JsonKey(name: 'paymentTypes')
  final List<PaymentType>? paymentTypes;

  @JsonKey(name: 'stories')
  final List<Story>? stories;

  @JsonKey(name: 'discount-meals')
  final bool? discountMeals;

  @JsonKey(name: 'discount-aksiya')
  final bool? discountAksiya;

  @JsonKey(name: 'discount-category')
  final bool? discountCategory;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
