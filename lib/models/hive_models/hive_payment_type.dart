import 'package:hive/hive.dart';

part 'hive_payment_type.g.dart';

@HiveType(typeId: 4)
class HivePaymentType {
  HivePaymentType({
    this.id,
    this.nameTk,
    this.nameRu,
  });

  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? nameTk;

  @HiveField(2)
  final String? nameRu;
}
