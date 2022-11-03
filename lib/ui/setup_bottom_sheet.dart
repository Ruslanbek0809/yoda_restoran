import 'package:stacked_services/stacked_services.dart';
import '../app/app.locator.dart';
import '../utils/utils.dart';
import 'cart/checkout/checkout_address/checkout_add_address_bottom_sheet.dart';

void setupBottomSheet() {
  final _bottomSheetService = locator<BottomSheetService>();

  final bottomSheetBuilders = {
    BottomSheetType.addAddress: (context, sheetRequest, completer) =>
        CheckoutAddAddressBottomSheetView(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.creditCardConfirmation: (context, sheetRequest, completer) =>
        CheckoutAddAddressBottomSheetView(
          request: sheetRequest,
          completer: completer,
        ),
  };

  _bottomSheetService.setCustomSheetBuilders(bottomSheetBuilders);
}
