import 'package:hive/hive.dart';

import 'hive_models.dart';

part 'hive_meal.g.dart';

/// Removed description, approved, available, restaurantId, categoryId, data_begin, data_end, value, sizeId, SizeModel
/// Needed gVolumes, gCustomizes
/// Added quantity
@HiveType(typeId: 0)
class HiveMeal {
  HiveMeal({
    this.id,
    this.image,
    this.imageCard,
    this.name,
    this.price,
    this.discount,
    this.discountedPrice,
    this.quantity,
    this.volumes,
    this.customs,
  });

  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? image;

  @HiveField(2)
  final String? imageCard;

  @HiveField(3)
  final String? name;

  @HiveField(4)
  final num? price;

  @HiveField(5)
  final int? discount;

  @HiveField(6)
  final num? discountedPrice;

  @HiveField(7)
  int? quantity;

  @HiveField(8)
  final List<HiveVolCus>? volumes;

  @HiveField(9)
  final List<HiveVolCus>? customs;
}
