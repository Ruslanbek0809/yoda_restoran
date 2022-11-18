import 'package:hive/hive.dart';
part 'hive_credit_card.g.dart';

@HiveType(typeId: 6)
class HiveCreditCard {
  HiveCreditCard({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.bankId,
    required this.bankName,
  });

  @HiveField(0)
  final String cardNumber;

  @HiveField(1)
  final String expiryDate;

  @HiveField(2)
  final String cardHolderName;

  @HiveField(3)
  final int bankId;

  @HiveField(4)
  final String bankName;
}
