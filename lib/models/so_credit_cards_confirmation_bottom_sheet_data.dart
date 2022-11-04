import 'hive_models/hive_models.dart';
import 'models.dart';

class SOCreditCardsConfirmationBottomSheetData {
  SOCreditCardsConfirmationBottomSheetData({
    this.isNewCreditCard,
    this.hiveCreditCard,
    this.order,
  });
  final bool? isNewCreditCard;
  final HiveCreditCard? hiveCreditCard;
  final Order? order;
}
