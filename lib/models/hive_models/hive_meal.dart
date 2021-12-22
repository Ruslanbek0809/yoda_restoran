import 'package:hive/hive.dart';

part 'hive_meal.g.dart';

/// Removed description, approved, available, restaurantId, categoryId, data_begin, data_end, value, sizeId, SizeModel
/// Needed gVolumes, gCustomizes
/// Added quantity, increment
@HiveType(typeId: 0)
class HiveMeal {
  HiveMeal({
    this.id,
    this.image,
    this.name,
    this.price,
    this.discount,
    this.discountedPrice,
    this.increment,
    this.quantity,
  });

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? image;

  @HiveField(2)
  String? name;

  @HiveField(3)
  num? price;

  @HiveField(4)
  num? discount;

  @HiveField(5)
  num? discountedPrice;

  @HiveField(6)
  num? increment; // Incrementing quantity of a product for each step

  @HiveField(7)
  int? quantity;
}
