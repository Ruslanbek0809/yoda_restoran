import 'package:hive/hive.dart';

part 'hive_vol_cus.g.dart';

@HiveType(typeId: 2)
class HiveVolCus {
  HiveVolCus({
    this.id,
    this.name,
    this.price,
  });

  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final num? price;
}
