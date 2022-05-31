import 'package:hive/hive.dart';

part 'hive_rating.g.dart';

@HiveType(typeId: 5)
class HiveRating {
  HiveRating({
    this.id,
    this.resId,
    this.option,
    this.title,
    this.status,
    this.selfPickUp,
  });

  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? resId;

  @HiveField(2)
  final String? option;

  @HiveField(3)
  final String? title;

  @HiveField(4)
  final String? status;

  @HiveField(5)
  final String? selfPickUp;
}
