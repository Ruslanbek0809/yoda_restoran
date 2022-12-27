import 'package:yoda_res/models/models.dart';
import '../ui/cart/order/single_order_credit_cards/so_credit_cards_view_model.dart';

class SOConfirmationBottomSheetData {
  SOConfirmationBottomSheetData({
    required this.paymentCreateBankOrder,
    required this.soCreditCardsViewModel,
  });
  final OrderPaymentCreateBankOrder paymentCreateBankOrder;
  final SOCreditCardsViewModel soCreditCardsViewModel;
}
