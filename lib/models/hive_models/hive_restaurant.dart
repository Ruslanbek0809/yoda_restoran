import 'package:hive/hive.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';

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
    this.workingHours,
    this.phoneNumber,
    this.prepareTime,
    this.city,
    this.distance,
    this.selfPickUp,
    this.delivery,
    this.resPaymentTypes,
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
  final String? workingHours;

  @HiveField(9)
  final String? phoneNumber;

  @HiveField(10)
  final String? prepareTime;

  @HiveField(11)
  final String? city;

  @HiveField(12)
  final num? distance;

  @HiveField(13)
  final bool? selfPickUp;

  @HiveField(14)
  final bool? delivery;

  @HiveField(15)
  final List<HiveResPaymentType>? resPaymentTypes;
}
