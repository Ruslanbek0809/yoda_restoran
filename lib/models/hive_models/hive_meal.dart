import 'package:hive/hive.dart';

part 'hive_meal.g.dart';

/// Removed description, approved, available, restaurantId, categoryId, data_begin, data_end, value, sizeId, SizeModel
/// Needed gVolumes, gCustomizes
/// Added quantity
@HiveType(typeId: 0)
class HiveMeal {
  HiveMeal({
    this.id,
    this.image,
    this.name,
    this.price,
    this.discount,
    this.discountedPrice,
    this.quantity,
  });

  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? image;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final num? price;

  @HiveField(4)
  final int? discount;

  @HiveField(5)
  final num? discountedPrice;

  @HiveField(6)
  int? quantity;
}
