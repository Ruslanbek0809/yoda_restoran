import 'package:hive/hive.dart';

part 'hive_restaurant.g.dart';

/// TODO: Add payments list here
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
  });

  @HiveField(0, defaultValue: -1)

  /// TODO: Remove if not needed. Used for default ID testing
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
}
