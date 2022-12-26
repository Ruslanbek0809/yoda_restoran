import 'hive_models/hive_models.dart';
import 'models.dart';

class SOCreditCardsConfirmationBottomSheetData {
  SOCreditCardsConfirmationBottomSheetData({
    required this.isNewCreditCard,
    this.hiveCreditCard,
    required this.order,
  });
  final bool isNewCreditCard;
  final HiveCreditCard? hiveCreditCard;
  final Order order;
}
