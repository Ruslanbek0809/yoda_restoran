import 'hive_models/hive_models.dart';

class SOCreditCardsConfirmationBottomSheetData {
  SOCreditCardsConfirmationBottomSheetData({
    this.isNewCreditCard,
    this.hiveCreditCard,
  });
  final bool? isNewCreditCard;
  final HiveCreditCard? hiveCreditCard;
}
