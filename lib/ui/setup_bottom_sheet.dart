import 'package:stacked_services/stacked_services.dart';
import '../app/app.locator.dart';
import '../utils/utils.dart';
import 'cart/checkout/checkout_address/checkout_add_address_bottom_sheet.dart';
import 'cart/order/single_order_credit_cards/so_confirmation_bottom_sheet_view.dart';
import 'cart/order/single_order_credit_cards/so_send_code_confirmation_bottom_sheet_view.dart';

void setupBottomSheet() {
  final _bottomSheetService = locator<BottomSheetService>();

  final bottomSheetBuilders = {
    BottomSheetType.addAddress: (context, sheetRequest, completer) =>
        CheckoutAddAddressBottomSheetView(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.creditCardConfirmation:
        (context, sheetRequest, completer) => SOConfirmationBottomSheetView(
              request: sheetRequest,
              completer: completer,
              soCreditCardsConfirmationBottomSheetData: sheetRequest.data,
            ),
    BottomSheetType.sendCodeConfirmation: (context, sheetRequest, completer) =>
        SOSendCodeConfirmationBottomSheetView(
          request: sheetRequest,
          completer: completer,
        ),
  };

  _bottomSheetService.setCustomSheetBuilders(bottomSheetBuilders);
}
