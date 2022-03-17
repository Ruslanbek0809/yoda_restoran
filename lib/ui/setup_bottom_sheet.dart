import 'package:stacked_services/stacked_services.dart';
import '../app/app.locator.dart';
import 'cart/cart_res_food/cart_more_meal_bottom_sheet_view.dart';
import 'cart/checkout/checkout_address/checkout_select_address_bottom_sheet.dart';
import '../utils/utils.dart';
import 'cart/checkout/checkout_address/checkout_add_address_bottom_sheet.dart';
import 'cart/checkout/checkout_bottom_sheet_view.dart';
import 'cart/checkout/checkout_payment_type_bottom_sheet.dart';

void setupBottomSheet() {
  final _bottomSheetService = locator<BottomSheetService>();

  final bottomSheetBuilders = {
    // BottomSheetType.mainCategory: (context, sheetRequest, completer) =>
    //     MainCatBottomSheetView(
    //       request: sheetRequest,
    //       completer: completer,
    //     ),
    // BottomSheetType.restaurantInfo: (context, sheetRequest, completer) =>
    //     RestaurantInfoBottomSheet(
    //       // request: sheetRequest,
    //       // completer: completer,
    //       restaurant: sheetRequest.data,
    //     ),
    // BottomSheetType.meal: (context, sheetRequest, completer) => MealBottomSheet(
    //       request: sheetRequest,
    //       completer: completer,
    //       meal: sheetRequest.data.meal,
    //       restaurant: sheetRequest.data.restaurant,
    //       mealViewModel: sheetRequest.data.mealViewModel,
    //     ),
    // BottomSheetType.cartMoreMeal: (context, sheetRequest, completer) =>
    //     CartMoreMealBottomSheet(
    //       request: sheetRequest,
    //       completer: completer,
    //       meal: sheetRequest.data.meal,
    //       restaurant: sheetRequest.data.restaurant,
    //       cartMoreMealViewModel: sheetRequest.data.cartMoreMealViewModel,
    //     ),
    // BottomSheetType.checkout: (context, sheetRequest, completer) =>
    //     CheckoutBottomSheetView(
    //       request: sheetRequest,
    //       completer: completer,
    //     ),
    BottomSheetType.paymentType: (context, sheetRequest, completer) =>
        CheckoutPaymentTypeBottomSheetView(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.addAddress: (context, sheetRequest, completer) =>
        CheckoutAddAddressBottomSheetView(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.selectAddress: (context, sheetRequest, completer) =>
        CheckoutSelectAddressBottomSheetView(
          request: sheetRequest,
          completer: completer,
        ),
  };

  _bottomSheetService.setCustomSheetBuilders(bottomSheetBuilders);
}
