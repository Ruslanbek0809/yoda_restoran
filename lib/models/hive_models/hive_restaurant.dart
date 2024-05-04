import 'package:hive/hive.dart';

import 'hive_models.dart';

part 'hive_restaurant.g.dart';

@HiveType(typeId: 1)
class HiveRestaurant {
  HiveRestaurant({
    this.id,
    this.image,
    this.name,
    this.address,
    this.rated,
    this.rating,
    this.deliveryPrice,
    this.description,
    this.notification,
    this.workingHours,
    this.phoneNumber,
    this.prepareTime,
    this.city,
    this.distance,
    this.selfPickUp,
    this.delivery,
    this.resPaymentTypes,
    this.disabled,
    this.discountMeals,
    this.discountAksiya,
    this.discountCategory,
  });

  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? image;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final String? address;

  @HiveField(4)
  final int? rated;

  @HiveField(5)
  final num? rating;

  @HiveField(6)
  final num? deliveryPrice;

  @HiveField(7)
  final String? description;

  @HiveField(8)
  final String? notification;

  @HiveField(9)
  final String? workingHours;

  @HiveField(10)
  final String? phoneNumber;

  @HiveField(11)
  final String? prepareTime;

  @HiveField(12)
  final String? city;

  @HiveField(13)
  final num? distance;

  @HiveField(14)
  final bool? selfPickUp;

  @HiveField(15)
  final bool? delivery;

  @HiveField(16)
  final List<HiveResPaymentType>? resPaymentTypes;

  @HiveField(17)
  final bool? disabled;

  @HiveField(18)
  final bool? discountMeals;

  @HiveField(19)
  final bool? discountAksiya;

  @HiveField(20)
  final bool? discountCategory;
}
