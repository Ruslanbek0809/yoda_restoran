import 'package:hive/hive.dart';
part 'hive_credit_card.g.dart';

@HiveType(typeId: 6)
class HiveCreditCard {
  HiveCreditCard({
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
  });

  @HiveField(0)
  final String? cardNumber;

  @HiveField(1)
  final String? expiryDate;

  @HiveField(2)
  final String? cardHolderName;
}
