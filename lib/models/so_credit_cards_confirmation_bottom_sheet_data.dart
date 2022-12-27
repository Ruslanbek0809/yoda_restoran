import '../ui/cart/order/single_order_credit_cards/so_credit_cards_view_model.dart';
import 'hive_models/hive_models.dart';

class SOCreditCardsConfirmationBottomSheetData {
  SOCreditCardsConfirmationBottomSheetData({
    required this.isNewCreditCard,
    this.hiveCreditCard,
    // required this.order,
    required this.soCreditCardsViewModel,
  });
  final bool isNewCreditCard;
  final HiveCreditCard? hiveCreditCard;
  // final Order order;
  final SOCreditCardsViewModel soCreditCardsViewModel;
}
